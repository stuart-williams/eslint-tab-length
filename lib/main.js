'use babel'

import TabLengthStatusView from './tab-length-status-view'

let view = null

function deactivate () {
  view.destroy()
  view = null
}

function consumeStatusBar (statusBar) {
  view = new TabLengthStatusView()
  view.initialize(statusBar)
  view.attach()
}

export default {
  deactivate,
  consumeStatusBar
}
