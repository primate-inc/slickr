const webpack = require('webpack')
const merge = require('webpack-merge')
const sharedConfig = require('./config/webpack/shared.js')
const { settings, output } = require('./config/webpack/configuration.js')

module.exports = merge(sharedConfig, {
  devtool: 'cheap-eval-source-map',

  output: {
    pathinfo: true
  },

  devServer: {
    clientLogLevel: 'none',
    host: settings.dev_server.host,
    port: settings.dev_server.port,
    hot: settings.dev_server.hmr,
    contentBase: output.path,
    publicPath: output.publicPath,
    compress: true,
    headers: { 'Access-Control-Allow-Origin': '*' },
    historyApiFallback: true,
    watchOptions: {
      ignored: /node_modules/
    },
    stats: {
      errorDetails: true
    }
  },

  plugins: settings.dev_server.hmr ? [
    new webpack.HotModuleReplacementPlugin(),
    new webpack.NamedModulesPlugin()
  ] : []
})
