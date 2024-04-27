pub type ImageData

pub type Pixel =
  Int

pub const canvas_width = 640

pub const canvas_height = 480

@external(javascript, "../ffi.mjs", "getIndex")
pub fn get_index(image_data: ImageData, index: Int) -> Pixel

pub fn get_pixel(image_data: ImageData, x: Int, y: Int) -> Pixel {
  image_data
  |> get_index(y * canvas_width + x)
}

@external(javascript, "../ffi.mjs", "setIndex")
pub fn set_index(image_data: ImageData, index: Int, pixel: Pixel) -> ImageData

pub fn set_pixel(
  image_data: ImageData,
  x: Int,
  y: Int,
  pixel: Pixel,
) -> ImageData {
  image_data
  |> set_index(y * canvas_width + x, pixel)
}

@external(javascript, "../ffi.mjs", "mutateFrame")
pub fn mutate_frame(mutator: fn(ImageData) -> ImageData) -> Nil

@external(javascript, "../ffi.mjs", "getNeighboursMatching")
pub fn get_neighbours_matching(
  image_data: ImageData,
  x: Int,
  y: Int,
  predicate: fn(Pixel) -> Bool,
) -> Int

@external(javascript, "../ffi.mjs", "ensurePixelExists")
pub fn ensure_pixel_exists(
  image_data: ImageData,
  x: Int,
  y: Int,
  callback: fn() -> ImageData,
) -> ImageData
