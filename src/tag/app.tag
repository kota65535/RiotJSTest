<app>

  <app-nav></app-nav>
  <!-- Tag based routing -->
  <!--<router>-->
    <!--<route path="editor">-->
      <!--<view-editor is-authorized={ parent.parent.isAuthorized }/>-->
    <!--</route>-->
    <!--<route path="config">-->
      <!--<view-config/>-->
    <!--</route>-->
  <!--</router>-->

  <div data-is={ view } is-authorized="{ isAuthorized }"></div>
  <!--<view-editor is-authorized={ isAuthorized }/>-->


  <script>
      import riot from "riot";
      import route from "riot-route/lib/tag";
      import {GoogleAPIManager} from "../lib/google/GoogleAPIManager";
      import "../vendor";
      import logger from "../logging";
      let log = logger(this.__.tagName);

      //==========================
      // Routing & Switching views
      //==========================
      this.isAuthorized = false;

      route((view) => {
          switch (view) {
              case "editor":
                  this.view = "view-editor";
                  break;
              case "config":
                  this.view = "view-config";
                  break;
          }
          this.update();
      });

      this.on('mount', () => {
          route.start(true);
      });

      //==========================
      // Loading Google API client
      //==========================

      riot.control.on(riot.VE.APP.GOOGLE_API_LOADED, () => {
          log.info("Google API client loaded.")
      });

      window.onGoogleAPIClientLoad = () => {
          window.googleAPIManager = new GoogleAPIManager( (isAuthorized) => {
              log.info(`Google auth API loaded: isAuthorized=${isAuthorized}`)
              this.isAuthorized = isAuthorized;
              route.exec();
          }, (isAuthorized) => {
              log.info(`Auth status changed: isAuthorized=${isAuthorized}`)
              this.isAuthorized = isAuthorized;
              route.exec();
          });
      };


      //====================
      // Notification setting
      //====================

      $.notifyDefaults({
          z_index: 10000
      });
  </script>
</app>
