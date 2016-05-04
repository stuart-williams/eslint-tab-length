fs = require('fs')
path = require('path')
glob = require('glob')

class TabLengthStatusView extends HTMLDivElement
  initialize: (@statusBar) ->
    @classList.add('tab-length-status', 'inline-block')
    @tabLengthLabel = document.createElement('span')
    @tabLengthLabel.classList.add('inline-block')
    @appendChild(@tabLengthLabel)
    @handleEvents()

  attach: ->
    @tile = @statusBar.addRightTile(priority: 11, item: this)

  destroy: ->
    @activeItemSubscription?.dispose()
    @configTabLengthSubscription?.dispose()
    @tile?.destroy()

  findESLintConfig: (currFileInfo) ->
    files = glob.sync(currFileInfo.dir + path.sep + '.eslintrc*')
    if files.length
      try
        return JSON.parse(fs.readFileSync(files[0], 'utf8'))
      catch
        return {}
    if currFileInfo.dir != currFileInfo.root
      return @findESLintConfig(path.resolve(currFileInfo.dir, '..'))
    return {}

  handleEvents: ->
    @activeItemSubscription = atom.workspace.onDidChangeActivePaneItem =>
      @updateTabLength()

    @configTabLengthSubscription = atom.config.observe 'editor.tabLength', () =>
      @updateTabLengthText()

  updateTabLength: ->
    textEditor = atom.workspace.getActiveTextEditor()

    if (!textEditor)
      return false

    currFileInfo = path.parse(textEditor.getPath())
    config = @findESLintConfig(currFileInfo)

    if !config.rules || !config.rules.indent
      return false

    atom.config.set('editor.tabLength', config.rules.indent[1])

  updateTabLengthText: ->
    tabLength = atom.config.get('editor.tabLength') || atom.config.defaultSettings.editor.tabLength
    @tabLengthLabel.textContent = "Tab Len: #{tabLength}"
    @style.display = ''

module.exports = document.registerElement('tab-length-status', prototype: TabLengthStatusView.prototype)
