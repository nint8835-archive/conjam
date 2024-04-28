import canvas
import constants.{max_x, max_y}
import gleam/float
import gleam/int
import gleam/list
import gleam/result

pub fn apply_brush(
  frame_data: canvas.ImageData,
  mouse_x: Int,
  mouse_y: Int,
  brush_size: Int,
  brush_colour: canvas.Pixel,
) -> canvas.ImageData {
  list.range(-1 * brush_size, brush_size)
  |> list.fold(frame_data, fn(row_data, y) {
    list.range(-1 * brush_size, brush_size)
    |> list.fold(row_data, fn(pixel_data, x) {
      let distance =
        float.square_root(
          {
            int.power(x, 2.0)
            |> result.unwrap(0.0)
          }
          +. {
            int.power(y, 2.0)
            |> result.unwrap(0.0)
          },
        )
        |> result.unwrap(0.0)
        |> float.round()

      let new_x = mouse_x + x
      let new_y = mouse_y + y

      case
        distance > brush_size
        || new_x < 0
        || new_x > max_x
        || new_y < 0
        || new_y > max_y
      {
        True -> pixel_data
        False -> {
          pixel_data
          |> canvas.set_pixel(new_x, new_y, brush_colour)
        }
      }
    })
  })
}
