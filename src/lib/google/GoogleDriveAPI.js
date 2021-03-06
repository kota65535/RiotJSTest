"use strict";
exports.__esModule = true;
var GoogleDriveAPI = (function () {
    function GoogleDriveAPI(apiKey, accessToken) {
        this.apiKey = apiKey;
        this.accessToken = accessToken;
        gapi.load('picker', function () {
            // 今のところ何もしない
        });
    }
    GoogleDriveAPI.prototype.setAccessToken = function (accessToken) {
        this.accessToken = accessToken;
    };
    /**
     * フォルダーの表示・選択が可能なPickerを表示する。
     * @param parents
     * @param callback
     */
    GoogleDriveAPI.prototype.showFolderPicker = function (parents, callback) {
        var foldersOnlyView = new google.picker.DocsView(google.picker.ViewId.FOLDERS)
            .setParent(parents) // これを付けないと全ての階層のフォルダが列挙される
            .setIncludeFolders(true)
            .setSelectFolderEnabled(true);
        var pickerBuilder = new google.picker.PickerBuilder()
            .enableFeature(google.picker.Feature.MINE_ONLY)
            .enableFeature(google.picker.Feature.NAV_HIDDEN)
            .addView(foldersOnlyView)
            .setTitle('Select a folder')
            .setOAuthToken(this.accessToken)
            .setDeveloperKey(this.apiKey)
            .setCallback(callback);
        var pickerInstance = pickerBuilder.build();
        pickerInstance.setVisible(true);
    };
    /**
     * ドキュメントの表示・選択が可能なPickerを表示する。
     * @param {Array<string>} parents
     * @param callback
     */
    GoogleDriveAPI.prototype.showFilePicker = function (parents, callback) {
        // ファイルとフォルダー両方を表示し、ファイルの選択が可能なビュー
        var docsView = new google.picker.DocsView()
            .setIncludeFolders(true);
        // ファイルとフォルダー両方の表示・選択が可能なビュー
        var docsAndFoldersView = new google.picker.DocsView()
            .setIncludeFolders(true)
            .setSelectFolderEnabled(true);
        if (parents) {
            docsView.setParent(parents);
        }
        var pickerBuilder = new google.picker.PickerBuilder()
            .enableFeature(google.picker.Feature.MINE_ONLY)
            .enableFeature(google.picker.Feature.NAV_HIDDEN)
            .addView(docsView)
            .setOAuthToken(this.accessToken)
            .setDeveloperKey(this.apiKey)
            .setCallback(callback);
        var pickerInstance = pickerBuilder.build();
        pickerInstance.setVisible(true);
    };
    /**
     * ファイルのリストを取得する。
     * @returns {Promise}
     * @see https://developers.google.com/drive/v3/reference/files/list
     */
    GoogleDriveAPI.prototype.listFiles = function () {
        return gapi.client.drive.files.list({
            'pageSize': 10,
            'fields': "nextPageToken, files(id, name)"
        });
    };
    /**
     * ファイル情報を取得する。
     * @param {String} fileId
     * @param {String} fields
     * @returns {Promise}
     * @see https://developers.google.com/drive/v3/reference/files/get
     */
    GoogleDriveAPI.prototype.getFile = function (fileId, fields) {
        return gapi.client.drive.files.get({
            fileId: fileId,
            fields: fields
        });
    };
    /**
     * ファイルをダウンロードする。
     * @param {string} fileId
     * @returns {Promise}
     */
    GoogleDriveAPI.prototype.downloadFile = function (fileId) {
        return gapi.client.drive.files.get({
            fileId: fileId,
            alt: "media"
        });
    };
    /**
     * 指定されたファイル・フォルダのRootに対する階層を取得する。
     * Google Driveでは同一フォルダに同名のファイル・フォルダが存在でき、一意なパスというものは無いため
     * あくまでParentをRootまで辿っていった階層であることに留意。
     * @param {string} fileId
     * @returns {Promise}
     */
    GoogleDriveAPI.prototype.getFilePath = function (fileId) {
        var _this = this;
        var loop = function (fid, result) {
            return _this.getFile(fid, "id,name,parents")
                .then(function (resp) {
                result.unshift(resp.result.name);
                if (resp.result.parents) {
                    return loop(resp.result.parents[0], result);
                }
                else {
                    return resp.result.name;
                }
            });
        };
        var titles = [];
        return new Promise(function (resolve, reject) {
            loop(fileId, titles)
                .then(function () {
                resolve(titles.join("/"));
            });
            // .catch(() => {
            //     reject();
            // })
        });
    };
    /**
     * 既存のファイルの内容を更新する。
     * @param {string} fileId
     * @param {string} content
     * @returns {Promise}
     */
    GoogleDriveAPI.prototype.updateFile = function (fileId, content) {
        return gapi.client.request({
            path: '/upload/drive/v3/files/' + fileId,
            method: 'PATCH',
            params: {
                uploadType: 'media'
            },
            body: content
        });
    };
    /**
     * 空のファイルを作成する。
     * ファイルの中身を更新するにはupdateFileを呼ぶ必要がある。
     * @param {string} fileName
     * @param {string} mimeType
     * @param {Array<string>} parents
     * @returns {Promise}
     */
    GoogleDriveAPI.prototype.createFile = function (fileName, mimeType, parents) {
        var metadata = {
            mimeType: mimeType,
            name: fileName,
            fields: 'id'
        };
        if (parents) {
            metadata.parents = parents;
        }
        return gapi.client.drive.files.create({
            resource: metadata
        });
    };
    GoogleDriveAPI.prototype.createFolder = function (folderName, parents) {
        return this.createFile(folderName, 'application/vnd.google-apps.folder', parents);
    };
    /**
     * リクエストを作成する
     * @param method
     * @param url
     * @returns {Promise}
     * @private
     */
    GoogleDriveAPI.prototype._makeRequest = function (method, url) {
        var _this = this;
        return new Promise(function (resolve, reject) {
            var xhr = new XMLHttpRequest();
            var status;
            xhr.open(method, url);
            xhr.setRequestHeader('Authorization', 'Bearer ' + _this.accessToken);
            xhr.setRequestHeader('Access-Control-Allow-Origin', '*');
            xhr.onload = function () {
                if (status >= 200 && status < 300) {
                    resolve(xhr.response);
                }
                else {
                    reject({
                        status: status,
                        statusText: xhr.statusText
                    });
                }
            };
            xhr.onerror = function () {
                reject({
                    status: status,
                    statusText: xhr.statusText
                });
            };
            xhr.send();
        });
    };
    return GoogleDriveAPI;
}());
exports.GoogleDriveAPI = GoogleDriveAPI;
