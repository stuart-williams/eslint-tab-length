fs = require('fs')
path = require('path')
glob = require('glob')

EXT = ['.js', '.jsx']

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
      currFileInfo.dir = path.resolve(currFileInfo.dir, '..');
      return @findESLintConfig(currFileInfo)
    return {}

  handleEvents: ->
    @activeItemSubscription = atom.workspace.onDidChangeActivePaneItem =>
      @updateTabLength()

    @configTabLengthSubscription = atom.config.observe 'editor.tabLength', () =>
      @updateTabLength()

  updateTabLength: ->
    textEditor = atom.workspace.getActiveTextEditor()

    if (!textEditor)
      return @hideTabLengthText()

    currFileInfo = path.parse(textEditor.getPath())

    if (EXT.indexOf(currFileInfo.ext) < 0)
      return @hideTabLengthText()

    config = @findESLintConfig(currFileInfo)

    if !config.rules || !config.rules.indent
      return @hideTabLengthText()

    indent = if Array.isArray(config.rules.indent) then config.rules.indent[1] else config.rules.indent;

    if (atom.config.get('editor.tabLength') != indent)
      atom.config.set('editor.tabLength', indent)
    else
      @updateTabLengthText()

  hideTabLengthText: ->
    @style.display = 'none'

  updateTabLengthText: ->
    tabLength = atom.config.get('editor.tabLength') || atom.config.defaultSettings.editor.tabLength
    @tabLengthLabel.textContent = "ESLint TabLen: #{tabLength}"
    @style.display = ''

module.exports = document.registerElement('tab-length-status', prototype: TabLengthStatusView.prototype)
