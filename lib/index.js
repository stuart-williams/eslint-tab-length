var fs = require('fs');
var path = require('path');
var glob = require('glob');

module.exports = {

  setTabLength: function () {
    var tabLength;
    var config = {};
    var textEditor = atom.workspace.getActiveTextEditor();
    var currFilePath = textEditor.getPath();
    var currFileInfo = path.parse(currFilePath);

    var findESLintConfig = function (dir) {
      var files = glob.sync(dir + path.sep + '.eslintrc*');
      if (files.length) {
        config = JSON.parse(fs.readFileSync(files[0], 'utf8'));
      }
      else if (dir !== currFileInfo.root) {
        findESLintConfig(path.resolve(dir, '..'));
      }
    };

    findESLintConfig(currFileInfo.dir);

    if (!config.rules || !config.rules.indent) {
      console.log('Indent rule not found');
      return false;
    }

    tabLength = config.rules.indent[1];
    console.log('Setting tab length to:', tabLength);
    atom.config.set('editor.tabLength', tabLength);
  },

  activate: function () {
    atom.commands.add('atom-text-editor', {
      'eslint-tab-length:Set Tab Length': this.setTabLength
    });
  }

};
