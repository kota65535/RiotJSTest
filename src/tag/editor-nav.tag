<editor-nav>

  <nav class="navbar navbar-toggleable navbar-default navbar-fixed-top">
    <div class="container-fluid">
      <div class="navbar-header">
        <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
          <span class="sr-only">Toggle navigation</span>
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
        </button>
        <!--<a class="navbar-brand" href="#">Menu</a>-->
      </div>
      <div class="navbar-collapse collapse" id="navbar">
        <ul class="nav navbar-nav">
          <li class="dropdown">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">File <span class="caret"></span></a>
            <ul class="dropdown-menu">
              <li><a onclick="{ onFileNew }">New</a></li>
              <li><a onclick="{ onFileOpen }">Open</a></li>
              <li><a onclick="{ onFileSaveAs }">Save As...</a></li>
              <li><a onclick="{ onFileSave }">Save</a></li>
              <!--<li role="separator" class="divider"></li>-->
              <!--<li class="dropdown-header">Nav header</li>-->
              <!--<li><a href="#">Separated link</a></li>-->
              <!--<li><a href="#">One more separated link</a></li>-->
            </ul>
          </li>
          <li class="dropdown">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Edit <span class="caret"></span></a>
            <ul class="dropdown-menu">
              <li><a href="#">Copy</a></li>
              <li><a href="#">Paste</a></li>
            </ul>
          </li>
        </ul>
        <ul class="nav navbar-nav navbar-right">
          <li><a onclick="{ onLogin }" if={ !opts.isAuthorized }>Login</a></li>
          <li><a onclick="{ onLogout }" if={ opts.isAuthorized }>Logout</a></li>
        </ul>
      </div><!--/.nav-collapse -->
    </div><!--/.container-fluid -->
  </nav>

  <!-- Save File Dialog -->
  <div id="file-save-as-dialog" class="modal fade">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
          <h4 class="modal-title">Save File</h4>
        </div>
        <div class="modal-body">
          <div class="container-fluid">
            <div class="form-group row">
              <label class="col-sm-2 control-label" for="file-name">Save As:</label>
              <div class="col-sm-10">
                <input type="text" class="form-control" id="file-name">
              </div>
              <label class="col-sm-2 control-label" for="select-folder">Where:</label>
              <div class="col-sm-8">
                <input type="text" id="select-folder" class="form-control" readonly="readonly" onclick="{ onFileSaveAsAt }">
                <input type="hidden" id="folder-id">
              </div>
              <button id="reset-folder" type="button" class="btn btn-primary" onclick="{ onFileSaveAsResetAt }"><i class="fa fa-home" aria-hidden="true"></i></button>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
          <button type="button" id="save-file-as" class="btn btn-primary" onclick="{ onFileSaveAsOK }">Save changes</button>
        </div>
      </div>
    </div>
  </div>


  <script type="es6">
      import riot from "riot";
      import route from "riot-route";
      import logger from "../logging";
      let log = logger(this.__.tagName);

      this.mixin("controlMixin");

      this._editingFileId = null;

      this.on('mount', () => {
          log.info(`is mounted.`);
          log.printOpts(opts);
      });


      this.onFileNew = () => {
          log.info("new clicked");
          riot.control.trigger(riot.VE.EDITOR_NAV.FILE_NEW);
      };

      this.onFileOpen = () => {
          log.info("open clicked");
          window.googleAPIManager.showFilePicker((pickerEvent) => {
              if (pickerEvent.action === "picked") {
                  let file = pickerEvent.docs[0];
                  window.googleAPIManager.downloadFile(file.id)
                      .then(resp => {
                          $$('#file-content').val(resp.body);
                          $.notify({
                              message: `File "${file.name}" loaded.`
                          }, {
                              type: 'info'
                          });
                          this._editingFileId = resp.result.id;
                      }, resp => {
                          log.error(`Failed to save file. fileId: ${resp.result.id}`);
                      });
              }
          })
      };

      //====================
      // File -> Save As
      //====================

      this.onFileSaveAs = () => {
          log.info("save as clicked");
          $$('#file-save-as-dialog').modal('show');
      };
      this.onFileSaveAsAt = () => {
          window.googleAPIManager.showFolderPicker((pickerEvent) => {
              if (pickerEvent.action === "picked") {
                  let folderId = pickerEvent.docs[0].id;
                  $$('#folder-id').val(folderId);
                  window.googleAPIManager.getFilePath(folderId)
                      .then(path => {
                          console.log(`File path: ${path}`);
                          $$('#select-folder').val(path);
                      });
              }
          })
      };

      this.onFileSaveAsResetAt = () => {
          $$('#select-folder').val('My Drive');
          $$('#folder-id').val('root');
      };

      this.onFileSaveAsOK = () => {
          let fileName = $$('#file-name').val();
          let parentId = $$('#folder-id').val();
          let content = $$('#file-content').val();

          if (!fileName) {
              $.notify({
                  message: "File name is empty."
              }, {
                  // element: "save-file-as",
                  type: "danger",
                  z_index: 10000,
                  delay: 2000,
                  placement: {
                      align: "center"
                  }
              })
              return
          }

          // ファイルを所定のフォルダに作成し、さらに中身を書き込む
          window.googleAPIManager.createFile(fileName, 'application/json', [parentId])
              .then(resp => {
                  window.googleAPIManager.updateFile(resp.result.id, content)
                      .then(resp => {
                          $.notify({
                              message: `File "${resp.result.name}", content: ${content}`
                          }, {
                              type: 'info'
                          });
                          this._editingFileId = resp.result.id;
                      }, resp => {
                          log.error(`Failed to save file. fileId: ${resp.result.id}`);
                      })
              });

          // ダイアログを閉じる
          $$('#file-save-as-dialog').modal('hide');
      };


      //====================
      // File -> Save
      //====================

      this.onFileSave = () => {
          log.info("save clicked");

          riot.control.trigger(riot.VE.EDITOR_NAV.FILE_SAVE);
      };
      this.onLogin = () => {
          log.info("login clicked");
          window.googleAPIManager.signIn();
          this.isAuthorized = window.googleAPIManager.isSignedIn();
      };
      this.onLogout = () => {
          log.info("logout clicked");
          window.googleAPIManager.signOut();
          this.isAuthorized = window.googleAPIManager.isSignedIn();
      };

  </script>


  <style type="scss">
    @import "../css/app.scss";
    @import "../css/editor-view.scss";

    :scope {
      position: fixed;
      top: 0;
      left: $app-nav-width;
      right: 0;
      z-index: 9999;
      height: $editor-nav-height;
    }

    .navbar {
      position: absolute;
      top: 0px;
    }

    a {
      cursor: pointer;
    }


  </style>
</editor-nav>
