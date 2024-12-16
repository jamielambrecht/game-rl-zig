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
    const player_jump_motion = player.getJumpMotion();
    if (jump_state == JumpState.FALLING and 
        player.pos.y + player.size.y >= environment.floor) {
        jump_state = JumpState.LANDING;
    }
    player_jump_motion.setJumpState(jump_state);
    switch (player_jump_motion.getJumpState()) {
        JumpState.FALLING => {
            player.vel.y = player.getWeight();
        },
        JumpState.START_JUMP => {
            player.vel.y = player_jump_motion.getJumpForce();
        },
        JumpState.ASCENDING => {
            player.vel.y += player.getWeight();
        },
        JumpState.LANDING => {
            player.vel.y = 0;
        },
        JumpState.APEX, JumpState.GROUNDED => {
            player.vel.y = 0;
        },
    }
}

pub fn playerLateralMotion(environment: *Environment, player: *Player) void {
    const lateral_motion_state = environment.playerController.lateralMotionInput();
    if (lateral_motion_state != player.lateralMotionState) {
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
    const direction: f32 = switch (player.facing) {
        FacingState.LEFT => -1.0,
        FacingState.RIGHT => 1.0,
    };
    switch (player.lateralMotionState) {
        LateralMotionState.IDLE, LateralMotionState.STOPPING => {
            player.vel.x = 0.0;
            return;
        },
        LateralMotionState.WALK_LEFT, LateralMotionState.WALK_RIGHT => {
            player.lateralMotion = player_.WALK;
        },
        LateralMotionState.RUN_LEFT, LateralMotionState.RUN_RIGHT => {
            player.lateralMotion = player_.RUN;
        }
    }
    if (player.vel.x * direction < player.lateralMotion.targetSpeed) {
        player.vel.x += direction * player.lateralMotion.acceleration;
    } else {
        player.vel.x = direction * player.lateralMotion.targetSpeed;
    }
}
