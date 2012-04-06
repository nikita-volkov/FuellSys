describe "Path", ->
  Path = require "../../src/Util/Path"
  Environment = require "../../src/Util/Environment"
  FS = require "fs"

  describe "Filters", ->
    {correct, parts, relative, simplified} = Path
    describe "correct", ->
      it "cleans several slashes", ->
        expect(correct "a//a///b/a").toEqual "a/a/b/a"
      it "cleans repeated slashes", ->
        expect(correct ".//a////a").toEqual "a/a"
      it "cleans self-pointing path", ->
        expect(correct "./a/b").toEqual "a/b"
      it "does not remove trailing slashes", ->
        expect(correct "a/b/").toEqual "a/b/"
        expect(correct "a/b///").toEqual "a/b/"
      it "removes a dot", ->
        expect(correct ".").toEqual ""

    describe "parts", ->
      it "parses absolute paths", ->
        expect(parts "/a/b/c/").toEqual ["/a/b/c/", undefined, undefined]
      it "parses self-pointing paths", ->
        expect(parts "./a/b/c/").toEqual ["./a/b/c/", undefined, undefined]
      it "parses extensionless files", ->
        expect(parts "/a/b/c").toEqual ["/a/b/", "c", undefined]
      it "parses extensions", ->
        expect(parts "/a/b/c.d").toEqual ["/a/b/", "c", "d"]

    describe "relative", ->
      it "works for self-pointing source path", ->
        expect(relative "a/b/c", ".").toEqual "a/b/c"
      it "works for source files", ->
        expect(relative "a/b/c", "./a").toEqual "a/b/c"
      it "works for other dirs", ->
        expect(relative "a/b/c", "a/b/d/f").toEqual "../c"
      it "works for absolute paths", ->
        expect(relative "/d/b/c", "/a/b/d/f").toEqual "../../../d/b/c"
      it "fails when passed an absolute and non-absolute path", ->
        expect(-> relative "/a/b/c", "a/b/").toThrow()
        expect(-> relative "a/b/c", "/a/b/").toThrow()
      it "detects self-pointing paths", ->
        expect(relative "a/b/c", "a/b/").toEqual "c"
        expect(relative "a/b/", "a/b/").toEqual ""
      it "works for directory source paths", ->
        expect(relative "a/d/c", "a/b/").toEqual "../d/c"
      it "doesn't confuse source files with dirs", ->
        expect(relative "a/b/c", "a/b").toEqual "b/c"
      
    describe "simplified", ->
      it "works", ->
        expect(simplified "a/b/../d/../c/").toEqual "a/c/"

  describe "Async", ->
    describe "removeDir", ->
      it "removes a freshly created empty temporary dir", ->
        dir = Environment.tmpDir() + "/" + Environment.uniqueName()
        expect(Path.exists dir).toBeFalsy()
        FS.mkdirSync dir, "0777"
        expect(Path.exists dir).toBeTruthy()
        runs -> Path.removeDir dir, ->
        waits 1
        runs -> expect(Path.exists dir).toBeFalsy()

      it "removes a temporary dir with subdirs", ->
        dir = Environment.tmpDir() + "/" + Environment.uniqueName()
        expect(Path.exists dir).toBeFalsy()

        FS.mkdirSync "#{dir}", "0777"
        FS.mkdirSync "#{dir}/aba", "0777"
        FS.mkdirSync "#{dir}/aba/sldf", "0777"
        FS.mkdirSync "#{dir}/aba/sldfsdf", "0777"
        FS.mkdirSync "#{dir}/aba/sldfsdf/3", "0777"
        FS.mkdirSync "#{dir}/1", "0777"
        FS.mkdirSync "#{dir}/1/dsf", "0777"
        FS.mkdirSync "#{dir}/3", "0777"
        FS.mkdirSync "#{dir}/10", "0777"

        runs -> Path.removeDir dir, ->
        waits 10
        runs -> expect(Path.exists dir).toBeFalsy()

    describe "prepareDir", ->
      it "works", ->
        dir = Environment.tmpDir() + "/" + Environment.uniqueName()
        FS.mkdirSync "#{dir}", "0777"
        FS.mkdirSync "#{dir}/aba", "0777"
        FS.mkdirSync "#{dir}/aba/sldf", "0777"
        FS.mkdirSync "#{dir}/aba/sldfsdf", "0777"
        FS.mkdirSync "#{dir}/aba/sldfsdf/3", "0777"
        FS.mkdirSync "#{dir}/1", "0777"
        FS.mkdirSync "#{dir}/1/dsf", "0777"
        FS.mkdirSync "#{dir}/3", "0777"
        FS.mkdirSync "#{dir}/10", "0777"
        runs -> Path.prepareDir dir, ->
        waits 10
        runs -> 
          expect(Path.exists dir).toBeTruthy()
          expect(Path.paths dir).toEqual []
          Path.removeDir dir, ->

    describe "remove", ->
      it "removes a temporary dir with subdirs", ->
        dir = Environment.tmpDir() + "/" + Environment.uniqueName()
        expect(Path.exists dir).toBeFalsy()

        FS.mkdirSync "#{dir}", "0777"
        FS.mkdirSync "#{dir}/aba", "0777"
        FS.mkdirSync "#{dir}/aba/sldf", "0777"
        FS.mkdirSync "#{dir}/aba/sldfsdf", "0777"
        FS.mkdirSync "#{dir}/aba/sldfsdf/3", "0777"
        FS.mkdirSync "#{dir}/1", "0777"
        FS.mkdirSync "#{dir}/1/dsf", "0777"
        FS.mkdirSync "#{dir}/3", "0777"
        FS.mkdirSync "#{dir}/10", "0777"

        runs -> Path.remove dir, ->
        waits 10
        runs -> expect(Path.exists dir).toBeFalsy()