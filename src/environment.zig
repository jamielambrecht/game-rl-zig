// Environment Module

// Module Imports
const globals = @import("globals.zig");
const keys = @import("keys.zig");
const player_ = @import("player.zig");
const controller = @import("player/controller.zig");
const IPlayerEnvironment = @import("player/interface/player_environment.zig");

// Types
const Player = player_.Player;
const PlayerController = controller.PlayerController;
const KeyState = keys.KeyState;

// Type Definitions
pub const Environment = struct {
    gravity: u32,
    floor: f32,
    playerController: PlayerController,
    player: *Player,

    pub fn init(player: *Player) Environment {
        return .{
            .gravity = 12,
            .floor = globals.SCREEN_HEIGHT,
            .playerController = globals.DEFAULT_PLAYER_CONTROLLER,
            .player = player
        };
    }

    pub fn update(self: *Environment) void {
        self.playerController.update();
        IPlayerEnvironment.playerJump(self, self.player);
        IPlayerEnvironment.playerLateralMotion(
            self,
            self.player,
            self.playerController.getHorizontalAxis(),
            self.playerController.runKey.state == KeyState.HELD,
            // player.lateralMotionState
        );
        self.player.update(self.gravity);
    }
};
