// Motion Module
const JumpState = @import("state.zig").JumpState;

pub const JumpMotion = struct {
    jumpForce: f32,
    hangTime: i32,
    jumpState: JumpState,

    pub fn init(jumpForce: f32, hangTime: i32, jump_state: JumpState) JumpMotion {
        return .{
            .jumpForce = jumpForce,
            .hangTime = hangTime,
            .jumpState = jump_state,
        };
    }

    pub fn getJumpForce(self: *JumpMotion) f32 {
        return self.jumpForce;
    }

    pub fn getJumpState(self: *JumpMotion) JumpState {
        return self.jumpState;
    }

    pub fn setJumpState(self: *JumpMotion, jump_state: JumpState) void {
        self.jumpState = jump_state;
    }
};

pub const LateralMotion = struct {
    targetSpeed: f32,
    acceleration: f32,

    pub fn init(target_speed: f32, acceleration: f32) LateralMotion {
        return .{
            .targetSpeed = target_speed,
            .acceleration = acceleration,
        };
    }
};