/**
 * Created by tozawa on 2017/07/17.
 */

import logdown from "logdown";
import {sprintf} from "sprintf-js"

// 全てのログインスタンスを有効にする
localStorage.debug = "*";

export default function getLogger(name) {
    let logger = logdown(name);

    logger.printOpts = (opts) => {
        let ary = [];
        for (let [k, v] of Object.entries(opts)) {
            ary.push(`${k}: ${v}`);
        }
        logger.info(`opts: ${ary.join(", ")}`);
    };

    return  logger;
};
