<config-main>

  <p>Under construction</p>

  <canvas id="my-canvas" resize></canvas>

  <script>
    import paper from "paper";


    this.on("mount", () => {

        paper.install(this);
        paper.setup("my-canvas");
//        var path = new paper.Path.Circle({
//            center: new paper.Point(200,200),
//            radius: 30,
//            strokeColor: 'black'
//        });
//        var path = new Path.Circle({
//            center: new Point(200,200),
//            radius: 30,
//            strokeColor: 'black'
//        });
        var path = new this.Path.Circle({
            center: new this.Point(200,200),
            radius: 30,
            strokeColor: 'black'
        });
    });

  </script>


  <style type="scss">
    /*@import "../css/app.scss";*/
    /*@import "../css/editor-view.scss";*/

    /*:scope {*/
      /*position: absolute;*/
      /*top: $editor-nav-height;*/
      /*left: $app-nav-width;*/
      /*right: 0;*/
      /*!*margin-right: 0;*!*/
      /*!*margin-bottom: 130px;*!*/
      /*!*margin-left: 50px;*!*/
      /*padding: 1em;*/
      /*font-family: sans-serif;*/
      /*!*text-align: center;*!*/
      /*color: #666;*/
    /*}*/

    #my-canvas {
      width: 100%;
      height: 100%;
    }

  </style>

</config-main>
