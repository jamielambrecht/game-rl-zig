// State Module

pub const FacingState = enum(i8) { 
    LEFT = -1, 
    RIGHT = 1 
};

pub const JumpState = enum(u32) { 
    GROUNDED, 
    ASCENDING, 
    APEX, 
    FALLING 
};

pub const LateralMotionState = enum(u32) {
    IDLE,
    WALK_LEFT,
    WALK_RIGHT,
    RUN_LEFT,
    RUN_RIGHT,
    STOPPING,
};
