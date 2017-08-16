<editor-main>

  <div class="container">
    <div class="form-group row">
      <label class="col-sm-2 control-label">File:</label>
      <span ref="file-name"></span>
    </div>
    <div class="form-group row">
      <label class="col-sm-2 control-label">Folder:</label>
      <span ref="folder-name"></span>
    </div>
    <div class="form-group row">
      <label class="col-sm-2 control-label" for="editor-main-file-content">Content:</label>
      <textarea class="form-control" rows="10" id="editor-main-file-content" ref="file-content"></textarea>
    </div>
  </div>


  <script>
      import riot from "riot";
      import route from "riot-route";
      import logger from "../logging";
      let log = logger(this.__.tagName);

      this.mixin("controlMixin");

      this.on('mount', () => {
          log.info(`is mounted.`);
      });

      this.onControl(riot.VE.EDITOR_NAV.EDITING_FILE_CHANGED, (editingFile) => {
          this.refs["file-name"].innerText = editingFile.name;
          this.refs["folder-name"].innerText = editingFile.parentName;
      });

      this.onControl(riot.VE.EDITOR_NAV.CONTENT_CHANGED, (content) => {
          this.refs["file-content"].value = content;
      });

      this.getContent = () => {
          return this.refs["file-content"].value;
      }


  </script>


  <style type="scss">
    @import "../css/app.scss";
    @import "../css/editor-view.scss";

    :scope {
      position: absolute;
      top: $editor-nav-height;
      left: $app-nav-width;
      right: 0;
      /*margin-right: 0;*/
      /*margin-bottom: 130px;*/
      /*margin-left: 50px;*/
      padding: 1em;
      font-family: sans-serif;
      /*text-align: center;*/
      color: #666;
    }

  </style>

</editor-main>
