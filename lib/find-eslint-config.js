var path = require('path')
var fs = require('fs')
var os = require('os')
var glob = require('glob')
var requireFromString = require('require-from-string')

module.exports = function findESLintConfig (currFileInfo) {
  var files = glob.sync(path.join(currFileInfo.dir, '.eslintrc*'))
  if (files.length) {
    try {
      var fileFound = files[0];
      var fileContents = fs.readFileSync(fileFound, 'utf8')
      return fileFound.substring(fileFound.length - 3, fileFound.length) === '.js'
        ? requireFromString(fileContents)
        : JSON.parse(fileContents)
    } catch (e) {
      return {}
    }
  }
  if (currFileInfo.dir !== currFileInfo.root) {
    currFileInfo.dir = path.resolve(currFileInfo.dir, '..')
    return findESLintConfig(currFileInfo)
  }
  if (currFileInfo.dir !== os.homedir()) {
    return findESLintConfig({
        dir: os.homedir()
    })
  }
  return {}
}
