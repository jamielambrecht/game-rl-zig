// Player-Environment Interface

// Module Imports
const player_ = @import("../player.zig");
const environment_ = @import("../environment.zig");
const state: type = @import("state.zig");
const keys = @import("../keys.zig");

// Types
const Player = player_.Player;
const Environment = environment_.Environment;
const JumpState = state.JumpState;
const KeyState = keys.KeyState;
const InputKey = keys.InputKey;
const FacingState = state.FacingState;
const LateralMotionState = state.LateralMotionState;

// Functions
pub fn playerJump(environment: *Environment, player: *Player) void {
    const jump_key = environment.playerController.jumpKey;
    const jump_key_state = jump_key.state;
    const hang_time = player.jumpMotion.hangTime;
    switch (player.jumpState) {
        JumpState.GROUNDED => {
            if (jump_key_state == KeyState.PRESSED) {
                player.beginJumpAction();
            }
        },
        JumpState.START_JUMP => {
            player.continueJumping();
        },
        JumpState.ASCENDING => {
            if (player.vel.y >= 0.0 or jump_key_state != KeyState.HELD) {
                player.stopJumping();
            }
        },
        JumpState.APEX => {
            if (jump_key.heldFor >= hang_time or
                jump_key_state != KeyState.HELD)
            {
                player.startFalling();
            }
        },
        JumpState.FALLING => {
            if (player.pos.y + player.size.y >= environment.floor) {
                player.stopFalling();
            }
        },
        JumpState.LANDING => {
            player.endJumpAction();
        }
    }
}

pub fn playerLateralMotion(
    _: *Environment,
    player: *Player,
    horizontal_axis: f32,
    run_key_held: bool,
    // player_lateral_motion_state: LateralMotionState
) void {
    // switch (player_lateral_motion_state) {
    //     LateralMotionState.IDLE => {

    //     },
    //     LateralMotionState.STOPPING => {
    //         if (horizontal_axis == 0.0) {
    //             player.finishStopping();
    //         } else if (horizontal_axis < 0.0) {

    //         } else if (horizontal_axis > 0.0) {

    //         }
    //     },
    //     LateralMotionState.WALK_LEFT => {
    //         if (horizontal_axis == 0.0) {
    //             player.beginStopping();
    //         }
    //     },
    //     LateralMotionState.WALK_RIGHT => {
    //         if (horizontal_axis == 0.0) {
    //             player.beginStopping();
    //         }
    //     },
    //     LateralMotionState.RUN_LEFT => {
    //         if (horizontal_axis == 0.0) {
    //             player.beginStopping();
    //         }
    //     },
    //     LateralMotionState.RUN_RIGHT => {
    //         if (horizontal_axis == 0.0) {
    //             player.beginStopping();
    //         }
    //     },
    // }

    if (horizontal_axis == 0.0 and
        player.lateralMotionState != LateralMotionState.IDLE)
    {
        player.beginStopping();
    }
    if (player.lateralMotionState == LateralMotionState.STOPPING) {
        player.finishStopping();
    }
    if (horizontal_axis < 0.0 and run_key_held) {
        switch (player.lateralMotionState) {
            LateralMotionState.RUN_LEFT, LateralMotionState.STOPPING => {},
            LateralMotionState.IDLE, LateralMotionState.WALK_LEFT => {
                player.beginRunning(FacingState.LEFT);
            },
            else => {
                player.beginStopping();
            },
        }
    } else if (horizontal_axis < 0.0 and !run_key_held) {
        switch (player.lateralMotionState) {
            LateralMotionState.WALK_LEFT, LateralMotionState.STOPPING => {},
            LateralMotionState.IDLE, LateralMotionState.RUN_LEFT => {
                player.beginWalking(FacingState.LEFT);
            },
            else => {
                player.beginStopping();
            },
        }
    } else if (horizontal_axis > 0.0 and run_key_held) {
        switch (player.lateralMotionState) {
            LateralMotionState.RUN_RIGHT, LateralMotionState.STOPPING => {},
            LateralMotionState.IDLE, LateralMotionState.WALK_RIGHT => {
                player.beginRunning(FacingState.RIGHT);
            },
            else => {
                player.beginStopping();
            },
        }
    } else if (horizontal_axis > 0.0 and !run_key_held) {
        switch (player.lateralMotionState) {
            LateralMotionState.WALK_RIGHT, LateralMotionState.STOPPING => {
                // Do nothing.
            },
            LateralMotionState.IDLE, LateralMotionState.RUN_RIGHT => {
                player.beginWalking(FacingState.RIGHT);
            },
            else => {
                player.beginStopping();
            },
        }
    }
}
