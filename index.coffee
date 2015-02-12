  # Drawing App.
  readline = require 'readline'
  PF = require 'pathfinding'
  termCanvas = require 'term-canvas'


  class DrawingApp
    # constants store
    k = {}

    constructor: ->
      @k = {}
      args = process.argv
      if args[2] is 'prompt'
        # create cli-interface
        k.rl = readline.createInterface process.stdin, process.stdout
        k.rl.setPrompt 'Enter command: '
        k.rl.prompt()
        @_parseInput()


    # Helpers
    # Validate input
    _handleErrors: (command) ->
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

      if !k.c && command[0] != 'C'
        console.log "\n Please create a canvas first. \n"
        return true

    # Initializes canvas & grid. Draws borders.
    _renderCanvas: (width, height) ->
      k.c = new termCanvas width, height
      k.ctx = k.c.getContext '2d'
      k.g = new PF.Grid width, height

      k.ctx.clear()
      k.ctx.font = 'bold 12px sans-serif'

      x= 0
      while x < k.w
        k.ctx.fillText('-',x,0)
        k.ctx.fillText('-',x,height)
        x = x+1

      y= 2
      while y < k.h
        k.ctx.fillText('|',0,y)
        k.ctx.fillText('|',width-1,y)
        y = y+1

      k.ctx.fillRect(10,10,10,10)
      k.ctx.save()

      k.ctx.resetState()

      console.log('\n')


    # Draw line paths on canvas
    _drawPath: (x1,y1,x2,y2) ->
      k.g = k.g.clone()
      k.f = new PF.BiBreadthFirstFinder()
      path = k.f.findPath(x1,y1,x2,y2,k.g)
      for p in path
        k.ctx.fillText('x',p[0],p[1])
        k.g.setWalkableAt(p[0],p[1], false)

    # Fill area surrounding point in grid with input provided
    _fillPath: (x, y, c) ->
      width = k.c.width - 1
      height = k.c.height + 1

      if !k.g.isWalkableAt x,y
        return true

      k.ctx.fillText c, x, y
      k.g.setWalkableAt x, y, false

      if x > 2
        App._fillPath x - 1, y, c
      if y > 2
        App._fillPath x, y - 1, c
      if x < width - 1
        App._fillPath x + 1, y, c
      if y < height - 1
        App._fillPath x, y + 1, c

    # Parse command line input
    _parseInput: () ->
      # read command
      k.rl.on('line', (l) ->
        command = l.trim()
        command = command.split(/[ ,]+/)

        switch command[0]

          when 'C'
            if !App._handleErrors command
            else break

            k.w = parseInt command[1],10
            k.h = parseInt command[2],10

            # adjust for borders
            k.w = k.w + 2
            k.h = k.h + 2

            App._renderCanvas(k.w,k.h)

          when 'L'
            if !App._handleErrors command
            else break

            x1 = parseInt command[1],10
            y1 = parseInt command[2],10
            x2 = parseInt command[3],10
            y2 = parseInt command[4],10

            App._drawPath x1+1,y1+1,x2+1,y2+1

            k.ctx.fillRect 10,10,10,10
            k.ctx.save()

          when 'R'
            if !App._handleErrors command
            else break

            x1 = parseInt command[1],10
            y1 = parseInt command[2],10
            x2 = parseInt command[3],10
            y2 = parseInt command[4],10

            # adjust for borders
            y1 += 1
            y2 += 1

            App._drawPath x1,y1,x2,y1
            App._drawPath x1,y1,x1,y2
            App._drawPath x2,y1,x2,y2
            App._drawPath x1,y2,x2,y2

            k.ctx.fillRect 10,10,10,10
            k.ctx.save()


          when 'B'
            if !App._handleErrors command
            else break

            x = parseInt command[1],10
            y = parseInt command[2],10
            c = command[3]
            x += 1
            y += 1

            App._fillPath x, y, c

            k.ctx.fillRect 10,10,10,10
            k.ctx.save()

          when 'Q'
            process.exit 0

          else
            console.log '\n `' + command[0] + '` is not a supported command. \n'
            break

        k.rl.prompt()
        return
      ).on 'close', ->
        process.exit 0
        return

  App = new DrawingApp
  module.exports = DrawingApp
