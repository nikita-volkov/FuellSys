{Action, Actions, Array, Arrays, Environment, Function, Keys, Map, Number, Object, Optional, Pair, Pairs, String, Strings} = require "../FueL"
FS = require "fs"
Path = require "./Path"
Dir = require "./Dir"

exports.exists =
exists = (p) -> (try FS.statSync p)?.isFile() ? false

exports.contents = 
contents = (f) -> try FS.readFileSync f, "utf8"


exports.remove = 
remove = FS.unlink

exports.save = 
save = (data, file, cb) -> 
  Dir.create (Path.dir file), -> 
    FS.writeFile file, data, "utf8", cb

# exports.copy = 
# copy = (target, source) ->
#   throw "todo: File.copy"