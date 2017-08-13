<view-config>


  <script>
      import riot from "riot";
      import route from "riot-route";
      import logger from "../logging";
      let log = logger(this.__.tagName);

      this.on('mount', () => {
          log.info(`${this.__.tagName} is mounted.`);
      });

  </script>
</view-config>
