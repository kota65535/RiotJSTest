<view-editor>

  <editor-nav is-authorized={ opts.isAuthorized }/>
  <editor-main/>

  <script>
      import riot from "riot";
      import route from "riot-route";
      import logger from "../logging";
      let log = logger(this.__.tagName);

      this.on('mount', () => {
          log.info(`is mounted.`);
          log.printOpts(opts);
      });

  </script>
</view-editor>
