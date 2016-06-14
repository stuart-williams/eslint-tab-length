var fs = require('fs')
var path = require('path')
var glob = require('glob')

module.exports = (currFileInfo) => {
  var files = glob.sync(currFileInfo.dir + path.sep + '.eslintrc*')
  if (files.length) {
    try {
      return JSON.parse(fs.readFileSync(files[0], 'utf8'))
    } catch (e) {
      return {}
    }
  }
  if (currFileInfo.dir !== currFileInfo.root) {
    currFileInfo.dir = path.resolve(currFileInfo.dir, '..')
    return module.exports(currFileInfo)
  }
  return {}
}
