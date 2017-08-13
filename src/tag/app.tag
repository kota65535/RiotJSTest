<app>

  <app-nav></app-nav>
  <div id="app-view"></div>

  <script type="es6">
      import riot from "riot";
      import route from "riot-route";
      import {GoogleAPIManager} from "../lib/google/GoogleAPIManager";
      import "../vendor";
      import logger from "../logging";
      let log = logger(this.__.tagName);

      //==========================
      // Routing & Switching views
      //==========================

      this._currentView = null;
      this.isAuthorized = false;

      this.loadView = (viewName, isAuthorized) => {
          if (this._currentView) {
              this._currentView.unmount(true)
          }
          this._currentView = riot.mount('div#app-view', viewName, {isAuthorized: isAuthorized})[0];
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
              this.update();
          }, (isAuthorized) => {
              log.info(`Auth status changed: isAuthorized=${isAuthorized}`)
              this.isAuthorized = isAuthorized;
              riot.update();
//              this.update();
//              this.loadView();
          });
      };
  </script>
</app>
