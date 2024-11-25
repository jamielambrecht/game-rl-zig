// Game Module
const globals = @import("globals.zig");
const environment_ = @import("environment.zig");

// Types
const Environment = environment_.Environment;

pub const Game = struct {
    environment: Environment,

    pub fn init() Game {
        return .{
            .environment = Environment.init(),
        };
    }

    pub fn update(self: *Game) void {
        self.environment.update();
    }

    pub fn render(self: *Game) void {
        self.environment.render();
    }
};