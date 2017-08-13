<app>

  <app-nav></app-nav>
  <!--<router>-->
    <!--<route path="editor">-->
      <!--<view-editor is-authorized={ true }/>-->
    <!--</route>-->
    <!--<route path="config">-->
      <!--<view-config/>-->
    <!--</route>-->
  <!--</router>-->
  <div ref="view"></div>


  <script type="es6">
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

      this.loadView = (viewName, isAuthorized) => {
          if (this.refs.view._tag) {
              this.refs.view._tag.unmount(true) //true to keep the element
          }
          riot.mount(this.refs.view, viewName, {isAuthorized: isAuthorized})[0];
      };

      route((view) => {
          switch (view) {
              case "editor":
                  this.loadView("view-editor", this.isAuthorized);
                  break;
              case "config":
                  this.loadView("view-config");
                  break;
          }
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
      // Notification
      //====================

      $.notifyDefaults({
          z_index: 10000
      });
  </script>
</app>
