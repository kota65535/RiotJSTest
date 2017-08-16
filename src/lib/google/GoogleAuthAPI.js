"use strict";
exports.__esModule = true;
var GoogleAuthAPI = (function () {
    function GoogleAuthAPI(apiKey, clientId, scope, discoverDocs, onLoaded, onSignInStatusChanged) {
        var _this = this;
        this.apiKey = apiKey;
        this.clientId = clientId;
        this.scope = scope;
        this.discoverDocs = discoverDocs;
        gapi.load('client:auth2', function () {
            gapi.client.init({
                'apiKey': _this.apiKey,
                'clientId': _this.clientId,
                'scope': _this.scope,
                'discoveryDocs': _this.discoverDocs
            }).then(function () {
                _this.authInstance = gapi.auth2.getAuthInstance();
                // Listen for sign-in state changes.
                _this.authInstance.isSignedIn.listen(onSignInStatusChanged);
                onLoaded(_this.isSignedIn());
            });
        });
    }
    GoogleAuthAPI.prototype.getCurrentUser = function () {
        return this.authInstance.currentUser.get();
    };
    GoogleAuthAPI.prototype.isSignedIn = function () {
        return this.authInstance.isSignedIn.get();
    };
    GoogleAuthAPI.prototype.signIn = function () {
        this.authInstance.signIn();
    };
    GoogleAuthAPI.prototype.signOut = function () {
        if (!this.authInstance.isSignedIn.get()) {
            console.warn("Not signed in.");
            return;
        }
        this.authInstance.signOut();
    };
    GoogleAuthAPI.prototype.revoke = function () {
        this.authInstance.disconnect();
    };
    return GoogleAuthAPI;
}());
exports.GoogleAuthAPI = GoogleAuthAPI;
