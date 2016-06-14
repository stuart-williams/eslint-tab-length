'use babel'

import { is, anyPass, allPass, equals, path, contains } from 'ramda'

let isArray = is(Array)
let isStandard = anyPass([
  equals('standard'),
  allPass([isArray, contains('standard')])
])

export default (config) => {
  var indentRule = path(['rules', 'indent'], config)
  var extendsRule = path(['extends'], config)
  if (indentRule) return isArray(indentRule) ? indentRule[1] : 4
  if (isStandard(extendsRule)) return 2
}
