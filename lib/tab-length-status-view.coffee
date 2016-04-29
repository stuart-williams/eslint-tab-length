fs = require('fs')
path = require('path')
glob = require('glob')

class TabLengthStatusView extends HTMLDivElement
  initialize: (@statusBar) ->
    @classList.add('tab-length-status', 'inline-block')
    @tabLengthLink = document.createElement('span')
    @tabLengthLink.classList.add('inline-block')
    @appendChild(@tabLengthLink)
    @handleEvents()

  attach: ->
    @tile = @statusBar.addRightTile(priority: 11, item: this)

  destroy: ->
    @activeItemSubscription?.dispose()
    @tile?.destroy()

  handleEvents: ->
    @activeItemSubscription = atom.workspace.onDidChangeActivePaneItem =>
      @updateTabLength()
      @updateTabLengthText()

  updateTabLength: ->
    textEditor = atom.workspace.getActiveTextEditor()

    if (!textEditor)
      return false

    currFileInfo = path.parse(textEditor.getPath())

    findESLintConfig = (dir) ->
      files = glob.sync(dir + path.sep + '.eslintrc*')
      if files.length
        try
          JSON.parse(fs.readFileSync(files[0], 'utf8'))
        catch
          {}
       else if dir != currFileInfo.root
         findESLintConfig(path.resolve(dir, '..'))

    config = findESLintConfig(currFileInfo.dir)

    if !config.rules || !config.rules.indent
      return false

    atom.config.set('editor.tabLength', config.rules.indent[1])

  updateTabLengthText: ->
    tabLength = atom.config.get('editor.tabLength') || atom.config.defaultSettings.editor.tabLength
    @tabLengthLink.textContent = "Tab Len: #{tabLength}"
    @style.display = ''

module.exports = document.registerElement('tab-length-status', prototype: TabLengthStatusView.prototype)
