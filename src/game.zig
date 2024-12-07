// Game Module
const globals = @import("globals.zig");
const environment_ = @import("environment.zig");
const controller_ = @import("controller.zig");
const player_ = @import("player.zig");

// Types
const Player = player_.Player;
const Environment = environment_.Environment;

var defaultController = controller_.createDefaultController();
var player = Player.init(globals.SCREEN_WIDTH / 2, globals.SCREEN_HEIGHT / 2);

pub const Game = struct {
    environment: Environment,

    pub fn init() Game {
        return .{
            .environment = Environment.init(&defaultController, &player),
        };
    }

    pub fn update(self: *Game) void {
        self.environment.update();
    }

    pub fn render(self: *Game) void {
        self.environment.render();
    }
};