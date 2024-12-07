// Controller Module

// External Modules
const rl: type = @import("raylib");

// Modules
const keys = @import("keys.zig");

// Types
const KeyState = keys.KeyState;
const InputKey = keys.InputKey;

// Type Definitions
pub const Controller = struct {
    upKey:      InputKey,
    leftKey:    InputKey,
    downKey:    InputKey,
    rightKey:   InputKey,
    menuKey:    InputKey,
    runKey:     InputKey,
    jumpKey:    InputKey,
    actionKey:  InputKey,

    pub fn init (
        upKey:      InputKey, 
        leftKey:    InputKey, 
        downKey:    InputKey, 
        rightKey:   InputKey, 
        menuKey:    InputKey, 
        runKey:     InputKey, 
        jumpKey:    InputKey, 
        actionKey:  InputKey) 
    Controller {
        return .{
            .upKey      = upKey,
            .leftKey    = leftKey,
            .downKey    = downKey,
            .rightKey   = rightKey,
            .menuKey    = menuKey,
            .runKey     = runKey,
            .jumpKey    = jumpKey,
            .actionKey  = actionKey
        };
    }

    pub fn getHorizontalAxis(self: *Controller) f32 {
        const leftKeyState = self.leftKey.state;
        const rightKeyState = self.rightKey.state;
        if (rightKeyState == KeyState.NOT_PRESSED and 
            leftKeyState == KeyState.HELD) {
            return -1.0;
        } else if (
            leftKeyState == KeyState.NOT_PRESSED and 
            rightKeyState == KeyState.HELD) {
            return 1.0;
        }
        return 0.0;
    }

    pub fn update(self: *Controller) void {
        _ = self.jumpKey.update();
        _ = self.leftKey.update();
        _ = self.rightKey.update();
        _ = self.runKey.update();
    }
};

pub fn createDefaultController() Controller {
    return Controller{
        .upKey      = InputKey.init(rl.KeyboardKey.key_w),
        .leftKey    = InputKey.init(rl.KeyboardKey.key_a),
        .downKey    = InputKey.init(rl.KeyboardKey.key_s),
        .rightKey   = InputKey.init(rl.KeyboardKey.key_d),
        .menuKey    = InputKey.init(rl.KeyboardKey.key_i),
        .runKey     = InputKey.init(rl.KeyboardKey.key_j),
        .jumpKey    = InputKey.init(rl.KeyboardKey.key_k),
        .actionKey  = InputKey.init(rl.KeyboardKey.key_l),
    };
}