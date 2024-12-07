// Player-Environment Interface

// Module Imports
const player_ = @import("../player.zig");
const environment_ = @import("../environment.zig");
const motion =  @import("motion.zig");
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
const LateralMotion = motion.LateralMotion;

// Functions
pub fn playerJump(environment: *Environment, player: *Player) void {
    var jump_state = environment.playerController.jumpInput();
    if (jump_state == JumpState.FALLING and 
        player.pos.y + player.size.y >= environment.floor) {
        jump_state = JumpState.LANDING;
    }
    player.setJumpState(jump_state);
}

pub fn playerLateralMotion(environment: *Environment, player: *Player) void {
    const lateral_motion_state = environment.playerController.lateralMotionInput();
    if (lateral_motion_state == player.lateralMotionState) {
        return;
    }
    switch (lateral_motion_state) {
        LateralMotionState.IDLE, LateralMotionState.STOPPING => {
            if (player.lateralMotionState != LateralMotionState.IDLE) {
                player.setLateralMotionState(LateralMotionState.IDLE);
            }
        },
        LateralMotionState.RUN_LEFT, LateralMotionState.RUN_RIGHT => {
            if (lateral_motion_state == LateralMotionState.RUN_LEFT) {
                player.setFacingState(FacingState.LEFT);
            } else {
                player.setFacingState(FacingState.RIGHT);
            }
            if (player.lateralMotionState == LateralMotionState.WALK_LEFT or player.lateralMotionState == LateralMotionState.WALK_RIGHT) {
                if (@abs(player.vel.x) == player_.WALK.targetSpeed) {
                    player.setLateralMotionState(lateral_motion_state);
                }
            } else if (player.lateralMotionState == LateralMotionState.IDLE) {
                if (lateral_motion_state == LateralMotionState.RUN_LEFT) {
                    player.setLateralMotionState(LateralMotionState.WALK_LEFT);
                } else {
                    player.setLateralMotionState(LateralMotionState.WALK_RIGHT);
                }
            } else {
                player.setLateralMotionState(LateralMotionState.STOPPING);
            }
        },
        LateralMotionState.WALK_LEFT, LateralMotionState.WALK_RIGHT => {
            if (lateral_motion_state == LateralMotionState.WALK_LEFT) {
                player.setFacingState(FacingState.LEFT);
            } else {
                player.setFacingState(FacingState.RIGHT);
            }
            if (player.lateralMotionState == LateralMotionState.IDLE) {
                player.setLateralMotionState(lateral_motion_state);
            }
        }
    }
}
