var webpack = require("webpack");
module.exports = {
    context: __dirname + '/src',

    entry: "./index.js",

    output: {
        path: __dirname + '/dist',
        publicPath: '/',
        filename: "./bundle.js"
    },

    module: {
        loaders: [
            {
                test: /\.tag$/,
                exclude: /node_modules/,
                use: {
                    loader: 'riot-tag-loader',
                    options: {
                        type: 'es6', // transpile the riot tags using babel
                        hot: true,
                        debug: true
                    }
                },
            },
            {
                test: /\.tsx?$/,
                loader: "ts-loader"
            },
            {
                test: /\.css$/,
                use: ['style-loader', 'css-loader']
            },
            {
                test: /\.scss$/,
                use: [{
                    loader: "style-loader" // creates style nodes from JS strings
                }, {
                    loader: "css-loader" // translates CSS into CommonJS
                }, {
                    loader: "sass-loader" // compiles Sass to CSS
                }]
            },
            {
                test: /\.eot(\?v=\d+\.\d+\.\d+)?$/,
                loader: 'file-loader'
            },
            {
                test: /\.(woff|woff2)$/,
                use: {
                    loader: 'url-loader',
                    options: {
                        limit: 10000,
                        mimetype: 'application/font-woff',
                    }
                },
            },
            {
                test: /\.ttf(\?v=\d+\.\d+\.\d+)?$/,
                use: {
                    loader: 'url-loader',
                    options: {
                        limit: 10000,
                        mimetype: 'application/octet-stream',
                    }
                },
            },
            {
                test: /\.svg(\?v=\d+\.\d+\.\d+)?$/,
                use: {
                    loader: 'url-loader',
                    options: {
                        limit: 10000,
                        mimetype: 'image/svg+xml',
                    }
                },
            },
        ]
    },

    plugins: [
        // for bootstrap 4
        new webpack.ProvidePlugin({
            $: 'jquery',
            jQuery: 'jquery',
            'window.jQuery': 'jquery',
            Popper: ['popper.js', 'default'],
            "Tether": 'tether',
            $$: 'jquery-selector-cache',
            _: 'lodash'
        })
    ],

    resolve: {
        extensions: [".webpack.js", ".web.js", ".ts", ".tsx", ".js"]
    },


    devtool: "source-map"
}