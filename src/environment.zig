// Environment Module

// Module Imports
const globals = @import("globals.zig");
const keys = @import("keys.zig");
const player_ = @import("player.zig");
const rl: type = @import("raylib");
const controller = @import("player/controller.zig");
const IPlayerEnvironment = @import("player/player_environment.zig");

// Types
const Player = player_.Player;
const PlayerController = controller.PlayerController;
const KeyState = keys.KeyState;

// Type Definitions
pub const Environment = struct {
    gravity: u32,
    floor: f32,
    playerController: PlayerController,
    player: Player,

    pub fn init() Environment {
        return .{
            .gravity = 12,
            .floor = globals.SCREEN_HEIGHT,
            .playerController = globals.DEFAULT_PLAYER_CONTROLLER,
            .player = Player.init(globals.SCREEN_WIDTH / 2, globals.SCREEN_HEIGHT / 2)
        };
    }

    pub fn update(self: *Environment) void {
        self.playerController.update();
        IPlayerEnvironment.playerJump(self, &self.player);
        IPlayerEnvironment.playerLateralMotion(
            self,
            &self.player,
            self.playerController.getHorizontalAxis(),
            self.playerController.runKey.state == KeyState.HELD,
            // player.lateralMotionState
        );
        self.player.update(self.gravity, self.floor);
    }

    pub fn render(self: *Environment) void {
        rl.clearBackground(rl.Color.white);
        self.player.render();
    }
};
