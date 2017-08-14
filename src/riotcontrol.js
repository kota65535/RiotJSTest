/* global riot */
import riot from "riot";

var RiotControl = {
    _stores: [],
    addStore: function(store) {
        this._stores.push(store);
    },
    reset: function() {
        this._stores = [];
    }
};

['on','one','off','trigger'].forEach(function(api){
    RiotControl[api] = function() {
        var args = [].slice.call(arguments);
        this._stores.forEach(function(el){
            el[api].apply(el, args);
        });
    };
});


// since riot is auto loaded by ProvidePlugin, merge the control into the riot object
riot.control = RiotControl;

riot.SE = {
    TEXT_CHANGED: "se_text_set",
};

riot.VE = {
    APP: {
        GOOGLE_API_LOADED: "ve-app-google_api-loaded"
    },
    EDITOR_NAV: {
        EDITING_FILE_CHANGED: "ve.editor_nav.editing_file_changed",
        CONTENT_CHANGED: "ve.editor_nav.content_changed"
    },
};


// register global tag mixin for using RiotControl
riot.mixin('controlMixin', {
    onControl(signal, func) {
        riot.control.on(signal, func)
        this.on('unmount', () => riot.control.off(signal, func))
    },
})
