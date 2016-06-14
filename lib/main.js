var TabLengthStatusView = require('./tab-length-status-view')
var view = null

function deactivate () {
  view.destroy()
  view = null
}

function consumeStatusBar (statusBar) {
  view = new TabLengthStatusView()
  view.initialize(statusBar)
  view.attach()
}

module.exports = {
  deactivate,
  consumeStatusBar
}
