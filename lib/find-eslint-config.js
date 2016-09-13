var path = require('path')
var fs = require('fs')
var glob = require('glob')

module.exports = function findESLintConfig (currFileInfo) {
  var files = glob.sync(path.join(currFileInfo.dir, '.eslintrc*'))
  if (files.length) {
    try {
      return JSON.parse(fs.readFileSync(files[0], 'utf8'))
    } catch (e) {
      return {}
    }
  }
  if (currFileInfo.dir !== currFileInfo.root) {
    currFileInfo.dir = path.resolve(currFileInfo.dir, '..')
    return findESLintConfig(currFileInfo)
  }
  return {}
}
