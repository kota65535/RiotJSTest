<app-nav>

  <a each={ links } href="#{ url }" class="{ selected: selectedId === url }">
    { name }
  </a>


  <script>
      import riot from "riot";
      import route from "riot-route";

      this.links = [
          { name: "Editor", url: "editor" },
          { name: "Config", url: "config" }
      ];

      let highlightCurrent = (id) => {
          this.selectedId = id;
          this.update()
      }

      route(highlightCurrent);

  </script>


  <style type="scss">
    @import "../css/app.scss";
    :scope {
      position: fixed;
      top: 0;
      left: 0;
      height: 100%;
      box-sizing: border-box;
      font-family: sans-serif;
      text-align: center;
      color: #666;
      background: #333;
      width: $app-nav-width;
      transition: width .2s;
    }
    /*:scope:hover {*/
    /*width: 70px;*/
    /*}*/
    a {
      display: block;
      box-sizing: border-box;
      width: 100%;
      height: 50px;
      line-height: 50px;
      padding: 0 .8em;
      color: white;
      text-decoration: none;
      background: #444;
    }
    a:hover {
      background: #666;
    }
    a.selected {
      background: teal;
    }
  </style>
</app-nav>
