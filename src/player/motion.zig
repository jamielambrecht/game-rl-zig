// Motion Module

pub const JumpMotion = struct {
    jumpForce: f32,
    hangTime: i32,

    pub fn init(jumpForce: f32, hangTime: i32) JumpMotion {
        return .{
            .jumpForce = jumpForce,
            .hangTime = hangTime,
        };
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