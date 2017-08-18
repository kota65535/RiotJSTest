// import {GoogleAuthAPI} from "../src/lib/google/GoogleAuthAPI";
//
// describe('GoogleAuthAPI', () => {
//     it('Load google API', (done) => {
//         let googleAuth = new GoogleAuthAPI(
//             'AIzaSyB6Jfd-o3v5RafVjTNnkBevhjX3_EHqAlE',
//             '658362738764-9kdasvdsndig5tsp38u7ra31fu0e7l5t.apps.googleusercontent.com',
//             'https://www.googleapis.com/auth/docs',
//             ['https://www.googleapis.com/discovery/v1/apis/drive/v3/rest'],
//             () => {
//                 done();
//                 assert(false);
//             }, () => {
//                 done();
//                 assert(false);
//             });
//     })
// });
import riot from "riot";
import "riot-hot-reload";

import "../src/riotcontrol.js";
import "../src/tags";
import stores from "../src/stores";

describe('App', function() {
    beforeEach(function() {
        // create mounting points
        var html = document.createElement('app')
        document.body.appendChild(html)
    })

    it('mounts the tag', function() {
        riot.mount('app')
        expect(document.querySelector('app-nav'))
            .toBeTruthy();
    })
});

