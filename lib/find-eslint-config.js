'use babel'

import fs from 'fs'
import path from 'path'
import glob from 'glob'

export default function findESLintConfig (currFileInfo) {
  var files = glob.sync(`${currFileInfo.dir}${path.sep}.eslintrc*`)
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
