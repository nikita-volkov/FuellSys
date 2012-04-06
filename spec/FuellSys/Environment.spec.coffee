describe "Environment", ->
  {tmpDir, uniqueName} = require "../../src/FuellSys/Environment"
  Path = require "../../src/FuellSys/Path"

  describe "tmpDir", ->
    it "is not an empty string", ->
      expect(tmpDir() == "").toBeFalsy()
    it "exists", ->
      Path.exists tmpDir
    it "is /tmp if OS is Linux", ->
      expect(tmpDir()).toEqual "/tmp"
  
  describe "uniqueName", ->
    it "is not an empty string", ->
      expect(uniqueName() == "").toBeFalsy()
    it "doesn't repeat", ->
      for i in [0..100]
        expect(uniqueName() == uniqueName()).toBeFalsy()