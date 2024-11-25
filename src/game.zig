// Game Module
const globals = @import("globals.zig");
const environment_ = @import("environment.zig");
const player_ = @import("player.zig");

// Types
const Environment = environment_.Environment;
const Player = player_.Player;

pub const Game = struct {
    environment: Environment,
    player: *Player,

    pub fn init() Game {
        return .{
            .environment = Environment.init(&globals.DEFAULT_PLAYER),
            .player = &globals.DEFAULT_PLAYER,
        };
    }

    pub fn update(self: *Game) void {
        self.environment.update();
    }

    pub fn render(self: *Game) void {
        self.environment.render();
    }
};