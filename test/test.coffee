chai = require 'chai'
# chai.should()

drawingApp = require '../index.coffee'
console.log drawingApp

describe 'drawingApp instance', () ->
  task1 = task2 = null

  it 'should create a new canvas', ->
    task1 = drawingApp
    # console.log task1
    # task1.App.w = 20
    # task1.App.h = 4
    # task1._renderCanvas()
    # task1.



# ---
