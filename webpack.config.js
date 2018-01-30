const glob = require('glob');
const path = require('path');

module.exports = {
  entry: toObject(glob.sync('./package/slickr/packs/**/*.jsx*')),
  output: {
    path: path.resolve('dist'),
    filename: '[name]'
  },
  module: {
    rules: [
      {
        test: /\.(js|jsx)?(\.erb)?$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader'
        }
      }
    ]
  }
}

function toObject(paths) {
  var ret = {};

  paths.forEach(function(scss_path) {
    // you can define entry names mapped to [name] here
    ret[scss_path.split('/').slice(-1)[0]] = scss_path;
  });

  return ret;
}
