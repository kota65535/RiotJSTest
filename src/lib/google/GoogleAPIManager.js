"use strict";
/**
 * Created by tozawa on 2017/08/06.
 */
exports.__esModule = true;
var GoogleAuthAPI_1 = require("./GoogleAuthAPI");
var GoogleDriveAPI_1 = require("./GoogleDriveAPI");
var SCOPE = 'https://www.googleapis.com/auth/docs';
var API_KEY = 'AIzaSyB6Jfd-o3v5RafVjTNnkBevhjX3_EHqAlE';
var CLIENT_ID = '658362738764-9kdasvdsndig5tsp38u7ra31fu0e7l5t.apps.googleusercontent.com';
var DISCOVER_DOCS = ['https://www.googleapis.com/discovery/v1/apis/drive/v3/rest'];
var GoogleAPIManager = (function () {
    function GoogleAPIManager(onLoaded, onSignInStatusChanged) {
        this.authAPI = new GoogleAuthAPI_1.GoogleAuthAPI(API_KEY, CLIENT_ID, SCOPE, DISCOVER_DOCS, this._onLoadedWrapper.bind(this), this._onSignInStatusChangedWrapper.bind(this));
        this.onLoaded = onLoaded;
        this.onSignInStatusChanged = onSignInStatusChanged;
        this.accessToken = null;
        this.driveAPI = new GoogleDriveAPI_1.GoogleDriveAPI(API_KEY, null);
        this.oneoffOnSignedIn = null;
    }
    /**
     * サインインする。
     * @param {function} onSignedIn サインイン成功時に呼ばれるコールバック
     */
    GoogleAPIManager.prototype.signIn = function (onSignedIn) {
        this.oneoffOnSignedIn = onSignedIn;
        this.authAPI.signIn();
    };
    GoogleAPIManager.prototype.signOut = function () {
        this.authAPI.signOut();
    };
    GoogleAPIManager.prototype.isSignedIn = function () {
        return this.authAPI.isSignedIn();
    };
    GoogleAPIManager.prototype.showFilePicker = function (callback) {
        var _this = this;
        if (this.isSignedIn()) {
            this.driveAPI.showFilePicker("root", callback);
        }
        else {
            this.signIn(function () {
                _this.driveAPI.showFilePicker("root", callback);
            });
        }
    };
    GoogleAPIManager.prototype.showFolderPicker = function (callback) {
        var _this = this;
        if (this.isSignedIn()) {
            this.driveAPI.showFolderPicker("root", callback);
        }
        else {
            this.signIn(function () {
                _this.driveAPI.showFolderPicker("root", callback);
            });
        }
    };
    GoogleAPIManager.prototype.getFilePath = function (fileId) {
        return this.driveAPI.getFilePath(fileId);
    };
    GoogleAPIManager.prototype.createFile = function (fileName, parents) {
        return this.driveAPI.createFile(fileName, "application/json", parents);
    };
    GoogleAPIManager.prototype.updateFile = function (fileId, content) {
        return this.driveAPI.updateFile(fileId, content);
    };
    GoogleAPIManager.prototype.downloadFile = function (fileId) {
        return this.driveAPI.downloadFile(fileId);
    };
    // withSignedIn(func, args) {
    //     if (this.isSignedIn()) {
    //         func.apply(args);
    //     } else {
    //         this.signIn(() => {
    //             func.apply(args);
    //         })
    //     }
    // }
    GoogleAPIManager.prototype._onLoadedWrapper = function (isSignedIn) {
        this._authorize();
        this.onLoaded(isSignedIn);
    };
    GoogleAPIManager.prototype._onSignInStatusChangedWrapper = function (isSignedIn) {
        this._authorize();
        this.onSignInStatusChanged(isSignedIn);
        // サインイン時にコールバックが与えられていたら実行する
        if (this.oneoffOnSignedIn) {
            this.oneoffOnSignedIn();
            this.oneoffOnSignedIn = null;
        }
    };
    // 認証を行い、アクセストークンを取得する
    GoogleAPIManager.prototype._authorize = function () {
        var user = this.authAPI.getCurrentUser();
        var isAuthorized = user.hasGrantedScopes(SCOPE);
        if (isAuthorized) {
            console.log(user);
            this.driveAPI.setAccessToken(user.getAuthResponse().access_token);
        }
    };
    return GoogleAPIManager;
}());
exports.GoogleAPIManager = GoogleAPIManager;
