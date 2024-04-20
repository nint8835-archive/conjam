pub type ImageData

pub type Pixel =
  #(Int, Int, Int, Int)

const canvas_width = 640

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

pub fn make_test_pixels(image_data: ImageData) -> ImageData {
  image_data
  |> set_pixel(100, 100, #(255, 0, 0, 255))
  |> set_pixel(101, 100, #(0, 255, 0, 255))
  |> set_pixel(102, 100, #(0, 0, 255, 255))
  |> set_pixel(103, 100, #(255, 255, 0, 255))
  |> set_pixel(104, 100, #(255, 0, 255, 255))
  |> set_pixel(105, 100, #(0, 255, 255, 255))
  |> set_pixel(106, 100, #(255, 255, 255, 255))
}
