fs = require('fs')
path = require('path')
glob = require('glob')
findESLintConfig = require('./find-eslint-config')
getIndent = require('./get-indent')

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
    @tile?.destroy()

  handleEvents: ->
    @activeItemSubscription = atom.workspace.onDidChangeActivePaneItem =>
      @updateTabLength()

  updateTabLength: ->
    textEditor = atom.workspace.getActiveTextEditor()

    if (!textEditor || !textEditor.getPath())
      return @hideTabLengthText()

    currFileInfo = path.parse(textEditor.getPath())

    if (EXT.indexOf(currFileInfo.ext) < 0)
      return @hideTabLengthText()

    config = findESLintConfig(currFileInfo)
    indent = getIndent(config)

    if !indent
      return @hideTabLengthText()

    if (atom.config.get('editor.tabLength') != indent)
      atom.config.set('editor.tabLength', indent)

    @updateTabLengthText()

  hideTabLengthText: ->
    @style.display = 'none'

  updateTabLengthText: ->
    tabLength = atom.config.get('editor.tabLength') || atom.config.defaultSettings.editor.tabLength
    @tabLengthLabel.textContent = "ESLint TabLen: #{tabLength}"
    @style.display = ''

module.exports = document.registerElement('tab-length-status', prototype: TabLengthStatusView.prototype)
