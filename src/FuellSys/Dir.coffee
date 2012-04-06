{Action, Actions, Array, Arrays, Environment, Function, Keys, Map, Number, Object, Optional, Pair, Pairs, String, Strings} = require "../FueL"
FS = require "fs"
Path = require "./Path"

exports.exists =
exists = (p) -> (try FS.statSync p)?.isDirectory() ? false

exports.deepPaths = 
deepPaths = (p) ->
  if exists p
    ps = paths p
    Arrays.union Array.appendedWith ps, Array.results deepPaths, ps

exports.paths = 
paths = (p) -> p + "/" + sp for sp in FS.readdirSync p

exports.dirs = 
dirs = (p) -> p1 for name in FS.readdirSync p when exists p1 = p + "/" + name

exports.deepPathsWithExtension = 
deepPathsWithExtension = (extension, dir) ->
  Optional.result(
    [Array.matches, [[Object.equals, extension], Path.extension]]
    deepPaths dir
  )
# deepPathsWithExtension = (extension, dir) ->
#   Optional.result(
#     (ps) -> Array.matches ((p) -> extension == Path.extension p), ps
#     deepPaths dir
#   )
# deepPathsWithExtension = (extension, dir) ->
#   Array.matches ((p) -> extension == Path.extension p), deepPaths dir




exports.clean = 
clean = (dir, cb) -> 
  if exists dir
    # Array.collect Path.remove, (paths dir), cb
    removeContents dir, cb
  else 
    create dir, cb
  # remove dir, -> create dir, cb

exports.create = 
create = Path.createDir

exports.removeContents = 
removeContents = (dir, cb) ->
  [dirs, files] = Array.spread exists, paths dir
  Actions.callParallelly(
    Arrays.union [
      Array.results ((file) -> (cb) -> FS.unlink file, cb), files
      Array.results ((dir) -> (cb) -> remove dir, cb), dirs
    ]
    cb
  )

exports.remove = 
remove = Action.conditional exists, (dir, cb) ->
  removeContents dir, -> FS.rmdir dir, cb

  # [dirs, files] = Array.spread exists, paths dir
  # removeContents = Actions.parallel Arrays.union [
  #   Array.results ((file) -> (cb) -> FS.unlink file, cb), files
  #   Array.results ((dir) -> (cb) -> remove dir, cb), dirs
  # ]
  # removeContents -> FS.rmdir dir, -> cb()
