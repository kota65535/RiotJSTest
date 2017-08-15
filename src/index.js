import riot from "riot";
import "riot-hot-reload";

import "./riotcontrol.js";
import "./tags";
import stores from "./stores";

riot.control.addStore(stores);

riot.mount("app");

