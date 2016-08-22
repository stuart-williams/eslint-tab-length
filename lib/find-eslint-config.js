'use babel'

import fs from 'fs'
import path from 'path'
import glob from 'glob'

export default (currFileInfo) => {
  let [ projectPath ] = atom.project.relativizePath(currFileInfo.dir)
  let files = glob.sync(`${projectPath}${path.sep}.eslintrc*`)

  return files.length ? JSON.parse(fs.readFileSync(files[0], 'utf8')) : {}
}
