import canvas
import constants.{max_x, max_y}
import gleam/bool

pub fn apply_gravity(
  frame_data: canvas.ImageData,
  x: Int,
  y: Int,
  next_pixel_offset: Int,
) -> canvas.ImageData {
  use <- canvas.ensure_pixel_exists(frame_data, x, y)
  use <- bool.guard(when: y == max_y, return: frame_data)

  let pixel_val =
    frame_data
    |> canvas.get_pixel(x, y)

  use <- bool.guard(when: pixel_val == 0x00000000, return: frame_data)

  let below_pixel_val =
    frame_data
    |> canvas.get_pixel(x, y + 1)

  case below_pixel_val {
    0x00000000 ->
      frame_data
      |> canvas.set_pixel(x, y + 1, pixel_val)
      |> canvas.set_pixel(x, y, 0x00000000)
    _ -> {
      let next_x = x + next_pixel_offset

      let below_next_pixel_val = {
        case next_x > max_x || next_x < 0 {
          True -> 0xffffffff
          False ->
            frame_data
            |> canvas.get_pixel(next_x, y + 1)
        }
      }

      case below_next_pixel_val {
        0x00000000 ->
          frame_data
          |> canvas.set_pixel(next_x, y + 1, pixel_val)
          |> canvas.set_pixel(x, y, 0x00000000)
        _ -> {
          let prev_x = x - next_pixel_offset

          let below_prev_pixel_val = {
            case prev_x > max_x || prev_x < 0 {
              True -> 0xffffffff
              False ->
                frame_data
                |> canvas.get_pixel(prev_x, y + 1)
            }
          }

          case below_prev_pixel_val {
            0x00000000 ->
              frame_data
              |> canvas.set_pixel(prev_x, y + 1, pixel_val)
              |> canvas.set_pixel(x, y, 0x00000000)
            _ -> frame_data
          }
        }
      }
    }
  }
}
