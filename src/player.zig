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
    jumpState: JumpState,
    jumpMotion: JumpMotion,

    // Private functions
    fn handleVerticalMotion(self: *Player, gravity: u32, floor: f32) void {
        switch (self.jumpState) {
            JumpState.FALLING => {
                self.vel.y = @floatFromInt(gravity);
            },
            JumpState.START_JUMP => {
                self.vel.y = self.jumpMotion.jumpForce;
            },
            JumpState.ASCENDING => {
                self.vel.y += @floatFromInt(gravity);
            },
            JumpState.LANDING => {
                self.vel.y = 0;
                self.pos.y = floor - self.size.y;
            },
            JumpState.APEX, JumpState.GROUNDED => {
                self.vel.y = 0;
            },
        }
    }

    fn handleLateralMotion(self: *Player) void {
        const direction: f32 = switch (self.facing) {
            FacingState.LEFT => -1.0,
            FacingState.RIGHT => 1.0,
        };
        switch (self.lateralMotionState) {
            LateralMotionState.IDLE, LateralMotionState.STOPPING => {
                self.vel.x = 0.0;
                return;
            },
            LateralMotionState.WALK_LEFT, LateralMotionState.WALK_RIGHT => {
                self.lateralMotion = WALK;
            },
            LateralMotionState.RUN_LEFT, LateralMotionState.RUN_RIGHT => {
                self.lateralMotion = RUN;
            }
        }
        if (self.vel.x * direction < self.lateralMotion.targetSpeed) {
            self.vel.x += direction * self.lateralMotion.acceleration;
        } else {
            self.vel.x = direction * self.lateralMotion.targetSpeed;
        }
    }

    // Public functions
    pub fn init(x: f32, y: f32) Player {
        return Player{
            .size = rl.Vector2.init(24, 32), 
            .pos = rl.Vector2.init(x, y), 
            .vel = rl.Vector2.init(0.0, 0.0), 
            .facing = FacingState.RIGHT,
            .lateralMotionState = LateralMotionState.IDLE,
            .lateralMotion = IDLE,
            .jumpState = JumpState.FALLING,
            .jumpMotion = JumpMotion.init(-60.0, 0.2 * globals.TARGET_FPS)
        };
    }

    pub fn update(self: *Player, gravity: u32, floor: f32) void {
        self.handleVerticalMotion(gravity, floor);
        self.handleLateralMotion();
        self.pos.x += self.vel.x;
        self.pos.y += self.vel.y;
    }

    pub fn render(self: *Player) void {
        rl.drawRectangleV(self.pos, self.size, rl.Color.black);
    }

    pub fn setJumpState(self: *Player, jump_state: JumpState) void {
        self.jumpState = jump_state;
    }

    pub fn setFacingState(self: *Player, facing_state: FacingState) void {
        self.facing = facing_state;
    }

    pub fn setLateralMotionState(self: *Player, lateral_motion_state: LateralMotionState) void {
        self.lateralMotionState = lateral_motion_state;
    }

};
