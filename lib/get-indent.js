var R = require('ramda')

var isArray = R.is(Array)
var isStandard = R.anyPass([
  R.equals('standard'),
  R.allPass([isArray, R.contains('standard')])
])

module.exports = function (config) {
  var indentRule = R.path(['rules', 'indent'], config)
  var extendsRule = R.path(['extends'], config)
  if (indentRule) return isArray(indentRule) ? indentRule[1] : 4
  if (isStandard(extendsRule)) return 2
}
