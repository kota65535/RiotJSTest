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
              <li if="{ _editingFileId }">
                <a onclick="{ onFileSave }">Save</a>
              </li>
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

  <file-save-dialog dialog-id="file-new-dialog" title="New File" on-ok="{ onFileNewOK }"/>
  <file-save-dialog dialog-id="file-save-as-dialog" title="Save File As" on-ok="{ onFileSaveAsOK }"/>


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

      this.setEditingFileId = (fileId) => {
          this._editingFileId = fileId;
          this.update();
      };

      //====================
      // File -> New
      //====================

      this.onFileNew = () => {
          log.info("new clicked");
          $$('#file-new-dialog').modal('show');
      };

      this.onFileNewOK = () => {
          let fileName = $$('#file-new-dialog-file-name').val();
          let parentId = $$('#file-new-dialog-folder-id').val();

          if (!fileName) {
              $.notify({
                  message: "File name is empty.",
//                  element: "save-file-as",
                  type: "danger",
                  delay: 2000,
                  placement: { align: "center" }
              });
              return;
          }

          // ファイルを所定のフォルダに作成する
          window.googleAPIManager.createFile(fileName, 'application/json', [parentId])
              .then(resp => {
                  $.notify({
                      message: `File "${resp.result.name}" created.`,
                      type: 'info'
                  });
                  this.setEditingFileId(resp.result.id);
              });

          // ダイアログを閉じる
          $$('#file-new-dialog').modal('hide');
      };

      //====================
      // File -> Open
      //====================

      this.onFileOpen = () => {
          log.info("open clicked");
          window.googleAPIManager.showFilePicker((pickerEvent) => {
              if (pickerEvent.action === "picked") {
                  let file = pickerEvent.docs[0];
                  window.googleAPIManager.downloadFile(file.id)
                      .then(resp => {
                          $$('#file-content').val(resp.body);
                          $.notify({
                              message: `File "${file.name}" loaded.`,
                              type: 'info'
                          });
                          this.setEditingFileId(file.id);
                      }, resp => {
                          $.notify({
                              message: `Failed to save file. fileId: ${resp.result.id}`,
                              type: 'danger'
                          });
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

      this.onFileSaveAsOK = () => {
          let fileName = $$('#file-save-as-dialog-file-name').val();
          let parentId = $$('#file-save-as-dialog-folder-id').val();
          let content = $$('#file-content').val();

          if (!fileName) {
              $.notify({
                  message: "File name is empty.",
                  // element: "save-file-as",
                  type: "danger",
                  delay: 2000,
                  placement: {
                      align: "center"
                  }
              });
              return
          }

          // ファイルを所定のフォルダに作成し、さらに中身を書き込む
          window.googleAPIManager.createFile(fileName, 'application/json', [parentId])
              .then(resp => {
                  window.googleAPIManager.updateFile(resp.result.id, content)
                      .then(resp => {
                          $.notify({
                              message: `File "${resp.result.name}" saved, content: ${content}`,
                              type: 'info'
                          });
                          this.setEditingFileId(resp.result.id);
                      }, resp => {
                          $.notify({
                              message: `Failed to save file. fileId: ${resp.result.id}`,
                              type: 'danger'
                          });
                      })
              });

          // ダイアログを閉じる
          $$('#file-save-as-dialog').modal('hide');
      };


      //====================
      // File -> Save
      //====================

      this.onFileSave = () => {
          let content = $$('#file-content').val();

          window.googleAPIManager.updateFile(this._editingFileId, content)
              .then(resp => {
                  $.notify({
                      message: `File "${resp.result.name}" saved, content: ${content}`,
                      type: 'info'
                  });
              }, resp => {
                  $.notify({
                      message: `Failed to save file. fileId: ${resp.result.id}`,
                      type: 'danger'
                  });
              })
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
