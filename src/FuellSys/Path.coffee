{Action, Actions, Array, Arrays, Environment, Function, Keys, Map, Number, Object, Optional, Pair, Pairs, String, Strings} = require "../FueL"
FS = require "fs"
Path = require "path"

exports.normalized = 
normalized = 
exports.correct = 
correct = (p) -> 
  String.replacing /^\.\/|^\.$/, "",
  String.replacing /\/+/g, "/", 
  p

exports.withoutExtension = 
withoutExtension = (p) -> Strings.interlayedUnion "", Array.allButLast parts p
  
exports.extension = 
extension = (p) -> Array.member 2, parts p

exports.fileName = 
fileName = (p) -> Array.member 1, parts p

exports.name = 
name = (p) ->
  Strings.interlayedUnion ".", 
  Array.results Object.self, 
  Array.dropping 1, parts p


exports.dir = 
dir = (p) -> Array.member 0, parts p

exports.parts = 
parts = (p) ->
  String.extracts /^(.*?\/)?([^\/]+?)?(?:\.([^\/\.]*))?$/, p

exports.relative = # deprecated
exports.relativeTo = 
relativeTo = (to, from) -> 
  to = String.splitBy "/", simplified correct to
  from = Array.allButLast String.splitBy "/", simplified correct from
  throw "Either both paths must be absolute or none" if (to[0] == "") != (from[0] == "")

  while to[0]? && to[0] == from[0]
    to.shift(); from.shift()

  Strings.interlayedUnion "/", Array.union to, Number.times "..", Array.length from

exports.simplified = 
simplified = (p) ->
  p = String.splitBy "/", p
  r = []; debt = 0
  for it in Array.reversed p
    if it == ".." then debt++
    else if debt > 0 then debt--
    else r.push it
  if debt > 0 
    r = Array.union (Number.times "..", debt), r
  Strings.interlayedUnion "/", Array.reversed r



exports.exists = 
exists = Path.existsSync

exports.remove = 
remove = (p, cb) ->
  if not exists p
    cb()
  else
    if FS.statSync(p).isFile()
      FS.unlink p, cb
    else 
      Array.collect remove, (paths p), -> FS.rmdir p, cb






exports.fileExists = 
fileExists = (p) -> (try FS.statSync p)?.isFile() ? false

exports.dirExists =
dirExists = (p) -> (try FS.statSync p)?.isDirectory() ? false

exports.copy = 
copy = (target, src, cb) ->
  if dirExists src then copyDir target, src, cb
  else if fileExists src then copyFile target, src, cb
  else throw "Path.copy: Path doesn't exist"

exports.copyInto = 
copyInto = (targetDir, src, cb) ->
  copy (String.prepending targetDir + "/", name src), src, cb

exports.copyFile = 
copyFile = (target, src, cb) ->
  createDir (dir target), -> 
    # input = FS.createReadStream src
    # output = FS.createWriteStream target
    # input.pipe output
    FS.writeFile target, (FS.readFileSync src), cb

# exports.copyDir =
# copyDir = (target, src, cb) ->
#   target1 = String.prepending target + "/", name src
#   createDir target1, -> copyDirContents target1, src, cb

# exports.copyDirContents = 
# copyDirContents = (target, src, cb) ->
exports.copyDir =
copyDir = (target, src, cb) ->
  createDir target, ->
    Array.each(
      (p, cb) -> 
        (if dirExists p then copyDir else copyFile)(
          target + "/" + (name p), p, cb
        )
      paths src
      cb
    )

exports.deepPaths = 
deepPaths = (p) ->
  if dirExists p
    ps = paths p
    Arrays.union Array.appendedWith ps, Array.results deepPaths, ps

exports.deepPathsWithExtension = 
deepPathsWithExtension = (extension, dir) ->
  Optional.result(
    [Array.matches, [[Object.equals, extension], Path.extension]]
    deepPaths dir
  )

exports.paths = 
paths = (p) -> p + "/" + sp for sp in FS.readdirSync p

exports.dirs = 
dirs = (p) -> p1 for name in FS.readdirSync p when exists p1 = p + "/" + name


exports.withoutSlash = 
withoutSlash = (p) -> String.replacing /\/+$/, "", p

exports.withSlash =
withSlash = (p) ->
  p1 = withoutSlash p
  if p1 != "" then p1 + "/" 

targetPath = (targetDir, dir, path) ->
  String.prepending (withSlash targetDir),
  relativeTo dir, path
  # String.prepending "#{normalized targetDir}/",
  # String.remainder "#{normalized dir}/",
  # path

exports.containerDir =
containerDir = (path) -> dir withoutSlash path

exports.createDir =
createDir = (path, cb) ->
  if path
    dir1 = containerDir path
    if dirExists dir1
      FS.mkdir path, "0777", cb
    else
      createDir dir1, -> FS.mkdir path, "0777", cb
  else
    cb()


exports.removeDirContents = 
removeDirContents = (dir, cb) ->
  [dirs, files] = Array.spread dirExists, paths dir
  Actions.callParallelly(
    Arrays.union [
      Array.results ((file) -> (cb) -> removeFile file, cb), files
      Array.results ((dir) -> (cb) -> removeDir dir, cb), dirs
    ]
    cb
  )
  # Array.each remove, (paths dir), cb

exports.remove = 
remove = (path, cb) ->
  if dirExists path then removeDir path, cb
  else if fileExists path then removeFile path, cb
  else cb

exports.removeDir = 
removeDir = (path, cb) ->
  removeDirContents dir, -> FS.rmdir dir, cb

exports.removeFile = 
removeFile = FS.unlink


exports.cleanDir = 
cleanDir = (dir, cb) -> 
  if dirExists dir then removeDirContents dir, cb
  else create dir, cb

exports.saveFile = 
saveFile = (data, file, cb) -> 
  createDir (dir file), -> 
    FS.writeFile file, data, "utf8", cb

exports.fileContents = 
fileContents = (f) -> 
  # try (FS.readFileSync f).toString()
  try FS.readFileSync f, "utf8"
