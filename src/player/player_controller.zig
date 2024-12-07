// Player Controller Interface

// External Modules
const rl: type = @import("raylib");

// Modules
const controller_ = @import("../controller.zig");
const keys = @import("../keys.zig");
const player_ = @import("../player.zig");
const state = @import("state.zig");

// Types
const Controller = controller_.Controller;
const InputKey = keys.InputKey;
const KeyState = keys.KeyState;
const Player = player_.Player;

const JumpState = state.JumpState;
const LateralMotionState = state.LateralMotionState;

// Type Definitions
pub const PlayerController = struct {
    player: *Player,
    controller: *Controller,

    pub fn init(player: *Player, controller: *Controller) PlayerController {
        return .{
            .player = player,
            .controller = controller,
        };
    }

    pub fn update(self: *PlayerController) void {
        self.controller.update();
    }

    pub fn jumpInput(self: *PlayerController) JumpState {
        const jump_key = self.controller.jumpKey;
        switch (self.player.jumpState) {
            JumpState.GROUNDED => {
                if (jump_key.state == KeyState.PRESSED) {
                    return JumpState.START_JUMP;
                }
            },
            JumpState.START_JUMP => {
                return JumpState.ASCENDING;
            },
            JumpState.ASCENDING => {
                if (self.player.vel.y >= 0.0 or jump_key.state != KeyState.HELD) {
                    return JumpState.APEX;
                }
            },
            JumpState.APEX => {
                if (jump_key.heldFor >= self.player.jumpMotion.hangTime or
                    jump_key.state != KeyState.HELD)
                {
                    return JumpState.FALLING;
                }
            },
            JumpState.FALLING => {
                return JumpState.FALLING;
            },
            JumpState.LANDING => {
                return JumpState.GROUNDED;
            }
        }
        return self.player.jumpState;
    }

    pub fn lateralMotionInput(self: *PlayerController) LateralMotionState {
        const run_key_held = self.controller.runKey.state == KeyState.HELD;
        const horizontal_axis = self.controller.getHorizontalAxis();
        const leftAction =  if (run_key_held) LateralMotionState.RUN_LEFT else LateralMotionState.WALK_LEFT;
        const rightAction = if (run_key_held) LateralMotionState.RUN_RIGHT else LateralMotionState.WALK_RIGHT;
        switch (self.player.lateralMotionState) {
            LateralMotionState.IDLE, LateralMotionState.STOPPING => {
                if (horizontal_axis < 0.0) {
                    return leftAction;
                } else if (horizontal_axis > 0.0) {
                    return rightAction;
                } else {
                    return LateralMotionState.IDLE;
                }
            },
            LateralMotionState.RUN_LEFT, LateralMotionState.WALK_LEFT => {
                if (horizontal_axis < 0.0) {
                    return leftAction;
                } else if (horizontal_axis > 0.0) {
                    return LateralMotionState.STOPPING;
                } else {
                    return LateralMotionState.STOPPING;
                }
            },
            LateralMotionState.RUN_RIGHT, LateralMotionState.WALK_RIGHT => {
                if (horizontal_axis > 0.0) {
                    return rightAction;
                } else if (horizontal_axis < 0.0) {
                    return LateralMotionState.STOPPING;
                } else {
                    return LateralMotionState.STOPPING;
                }
            },
        }
    }
};

