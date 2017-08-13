import riot from "riot";
import {StoreBase} from "./StoreBase";

const LOCAL_STORAGE_KEY = "editor";

export class EditorStore extends StoreBase {
    constructor() {
        super(LOCAL_STORAGE_KEY);
    }

    initData() {
        return {text: ""};
    }

    registerHandlers() {
        this.on(riot.VE.TEXT_CHANGED, text => {
            this.data["text"] = text;
            this.saveToStorage();
            this.trigger(riot.SE.TEXT_CHANGED, this.data["text"])
        });
    }
}

