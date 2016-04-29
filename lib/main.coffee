tabLengthStatusView = null

module.exports =

  deactivate: ->
    tabLengthStatusView?.destroy()
    tabLengthStatusView = null

  consumeStatusBar: (statusBar) ->
    TabLengthStatusView = require './tab-length-status-view'
    tabLengthStatusView = new TabLengthStatusView()
    tabLengthStatusView.initialize(statusBar)
    tabLengthStatusView.attach()
