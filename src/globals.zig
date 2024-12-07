// Globals Module

// External Modules
const rl: type = @import("raylib");

// Modules
const controller = @import("controller.zig");
const keys = @import("keys.zig");
const player_ = @import("player.zig");

// Types
const InputKey = keys.InputKey;
const Player = player_.Player;

// Shared Objects
pub const SCREEN_WIDTH = 960;
pub const SCREEN_HEIGHT = 540;
pub const TARGET_FPS = 60;


