// Globals Module

// External Modules
const rl: type = @import("raylib");

// Modules
const controller = @import("player/controller.zig");
const keys = @import("keys.zig");

// Types
const InputKey = keys.InputKey;

// Shared Objects
pub const SCREEN_WIDTH = 960;
pub const SCREEN_HEIGHT = 540;
pub const TARGET_FPS = 60;
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