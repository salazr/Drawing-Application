// Generated by CoffeeScript 1.9.0
(function() {
  var App, DrawingApp, PF, readline, termCanvas;

  readline = require('readline');

  PF = require('pathfinding');

  termCanvas = require('term-canvas');

  DrawingApp = (function() {
    var k;

    k = {};

    function DrawingApp() {
      var args;
      args = process.argv;
      if (args[2] === 'prompt') {
        k.rl = readline.createInterface(process.stdin, process.stdout);
        k.rl.setPrompt('Enter command: ');
        k.rl.prompt();
        this._parseInput();
      }
    }

    DrawingApp.prototype._handleErrors = function(command) {
      switch (command[0]) {
        case 'C':
          if (command.length < 3) {
            console.log("\n Please pass the parameters needed. \n");
            return true;
          }
          break;
        case 'L':
        case 'R':
          if (command.length < 5) {
            console.log("\n Please pass the parameters needed. \n");
            return true;
          }
          break;
        case 'B':
          if (command.length < 4) {
            console.log("\n Please pass the parameters needed. \n");
            return true;
          }
          break;
        default:
          break;
      }
      if (!k.c && command[0] !== 'C') {
        console.log("\n Please create a canvas first. \n");
        return true;
      }
    };

    DrawingApp.prototype._renderCanvas = function(width, height) {
      var x, y;
      k.c = new termCanvas(width, height);
      k.ctx = k.c.getContext('2d');
      k.g = new PF.Grid(width, height);
      k.ctx.clear();
      k.ctx.font = 'bold 12px sans-serif';
      x = 0;
      while (x < k.w) {
        k.ctx.fillText('-', x, 0);
        k.ctx.fillText('-', x, height);
        x = x + 1;
      }
      y = 2;
      while (y < k.h) {
        k.ctx.fillText('|', 0, y);
        k.ctx.fillText('|', width - 1, y);
        y = y + 1;
      }
      k.ctx.fillRect(10, 10, 10, 10);
      k.ctx.save();
      k.ctx.resetState();
      return console.log('\n');
    };

    DrawingApp.prototype._drawPath = function(x1, y1, x2, y2) {
      var p, path, _i, _len, _results;
      k.g = k.g.clone();
      k.f = new PF.BiBreadthFirstFinder();
      path = k.f.findPath(x1, y1, x2, y2, k.g);
      _results = [];
      for (_i = 0, _len = path.length; _i < _len; _i++) {
        p = path[_i];
        k.ctx.fillText('x', p[0], p[1]);
        _results.push(k.g.setWalkableAt(p[0], p[1], false));
      }
      return _results;
    };

    DrawingApp.prototype._fillPath = function(x, y, c) {
      var height, width;
      width = k.c.width - 1;
      height = k.c.height + 1;
      if (!k.g.isWalkableAt(x, y)) {
        return true;
      }
      k.ctx.fillText(c, x, y);
      k.g.setWalkableAt(x, y, false);
      if (x > 2) {
        App._fillPath(x - 1, y, c);
      }
      if (y > 2) {
        App._fillPath(x, y - 1, c);
      }
      if (x < width - 1) {
        App._fillPath(x + 1, y, c);
      }
      if (y < height - 1) {
        return App._fillPath(x, y + 1, c);
      }
    };

    DrawingApp.prototype._parseInput = function() {
      return k.rl.on('line', function(l) {
        var c, command, x, x1, x2, y, y1, y2;
        command = l.trim();
        command = command.split(/[ ,]+/);
        switch (command[0]) {
          case 'C':
            if (!App._handleErrors(command)) {

            } else {
              break;
            }
            k.w = parseInt(command[1], 10);
            k.h = parseInt(command[2], 10);
            k.w = k.w + 2;
            k.h = k.h + 2;
            App._renderCanvas(k.w, k.h);
            break;
          case 'L':
            if (!App._handleErrors(command)) {

            } else {
              break;
            }
            x1 = parseInt(command[1], 10);
            y1 = parseInt(command[2], 10);
            x2 = parseInt(command[3], 10);
            y2 = parseInt(command[4], 10);
            App._drawPath(x1 + 1, y1 + 1, x2 + 1, y2 + 1);
            k.ctx.fillRect(10, 10, 10, 10);
            k.ctx.save();
            break;
          case 'R':
            if (!App._handleErrors(command)) {

            } else {
              break;
            }
            x1 = parseInt(command[1], 10);
            y1 = parseInt(command[2], 10);
            x2 = parseInt(command[3], 10);
            y2 = parseInt(command[4], 10);
            y1 += 1;
            y2 += 1;
            App._drawPath(x1, y1, x2, y1);
            App._drawPath(x1, y1, x1, y2);
            App._drawPath(x2, y1, x2, y2);
            App._drawPath(x1, y2, x2, y2);
            k.ctx.fillRect(10, 10, 10, 10);
            k.ctx.save();
            break;
          case 'B':
            if (!App._handleErrors(command)) {

            } else {
              break;
            }
            x = parseInt(command[1], 10);
            y = parseInt(command[2], 10);
            c = command[3];
            x += 1;
            y += 1;
            App._fillPath(x, y, c);
            k.ctx.fillRect(10, 10, 10, 10);
            k.ctx.save();
            break;
          case 'Q':
            process.exit(0);
            break;
          default:
            console.log('\n `' + command[0] + '` is not a supported command. \n');
            break;
        }
        k.rl.prompt();
      }).on('close', function() {
        process.exit(0);
      });
    };

    return DrawingApp;

  })();

  App = new DrawingApp;

  module.exports = DrawingApp;

}).call(this);
