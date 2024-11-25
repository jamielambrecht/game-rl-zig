// Globals Module

// External Modules
const rl: type = @import("raylib");

// Modules
const controller = @import("player/controller.zig");
const keys = @import("keys.zig");
const player_ = @import("player.zig");

// Types
const InputKey = keys.InputKey;
const Player = player_.Player;

// Shared Objects
pub const SCREEN_WIDTH = 960;
pub const SCREEN_HEIGHT = 540;
pub const TARGET_FPS = 60;
pub var DEFAULT_PLAYER = Player.init(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
pub const DEFAULT_PLAYER_CONTROLLER = 
        controller.PlayerController{
    .upKey      = InputKey.init(rl.KeyboardKey.key_w),
    .leftKey    = InputKey.init(rl.KeyboardKey.key_a),
    .downKey    = InputKey.init(rl.KeyboardKey.key_s),
    .rightKey   = InputKey.init(rl.KeyboardKey.key_d),
    .menuKey    = InputKey.init(rl.KeyboardKey.key_i),
    .runKey     = InputKey.init(rl.KeyboardKey.key_j),
    .jumpKey    = InputKey.init(rl.KeyboardKey.key_k),
    .actionKey  = InputKey.init(rl.KeyboardKey.key_l),
};

