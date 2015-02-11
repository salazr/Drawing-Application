# Drawing App

  App = {}
  readline = require 'readline'
  PF = require 'pathfinding'
  termCanvas = require 'term-canvas'

  # helpers
  handleErrors = ->
    if !App.c
      console.log "\n Please create a canvas first. \n"
      return false

  renderCanvas = ->
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

  drawPath = (x1,y1,x2,y2) ->
    App.g = App.g.clone()
    App.f = new PF.BiBreadthFirstFinder()
    path = App.f.findPath(x1,y1,x2,y2,App.g)
    for p in path
      App.ctx.fillText('x',p[0],p[1])
      App.g.setWalkableAt(p[0],p[1], false)

  # create cli-interface
  rl = readline.createInterface process.stdin, process.stdout
  rl.setPrompt 'Enter command: '

  rl.prompt()

  rl.on('line', (l) ->
    # grab command
    command = l.trim()
    command = command.split(/[ ,]+/)

    switch command[0]

      when 'C'

        App.w = parseInt command[1],10
        App.h = parseInt command[2],10
        # adjust for borders
        App.w = App.w + 2
        App.h = App.h + 2

        renderCanvas()

      when 'L'

        x1 = parseInt command[1],10
        y1 = parseInt command[2],10
        x2 = parseInt command[3],10
        y2 = parseInt command[4],10

        drawPath x1+1,y1+1,x2+1,y2+1

        App.ctx.fillRect 10,10,10,10
        App.ctx.save()

      when 'R'

        x1 = parseInt command[1],10
        y1 = parseInt command[2],10
        x2 = parseInt command[3],10
        y2 = parseInt command[4],10

        # adjust for borders
        y1 += 1
        y2 += 1

        drawPath x1,y1,x2,y1
        drawPath x1,y1,x1,y2
        drawPath x2,y1,x2,y2
        drawPath x1,y2,x2,y2

        App.ctx.fillRect 10,10,10,10
        App.ctx.save()

      when 'B'

        x = parseInt command[1],10
        y = parseInt command[2],10
        c = command[3]
        x -= 1
        y -= 2

        # Fill reminding walkable spots
        for row in App.g.nodes
          if row[0].y > 1 && row[0].y < App.h
            for column in row
              if column.x > 1 && column.x < App.w-1
                if App.g.isWalkableAt column.x, column.y
                  if (App.g.isWalkableAt column.x-1, column.y) && (column.x > 0)
                    if (App.g.isWalkableAt column.x+1, column.y)
                      if (App.g.isWalkableAt column.x, column.y-1) && (column.y > 0)
                        # if (App.g.isWalkableAt column.x, column.y+1) && (column.y < App.h-1)

                        # for neighbor in App.g.getNeighbors column, App.f.diagonalMovement
                        #   if neighbor.walkable is true
                        #     if neighbor.parent && neighbor.parent.walkable is false
                              App.ctx.fillText c,column.x,column.y
                              # App.g.setWalkableAt column.x,column.y, false

        App.ctx.fillRect 10,10,10,10
        App.ctx.save()

      when 'Q'
        process.exit 0

      else
        console.log '\n `' + command[0] + '` is not a supported command. \n'
        break

    rl.prompt()
    return
  ).on 'close', ->
    process.exit 0
    return

  # ---
