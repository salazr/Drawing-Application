# Drawing App
  App = {}
  readline = require('readline')
  PF = require('pathfinding')
  termCanvas = require('term-canvas')

  # helpers
  renderCanvas = ->
    # term canvas
    # console.log App.w, App.h
    App.c = new termCanvas App.w, App.h
    App.ctx = App.c.getContext '2d'
    App.ctx.clear()

    App.ctx.strokeStyle = "yellow"
    App.ctx.strokeRect(0, 0, App.c.width, App.c.height)
    # App.ctx.strokeStyle = "black"
    # App.ctx.stroke()
    # App.ctx.moveTo(0, 0)
    # App.ctx.lineTo(0, App.w+1)
    #
    # App.ctx.moveTo(0, App.h)
    # App.ctx.lineTo(0, App.w)

    App.ctx.save()

    # App.ctx.font = 'bold 12px sans-serif'
    # App.ctx.fillText('x',1,1)
    # App.ctx.stroke()
    App.ctx.resetState()
    console.log('\n')
    # App.ctx.resetState()
  drawPath = (x1,y1,x2,y2) ->
    App.g = App.g.clone()
    App.f = new PF.BiBreadthFirstFinder()
    path = App.f.findPath(x1,y1,x2,y2,App.g)
    for p in path
      App.ctx.font = 'bold 12px sans-serif'
      App.ctx.fillText('x',p[0],p[1])
      App.g.setWalkableAt(p[0],p[1], false)

  # create cli-interface
  rl = readline.createInterface(process.stdin, process.stdout)
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
        App.w = App.w + 1
        App.h = App.h + 1

        renderCanvas()

      when 'L'
        x1 = parseInt command[1],10
        y1 = parseInt command[2],10
        x2 = parseInt command[3],10
        y2 = parseInt command[4],10

        # init path finding grid + fnider
        App.g = new PF.Grid(App.w,App.h)
        App.f = new PF.BiBreadthFirstFinder()

        path = App.f.findPath(x1,y1,x2,y2,App.g)

        for p in path
          App.ctx.font = 'bold 12px sans-serif'
          App.ctx.fillText('x',p[0],p[1])

        App.ctx.fillRect(10,10,10,10)
        App.ctx.save()


      when 'R'

        x1 = parseInt command[1],10
        y1 = parseInt command[2],10
        x2 = parseInt command[3],10
        y2 = parseInt command[4],10

        # init path finding grid + finder
        App.g = new PF.Grid(App.w,App.h)

        # Rectangle:
        drawPath x1,y1,x2,y1
        drawPath x1,y1,x1,y2
        drawPath x2,y1,x2,y2
        drawPath x1,y2,x2,y2

        App.ctx.fillRect(10,10,10,10)
        App.ctx.save()



      when 'B'

        x = parseInt command[1],10
        y = parseInt command[2],10
        c = command[3]

        if App.g
          # console.log App.g.nodes[]
        else
          App.g = new PF.Grid(App.w,App.h)
          # console.log App.g.nodes[1]


        for row in App.g.nodes
          for column in row
            # console.log App.g.isWalkableAt column.x, column.y
            if App.g.isWalkableAt column.x, column.y
              App.ctx.font = 'bold 12px sans-serif'
              App.ctx.fillText(c,column.x,column.y)
              App.g.setWalkableAt(column.x,column.y, false)

        App.ctx.fillRect(10,10,10,10)
        App.ctx.save()


      when 'Q'
        process.exit 0


      else
        console.log '\n `' + command[0] + '` is not a supported command. \n'
        break

    rl.prompt()
    return
  ).on 'close', ->
    # console.log 'Have a great day!'
    process.exit 0
    return

  # ---
