// Main

// Module Imports
const game_ = @import("game.zig");
const globals = @import("globals.zig");
const rl: type = @import("raylib");

// Types
const Game = game_.Game;

// Functions
fn init() void {
    rl.initWindow(globals.SCREEN_WIDTH, globals.SCREEN_HEIGHT, "Untitled Game");
    rl.setTargetFPS(globals.TARGET_FPS);
}

// Entry Point
pub fn main() anyerror!void {
    var game = Game.init();
    defer rl.closeWindow();
    init();
    while (!rl.windowShouldClose()) {
        defer rl.endDrawing();
        game.update();
        rl.beginDrawing();
        game.render();
    }
}
