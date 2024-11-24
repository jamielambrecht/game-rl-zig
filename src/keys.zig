// Keys Module

// Modules
const rl: type = @import("raylib");

// Type Definitions
pub const KeyState = enum {
    NOT_PRESSED,
    PRESSED,
    HELD,
    RELEASED,
};

pub const InputKey = struct {
    key: rl.KeyboardKey,
    state: KeyState,
    heldFor: u64,

    pub fn init(keyboard_key: rl.KeyboardKey) InputKey {
        return .{ 
            .key = keyboard_key, 
            .state = KeyState.NOT_PRESSED, 
            .heldFor = 0 
        };
    }

    pub fn update(self: *InputKey) KeyState {
        if (rl.isKeyDown(self.key)) {
            switch (self.state) {
                KeyState.NOT_PRESSED, KeyState.RELEASED => {
                    self.state = KeyState.PRESSED;
                },
                KeyState.PRESSED => {
                    self.state = KeyState.HELD;
                    self.heldFor = 1;
                },
                KeyState.HELD => {
                    self.heldFor += 1;
                },
            }
        } else {
            switch (self.state) {
                KeyState.PRESSED, KeyState.HELD => {
                    self.state = KeyState.RELEASED;
                },
                KeyState.RELEASED => {
                    self.heldFor = 0;
                    self.state = KeyState.NOT_PRESSED;
                },
                else => {},
            }
        }
        return self.state;
    }

    pub fn isDown(self: *InputKey) bool {
        return rl.isKeyDown(self.key);
    }
};
