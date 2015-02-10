// Generated by CoffeeScript 1.9.0
(function() {
  var App, Canvas, PF, readline, rl;

  App = {};

  readline = require('readline');

  Canvas = require('drawille');

  PF = require('pathfinding');

  rl = readline.createInterface(process.stdin, process.stdout);

  rl.setPrompt('Enter command: ');

  rl.prompt();

  rl.on('line', function(l) {
    var c, command, draw, p, path, x, x1, x2, y, y1, y2, _i, _len;
    command = l.trim();
    command = command.split(/[ ,]+/);
    switch (command[0]) {
      case 'C':
        App.w = parseInt(command[1], 10);
        App.h = parseInt(command[2], 10);
        App.c = new Canvas(App.w, App.h);
        App.g = new PF.Grid(App.w, App.h);
        App.f = new PF.BiAStarFinder();
        draw = function() {
          App.c.clear();
          return process.stdout.write(App.c.frame());
        };
        draw();
        break;
      case 'L':
        x1 = parseInt(command[1], 10);
        y1 = parseInt(command[2], 10);
        x2 = parseInt(command[3], 10);
        y2 = parseInt(command[4], 10);
        path = App.f.findPath(x1, y1, x2, y2, App.g);
        console.log(path);
        for (_i = 0, _len = path.length; _i < _len; _i++) {
          p = path[_i];
          console.log(p);
          App.c.set(p[0], p[1]);
        }
        process.stdout.write(App.c.frame());
        break;
      case 'L':
        x1 = parseInt(command[1], 10);
        y1 = parseInt(command[2], 10);
        x2 = parseInt(command[3], 10);
        y2 = parseInt(command[4], 10);
        break;
      case 'B':
        x = parseInt(command[1], 10);
        y = parseInt(command[2], 10);
        c = parseInt(command[3], 10);
        break;
      case 'Q':
        break;
      default:
        console.log('Say what? I might have heard `' + line.trim() + '`');
    }
    rl.prompt();
  }).on('close', function() {
    process.exit(0);
  });

}).call(this);
