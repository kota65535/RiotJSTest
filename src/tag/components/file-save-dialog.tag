<file-save-dialog>

  <!-- Save File Dialog -->
  <div id="{ opts.dialogId }" class="modal fade">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
          <h4 class="modal-title">{ opts.title }</h4>
        </div>
        <div class="modal-body">
          <div class="container-fluid">
            <div class="form-group row">
              <label class="col-sm-2 control-label" for="{ opts.dialogId + '-file-name' }">Save As:</label>
              <div class="col-sm-10">
                <input type="text" class="form-control" id="{ opts.dialogId + '-file-name' }">
              </div>
              <label class="col-sm-2 control-label" for="{ opts.dialogId + '-select-folder' }">Where:</label>
              <div class="col-sm-8">
                <input type="text" id="{ opts.dialogId + '-select-folder' }" class="form-control" readonly="readonly"
                       onclick="{ onSelectFolder }" value="{ initialFolderPath }"/>
                <input type="hidden" id="{ opts.dialogId + '-folder-id' }">
              </div>
              <button id="reset-folder" type="button" class="btn btn-primary" onclick="{ onResetFolder }"><i class="fa fa-home" aria-hidden="true"></i></button>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" id="{ opts.dialogId + '-ok' }" class="btn btn-primary" onclick="{ opts.onOk }">OK</button>
          <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        </div>
      </div>
    </div>
  </div>

  <script type="es6">

    this.initialFolderPath = "My Drive";

      this.onSelectFolder = () => {
          window.googleAPIManager.showFolderPicker((pickerEvent) => {
              if (pickerEvent.action === "picked") {
                  let folderId = pickerEvent.docs[0].id;
                  $$(`#${opts.dialogId}-folder-id`).val(folderId);
                  // 擬似的なファイルパスを取得する
                  window.googleAPIManager.getFilePath(folderId)
                      .then(path => {
                          console.log(`File path: ${path}`);
                          $$(`#${opts.dialogId}-select-folder`).val(path);
                      });
              }
          });
      };

      this.onResetFolder = () => {
          $$(`#${opts.dialogId}-select-folder`).val('My Drive');
          $$(`#${opts.dialogId}-folder-id`).val('root');
      };

  </script>

</file-save-dialog>