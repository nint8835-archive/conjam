import canvas
import constants.{max_y}
import gleam/bool

pub fn collapse_like(
  frame_data: canvas.ImageData,
  x: Int,
  y: Int,
) -> canvas.ImageData {
  use <- canvas.ensure_pixel_exists(frame_data, x, y)
  use <- bool.guard(when: y == max_y, return: frame_data)

  let pixel_val =
    frame_data
    |> canvas.get_pixel(x, y)
  let below_pixel_val =
    frame_data
    |> canvas.get_pixel(x, y + 1)

  case pixel_val == below_pixel_val && pixel_val != 0x00000000 {
    True ->
      frame_data
      |> canvas.set_pixel(x, y + 1, 0x00000000)
    False -> frame_data
  }
}
