var inherits = require('./inherits')
var validExtensions = ['.js', '.jsx', '.coffee']

var TabLengthStatusView = function () {
  return TabLengthStatusView.__super__.constructor.apply(this, arguments)
}

inherits(TabLengthStatusView, HTMLDivElement)

TabLengthStatusView.prototype.initialize = function (statusBar) {
  this.statusBar = statusBar
  this.classList.add('tab-length-status', 'inline-block')
  this.tabLengthLabel = document.createElement('span')
  this.tabLengthLabel.classList.add('inline-block')
  this.appendChild(this.tabLengthLabel)
  this.handleEvents()
  if (atom.workspace.getActiveTextEditor()) {
    this.updateTabLength()
  }
}

TabLengthStatusView.prototype.attach = function () {
  this.tile = this.statusBar.addRightTile({ priority: 11, item: this })
}

TabLengthStatusView.prototype.destroy = function () {
  this.activeItemSubscription.dispose()
  this.tile.destroy()
}

TabLengthStatusView.prototype.handleEvents = function () {
  var self = this
  this.activeItemSubscription = atom.workspace.onDidChangeActivePaneItem(function () {
    self.updateTabLength()
  })
}

TabLengthStatusView.prototype.updateTabLength = function () {
  var editor = atom.workspace.getActiveTextEditor()

  if (!editor || !editor.getPath()) return this.hideTabLengthText()

  var info = require('path').parse(editor.getPath())

  if (validExtensions.indexOf(info.ext) < 0) return this.hideTabLengthText()

  var config = require('./find-eslint-config')(info)
  var indent = require('./get-indent')(config)

  if (!indent) return this.hideTabLengthText()

  if (atom.config.get('editor.tabLength') !== indent) {
    atom.config.set('editor.tabLength', indent)
  }

  this.updateTabLengthText()
}

TabLengthStatusView.prototype.hideTabLengthText = function () {
  this.style.display = 'none'
}

TabLengthStatusView.prototype.updateTabLengthText = function () {
  var tabLength = atom.config.get('editor.tabLength') || atom.config.defaultSettings.editor.tabLength
  this.tabLengthLabel.textContent = 'ESLint TabLen: ' + tabLength
  this.style.display = ''
}

module.exports = document.registerElement('tab-length-status', { prototype: TabLengthStatusView.prototype })
