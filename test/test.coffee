chai = require 'chai'
chai.should()

DrawingApp = require '../index'
# console.log DrawingApp

describe 'drawingApp instance', () ->
  task1 = task2 = null

  it 'should create a new canvas', ->
    task1 = DrawingApp
    console.log task1
    # task1.App.w = 20
    # task1.App.h = 4
    # task1._renderCanvas()
    # task1.



# ---
