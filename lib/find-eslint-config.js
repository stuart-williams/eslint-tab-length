'use babel'

import fs from 'fs'
import path from 'path'
import glob from 'glob'

export default (currFileInfo) => {
  var projRoot = atom.project.getDirectories()[0].path
  var files = glob.sync(`${projRoot}${path.sep}.eslintrc*`)
  if (files.length) {
    try {
      return JSON.parse(fs.readFileSync(files[0], 'utf8'))
    } catch (e) {
      return {}
    }
  }
  return {}
}
