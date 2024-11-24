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

// Objects
const WALK =
    LateralMotion.init(5.0, 0.3);
const RUN =
    LateralMotion.init(10.0, 0.2);
const IDLE =
    LateralMotion.init(0.0, 0.0);

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
        if (self.lateralMotionState == LateralMotionState.IDLE) {
            self.vel.x = 0.0;
            return;
        }
        const direction: f32 = switch (self.facing) {
            FacingState.LEFT => -1.0,
            FacingState.RIGHT => 1.0,
        };
        if (self.vel.x * direction < self.lateralMotion.targetSpeed) {
            self.vel.x += direction * self.lateralMotion.acceleration;
        } else {
            self.vel.x = direction * self.lateralMotion.targetSpeed;
        }
    }

    // Public functions
    pub fn init(x: f32, y: f32) Player {
        return Player{ .size = rl.Vector2.init(24, 32), .pos = rl.Vector2.init(x, y), .vel = rl.Vector2.init(0.0, 0.0), .facing = FacingState.RIGHT, .lateralMotionState = LateralMotionState.IDLE, .lateralMotion = IDLE, .jumpState = JumpState.FALLING, .jumpMotion = JumpMotion.init(-60.0, 0.2 * globals.TARGET_FPS) };
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

    // Player Lateral Motion Action
    pub fn beginWalking(self: *Player, facing: FacingState) void {
        self.facing = facing;
        self.lateralMotionState = switch (self.facing) {
            FacingState.LEFT => LateralMotionState.WALK_LEFT,
            FacingState.RIGHT => LateralMotionState.WALK_RIGHT,
        };
        self.lateralMotion = WALK;
    }

    pub fn beginRunning(self: *Player, facing: FacingState) void {
        if (@abs(self.vel.x) < WALK.targetSpeed) {
            self.beginWalking(facing);
            return;
        }
        self.facing = facing;
        switch (self.facing) {
            FacingState.LEFT => {
                self.lateralMotionState = LateralMotionState.RUN_LEFT;
            },
            FacingState.RIGHT => {
                self.lateralMotionState = LateralMotionState.RUN_RIGHT;
            },
        }
        self.lateralMotion = RUN;
    }

    pub fn beginStopping(self: *Player) void {
        self.lateralMotionState = LateralMotionState.STOPPING;
    }

    pub fn finishStopping(self: *Player) void {
        self.lateralMotionState = LateralMotionState.IDLE;
    }

    // Player Jump Action
    pub fn beginJumpAction(self: *Player) void {
        self.jumpState = JumpState.START_JUMP;
    }

    pub fn continueJumping(self: *Player) void {
        self.jumpState = JumpState.ASCENDING;
    }

    pub fn stopJumping(self: *Player) void {
        self.jumpState = JumpState.APEX;
    }

    pub fn startFalling(self: *Player) void {
        self.jumpState = JumpState.FALLING;
    }

    pub fn stopFalling(self: *Player) void {
        self.jumpState = JumpState.LANDING;
    }

    pub fn endJumpAction(self: *Player) void {
        self.jumpState = JumpState.GROUNDED;
    }
};
