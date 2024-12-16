// Player Module

// Modules
const rl: type = @import("raylib");
const globals = @import("globals.zig");
const state = @import("player/state.zig");
const motion = @import("player/motion.zig");

// Types
const Environment = @import("environment.zig").Environment;
const FacingState = state.FacingState;
const LateralMotionState = state.LateralMotionState;
const LateralMotion = motion.LateralMotion;
const JumpState = state.JumpState;
const JumpMotion = motion.JumpMotion;

// Player Motions
pub const WALK = LateralMotion.init(5.0, 0.3);
pub const RUN = LateralMotion.init(10.0, 0.2);
pub const IDLE = LateralMotion.init(0.0, 0.0);

// Type Definitions
pub const Player = struct {
    size: rl.Vector2,
    pos: rl.Vector2,
    vel: rl.Vector2,
    facing: FacingState,
    lateralMotionState: LateralMotionState,
    lateralMotion: LateralMotion,
    jumpMotion: JumpMotion,
    weight: f32,

    // Public functions
    pub fn init(x: f32, y: f32) Player {
        return Player{
            .size = rl.Vector2.init(24, 32), 
            .pos = rl.Vector2.init(x, y), 
            .vel = rl.Vector2.init(0.0, 0.0), 
            .facing = FacingState.RIGHT,
            .lateralMotionState = LateralMotionState.IDLE,
            .lateralMotion = IDLE,
            .jumpMotion = JumpMotion.init(-60.0, 0.2 * globals.TARGET_FPS, JumpState.FALLING),
            .weight = 0.0,
        };
    }

    pub fn update(self: *Player) void {
        self.pos.x += self.vel.x;
        self.pos.y += self.vel.y;
    }

    pub fn render(self: *Player) void {
        rl.drawRectangleV(self.pos, self.size, rl.Color.black);
    }

    pub fn getWeight(self: *Player) f32 {
        return self.weight;
    }

    pub fn setWeight(self: *Player, weight: f32) void {
        self.weight = weight;
    }

    pub fn getJumpMotion(self: *Player) *JumpMotion {
        return &self.jumpMotion;
    }

    pub fn setFacingState(self: *Player, facing_state: FacingState) void {
        self.facing = facing_state;
    }

    pub fn setLateralMotionState(self: *Player, lateral_motion_state: LateralMotionState) void {
        self.lateralMotionState = lateral_motion_state;
    }

};
