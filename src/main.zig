// Main

// Module Imports
const rl: type = @import("raylib");
const globals = @import("globals.zig");
const player_ = @import("player.zig");
const environment_ = @import("environment.zig");

// Types
const Player = player_.Player;
const Environment = environment_.Environment;

// Entry Point
pub fn main() anyerror!void {
    defer rl.closeWindow();
    rl.initWindow(globals.SCREEN_WIDTH, globals.SCREEN_HEIGHT, "Untitled Game");
    rl.setTargetFPS(globals.TARGET_FPS);
    var player = Player.init(globals.SCREEN_WIDTH / 2, globals.SCREEN_HEIGHT / 2);
    var environment = Environment.init(&player);
    while (!rl.windowShouldClose()) {
        // Update
        environment.update();
        // Render
        rl.beginDrawing();
        defer rl.endDrawing();
        rl.clearBackground(rl.Color.white);
        rl.drawRectangleV(player.pos, player.size, rl.Color.black);
    }
}
