/**
 * Created by tozawa on 2017/08/06.
 */

import {GoogleAuthAPI} from "./GoogleAuthAPI";
import {GoogleDriveAPI} from "./GoogleDriveAPI";

var SCOPE = 'https://www.googleapis.com/auth/docs';
var API_KEY = 'AIzaSyB6Jfd-o3v5RafVjTNnkBevhjX3_EHqAlE';
var CLIENT_ID = '658362738764-9kdasvdsndig5tsp38u7ra31fu0e7l5t.apps.googleusercontent.com';
var DISCOVER_DOCS = ['https://www.googleapis.com/discovery/v1/apis/drive/v3/rest'];


export class GoogleAPIManager {

    constructor(onLoaded, onSignInStatusChanged) {
        this.authAPI = new GoogleAuthAPI(
            API_KEY,
            CLIENT_ID,
            SCOPE,
            DISCOVER_DOCS,
            this.onLoadedWrapper.bind(this),
            this.onSignInStatusChangedWrapper.bind(this)
        );

        this.onLoaded = onLoaded;
        this.onSignInStatusChanged = onSignInStatusChanged;

        this.driveAPI = new GoogleDriveAPI(
            API_KEY,
            null
        )
    }

    signIn() {
        this.authAPI.signIn();
    }

    onLoadedWrapper(isSignedIn) {
        this._setAccessTokenIfAuthorized();
        this.onLoaded(isSignedIn);
        this.onSignInStatusChanged(isSignedIn);
    }

    onSignInStatusChangedWrapper(isSignedIn) {
        this.onSignInStatusChanged(isSignedIn);

    }

    _setAccessTokenIfAuthorized() {
        let user = this.authAPI.getCurrentUser();
        let isAuthorized = user.hasGrantedScopes(SCOPE);
        if (isAuthorized) {
            console.log(user);
            this.driveAPI.accessToken = user.getAuthResponse().access_token;
        }

    }

}
