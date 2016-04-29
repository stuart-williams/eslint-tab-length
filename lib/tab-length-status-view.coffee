# View to show the tab length in the status bar.
class TabLengthStatusView extends HTMLDivElement
  initialize: (@statusBar, @tabLengths) ->
    @classList.add('tab-length-status', 'inline-block')
    @tabLengthLink = document.createElement('a')
    @tabLengthLink.classList.add('inline-block')
    @tabLengthLink.href = '#'
    @appendChild(@tabLengthLink)
    @handleEvents()

  attach: ->
    @tile = @statusBar.addRightTile(priority: 11, item: this)

  handleEvents: ->
    @activeItemSubscription = atom.workspace.onDidChangeActivePaneItem =>
      @subscribeToActiveTextEditor()

    @subscribeToActiveTextEditor()

  destroy: ->
    @activeItemSubscription?.dispose()
    @tile?.destroy()

  getActiveTextEditor: ->
    atom.workspace.getActiveTextEditor()

  subscribeToActiveTextEditor: ->
    @updateTabLengthText()

  updateTabLengthText: ->
    tabLength = atom.config.get('editor.tabLength') || atom.config.defaultSettings.editor.tabLength
    @tabLengthLink.textContent = "Tab Length: #{tabLength}"
    @style.display = ''

module.exports = document.registerElement('tab-length-status', prototype: TabLengthStatusView.prototype)
