{Action, Actions, Array, Arrays, Environment, Function, FunctionByLengthMap, FunctionByTypesPairs, FunctionTemplate, Keys, Map, Number, Object, Optional, Pair, Pairs, RegExp, Set, SortedArray, String, Strings, Text} = require "Fuell"

exports.log =
log = (options..., x) ->
  [depth, showHidden] = options
  console.log require("util").inspect(x, showHidden ? false, depth ? 10)