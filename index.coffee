  # Drawing App.
  readline = require 'readline'
  PF = require 'pathfinding'
  termCanvas = require 'term-canvas'

  class DrawingApp

    App = {}

    constructor: ->

      # create cli-interface
      App.rl = readline.createInterface process.stdin, process.stdout
      App.rl.setPrompt 'Enter command: '
      App.rl.prompt()
      @_parseInput()

    # Helpers
    # Validate input
    _handleErrors = (command) ->
      switch command[0]
       when 'C'
         if command.length < 3
           console.log "\n Please pass the parameters needed. \n"
           return true
        when 'L', 'R'
          if command.length < 5
            console.log "\n Please pass the parameters needed. \n"
            return true
        when 'B'
          if command.length < 4
            console.log "\n Please pass the parameters needed. \n"
            return true
        else
          break

      if !App.c && command[0] != 'C'
        console.log "\n Please create a canvas first. \n"
        return true

    # Initializes canvas & grid. Draws borders.
    _renderCanvas = ->
      App.c = new termCanvas App.w, App.h
      App.ctx = App.c.getContext '2d'
      App.g = new PF.Grid App.w,App.h

      App.ctx.clear()
      App.ctx.font = 'bold 12px sans-serif'

      x= 0
      while x < App.w
        App.ctx.fillText('-',x,0)
        App.ctx.fillText('-',x,App.h)
        x = x+1

      y= 2
      while y < App.h
        App.ctx.fillText('|',0,y)
        App.ctx.fillText('|',App.w-1,y)
        y = y+1

      App.ctx.fillRect(10,10,10,10)
      App.ctx.save()

      App.ctx.resetState()
      console.log('\n')

    # Draw line paths on canvas
    _drawPath = (x1,y1,x2,y2) ->
      App.g = App.g.clone()
      App.f = new PF.BiBreadthFirstFinder()
      path = App.f.findPath(x1,y1,x2,y2,App.g)
      for p in path
        App.ctx.fillText('x',p[0],p[1])
        App.g.setWalkableAt(p[0],p[1], false)

    # Fill area surrounding point in grid with input provided
    _fillPath = (x, y, c) ->
      width = App.c.width - 1
      height = App.c.height + 1

      if !App.g.isWalkableAt x,y
        return true

      App.ctx.fillText c, x, y
      App.g.setWalkableAt x, y, false

      if x > 2
        _fillPath x - 1, y, c
      if y > 2
        _fillPath x, y - 1, c
      if x < width - 1
        _fillPath x + 1, y, c
      if y < height - 1
        _fillPath x, y + 1, c

    # Parse command line input
    _parseInput: () ->
      # read command
      App.rl.on('line', (l) ->
        command = l.trim()
        command = command.split(/[ ,]+/)

        switch command[0]

          when 'C'
            if !_handleErrors command
            else break

            App.w = parseInt command[1],10
            App.h = parseInt command[2],10

            # adjust for borders
            App.w = App.w + 2
            App.h = App.h + 2

            _renderCanvas()

          when 'L'
            if !_handleErrors command
            else break

            x1 = parseInt command[1],10
            y1 = parseInt command[2],10
            x2 = parseInt command[3],10
            y2 = parseInt command[4],10

            _drawPath x1+1,y1+1,x2+1,y2+1

            App.ctx.fillRect 10,10,10,10
            App.ctx.save()

          when 'R'
            if !_handleErrors command
            else break

            x1 = parseInt command[1],10
            y1 = parseInt command[2],10
            x2 = parseInt command[3],10
            y2 = parseInt command[4],10

            # adjust for borders
            y1 += 1
            y2 += 1

            _drawPath x1,y1,x2,y1
            _drawPath x1,y1,x1,y2
            _drawPath x2,y1,x2,y2
            _drawPath x1,y2,x2,y2

            App.ctx.fillRect 10,10,10,10
            App.ctx.save()

          when 'B'
            if !_handleErrors command
            else break

            x = parseInt command[1],10
            y = parseInt command[2],10
            c = command[3]
            x += 1
            y += 1

            _fillPath x, y, c

            App.ctx.fillRect 10,10,10,10
            App.ctx.save()

          when 'Q'
            process.exit 0

          else
            console.log '\n `' + command[0] + '` is not a supported command. \n'
            break

        App.rl.prompt()
        return
      ).on 'close', ->
        process.exit 0
        return

  # init script
  args = process.argv;
  if args[2] is 'prompt'
    drawingApp = new DrawingApp

  module.exports = DrawingApp
