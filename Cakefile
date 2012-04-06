{exec} = require 'child_process'

task "run", "", ->
  compile -> run "lib/Main.js"

compile = (cb) ->
  exec "coffee -c -o lib src", (err, stdout, stderr) ->
    if err 
      console.error err.stack
      return
    else if stdout || stderr
      console.log stdout + stderr 
    cb?()

run = (file, cb) ->
  exec "node #{file}", (err, stdout, stderr) ->
    if err then console.error err.stack 
    else console.log stdout + stderr if stdout || stderr
    cb?()


