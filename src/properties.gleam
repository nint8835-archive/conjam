// 00000000 00000001 00000000 00000000
pub const grows = 0x00010000

// 00000000 00000000 00000100 00000000
pub const fluid = 0x00000400

// 00000000 00000000 00000010 00000000
pub const causes_growth = 0x00000200

// 00000000 00000000 00000001 00000000
pub const floats = 0x00000100

// 00000000 00000000 00000000 00000001
pub const experiences_gravity = 0x00000001

@external(javascript, "./ffi.mjs", "hasProperty")
pub fn has_property(pixel_val: Int, property: Int) -> Bool
