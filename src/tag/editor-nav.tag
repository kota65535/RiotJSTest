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
          <li><a href="./login" if={ !opts.isAuthorized }>Login</a></li>
          <li><a href="./logout" if={ opts.isAuthorized }>Logout</a></li>
        </ul>
      </div><!--/.nav-collapse -->
    </div><!--/.container-fluid -->
  </nav>

  <!-- Save File Dialog -->
  <div id="save-file-as-dialog" class="modal fade">
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
                <input type="text" id="select-folder" class="form-control" readonly="readonly">
                <input type="hidden" id="folder-id">
              </div>
              <button id="reset-folder" type="button" class="btn btn-primary"><i class="fa fa-home" aria-hidden="true"></i></button>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
          <button type="button" id="save-file-as" class="btn btn-primary">Save changes</button>
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

      this.on('mount', () => {
          log.info(`is mounted.`);
          log.printOpts(opts);
      });


      this.onFileNew = () => {
          log.info("new clicked");
          riot.control.trigger(riot.VE.EDITOR_NAV.FILE_NEW);
      }
      this.onFileOpen = () => {
          log.info("open clicked");
          riot.control.trigger(riot.VE.EDITOR_NAV.FILE_OPEN);
      }
      this.onFileSaveAs = () => {
          log.info("save as clicked");
          $$('#save-file-as-dialog').modal('show');
          riot.control.trigger(riot.VE.EDITOR_NAV.FILE_SAVE_AS);
      }
      this.onFileSave = () => {
          log.info("save clicked");
          riot.control.trigger(riot.VE.EDITOR_NAV.FILE_SAVE);
      }



      riot.control.on(riot.VE.APP.GOOGLE_API_LOADED, () => {

      })

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
