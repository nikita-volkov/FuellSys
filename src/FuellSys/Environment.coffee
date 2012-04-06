{Action, Actions, Array, Arrays, Environment, Function, FunctionByLengthMap, FunctionByTypesPairs, FunctionTemplate, Keys, Map, Number, Object, Optional, Pair, Pairs, RegExp, Set, SortedArray, String, Strings, Text} = require "Fuell"
FS = require "fs"

exports.tmpDir = 
tmpDir = Function.disposable ->
  for p in (process.env[v] for v in ['TMPDIR', 'TMP', 'TEMP']).concat "/tmp"
    return p if p && FS.realpathSync p
  throw "Can't detect temporary directory"

exports.uniqueName = 
uniqueName = ->
  Strings.interlayedUnion "-", [ 
    process.pid
    new Date().getTime()
    (Math.random() * 0x100000000 + 1).toString(36)
  ]


