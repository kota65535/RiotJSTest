<editor-main>

  <label for="file-content">Content:</label>
  <div class="form-group">
    <textarea class="form-control" rows="5" id="file-content"></textarea>
  </div>


  <script type="es6">
      import riot from "riot";
      import route from "riot-route";
      import logger from "../logging";
      let log = logger(this.__.tagName);


      this.on('mount', () => {
          log.info(`is mounted.`);
      });

      riot.control.on(riot.VE.EDITOR_NAV.FILE_NEW, () => {
          log.info("file new called");
      });

      riot.control.on(riot.VE.EDITOR_NAV.FILE_OPEN, () => {
          log.info("file open called");
      });

  </script>


  <style type="scss">
    @import "../css/app.scss";
    @import "../css/editor-view.scss";

    :scope {
      position: absolute;
      top: $editor-nav-height;
      left: $app-nav-width;
      /*margin-right: 0;*/
      /*margin-bottom: 130px;*/
      /*margin-left: 50px;*/
      padding: 1em;
      font-family: sans-serif;
      text-align: center;
      color: #666;
    }

  </style>

</editor-main>
