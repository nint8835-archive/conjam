import canvas
import constants.{max_x, max_y}
import gleam/bool
import properties

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

  use <- bool.guard(
    when: !properties.has_property(pixel_val, properties.experiences_gravity),
    return: frame_data,
  )

  let pixel_floats = properties.has_property(pixel_val, properties.floats)

  let below_pixel_val =
    frame_data
    |> canvas.get_pixel(x, y + 1)

  let below_pixel_floats =
    properties.has_property(below_pixel_val, properties.floats)

  case below_pixel_val {
    0x00000000 ->
      frame_data
      |> canvas.set_pixel(x, y + 1, pixel_val)
      |> canvas.set_pixel(x, y, 0x00000000)
    other if below_pixel_floats && !pixel_floats ->
      frame_data
      |> canvas.set_pixel(x, y + 1, pixel_val)
      |> canvas.set_pixel(x, y, other)
    _ -> {
      let next_x = x + next_pixel_offset

      let below_next_pixel_val = {
        case next_x > max_x || next_x < 0 {
          True -> 0xfffffeff
          False ->
            frame_data
            |> canvas.get_pixel(next_x, y + 1)
        }
      }

      let below_next_pixel_floats =
        properties.has_property(below_next_pixel_val, properties.floats)

      case below_next_pixel_val {
        0x00000000 ->
          frame_data
          |> canvas.set_pixel(next_x, y + 1, pixel_val)
          |> canvas.set_pixel(x, y, 0x00000000)
        other if below_next_pixel_floats && !pixel_floats ->
          frame_data
          |> canvas.set_pixel(next_x, y + 1, pixel_val)
          |> canvas.set_pixel(x, y, other)
        _ -> {
          let prev_x = x - next_pixel_offset

          let below_prev_pixel_val = {
            case prev_x > max_x || prev_x < 0 {
              True -> 0xfffffeff
              False ->
                frame_data
                |> canvas.get_pixel(prev_x, y + 1)
            }
          }

          let below_prev_pixel_floats =
            properties.has_property(below_prev_pixel_val, properties.floats)

          case below_prev_pixel_val {
            0x00000000 ->
              frame_data
              |> canvas.set_pixel(prev_x, y + 1, pixel_val)
              |> canvas.set_pixel(x, y, 0x00000000)
            other if below_prev_pixel_floats && !pixel_floats ->
              frame_data
              |> canvas.set_pixel(prev_x, y + 1, pixel_val)
              |> canvas.set_pixel(x, y, other)
            _ -> frame_data
          }
        }
      }
    }
  }
}
