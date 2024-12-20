// Environment Module

// Module Imports
const globals = @import("globals.zig");
const keys = @import("keys.zig");
const player_ = @import("player.zig");
const rl: type = @import("raylib");
const controller_ = @import("controller.zig");
const playerController_ = @import("player/player_controller.zig");
const PlayerEnvironment = @import("player/player_environment.zig");

// Types
const Player = player_.Player;
const Controller = controller_.Controller;
const PlayerController = playerController_.PlayerController;
const KeyState = keys.KeyState;

// Type Definitions
pub const Environment = struct {
    gravity: i32,
    floor: f32,
    playerController: PlayerController,
    player: *Player,

    pub fn init(default_controller: *Controller, player: *Player) Environment {
        const default_gravity: f32 = 12.0;
        player.setWeight(1.0 * default_gravity);
        return .{
            .gravity = default_gravity,
            .floor = globals.SCREEN_HEIGHT,
            .playerController = PlayerController.init(player, default_controller),
            .player = player
        };
    }

    pub fn update(self: *Environment) void {
        self.playerController.update();
        PlayerEnvironment.playerJump(self, self.player);
        PlayerEnvironment.playerLateralMotion(self, self.player);
        self.player.update();
    }

    pub fn render(self: *Environment) void {
        rl.clearBackground(rl.Color.white);
        self.player.render();
    }
};
