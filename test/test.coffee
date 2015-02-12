should = require('should')
DrawingApp = require '../index.coffee'

describe 'Drawing Program instance', () ->
  task1 = task2 = task3 = null

  it 'should create a new canvas', ->
    task1 = new DrawingApp
    task1._renderCanvas()
    # console.log task1
    # should.exist(task1)

  it 'should draw a line path between points', ->
    task2 = new DrawingApp
    task2._renderCanvas(22,6)
    task2._drawPath(1,2,6,2)
    # should.exist(task2)

  it 'should fill space surrounding points', ->
    task3 = new DrawingApp
    task3._renderCanvas(22,6)
    task3._drawPath(1,2,6,2)
    task3._fillPath(10,3,'o')
    # should.exist(task3)


# ---
