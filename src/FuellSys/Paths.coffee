{Action, Actions, Array, Arrays, Environment, Function, FunctionByLengthMap, FunctionByTypesPairs, FunctionTemplate, Keys, Map, Number, Object, Optional, Pair, Pairs, RegExp, Set, SortedArray, String, Strings, Text} = require "Fuell"
Path = require "./Path"

exports.byExtension = 
byExtension = (extension, paths) ->
  Array.matches ((p) -> extension == Path.extension p), paths

exports.byExtensions = 
byExtensions = (extensions, paths) ->
  Array.matches ((p) -> extension in extensions), paths

exports.union = 
union = (paths) ->
  require("path").join.apply this, paths
