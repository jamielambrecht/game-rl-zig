// Controller Module

// External Modules
const rl: type = @import("raylib");

// Modules
const keys = @import("../keys.zig");

// Types
const KeyState = keys.KeyState;
const InputKey = keys.InputKey;

// Type Definitions
pub const PlayerController = struct {
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
    PlayerController {
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

    pub fn getHorizontalAxis(self: *PlayerController) f32 {
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

    pub fn update(self: *PlayerController) void {
        _ = self.jumpKey.update();
        _ = self.leftKey.update();
        _ = self.rightKey.update();
        _ = self.runKey.update();
    }
};
