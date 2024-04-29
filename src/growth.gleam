import canvas
import constants.{max_x, max_y}
import gleam/bool
import properties

pub fn apply_growth(
  image_data: canvas.ImageData,
  x: Int,
  y: Int,
  next_pixel_offset: Int,
) -> canvas.ImageData {
  use <- canvas.ensure_pixel_exists(image_data, x, y)

  let pixel_val = canvas.get_pixel(image_data, x, y)

  use <- bool.guard(when: pixel_val == 0x00000000, return: image_data)
  use <- bool.guard(
    when: !properties.has_property(pixel_val, properties.grows),
    return: image_data,
  )

  let next_x = x + next_pixel_offset

  let next_pixel_val = case next_x < 0 || next_x > max_x {
    True -> 0x00000000
    False -> canvas.get_pixel(image_data, next_x, y)
  }

  let next_pixel_causes_growth =
    properties.has_property(next_pixel_val, properties.causes_growth)

  case next_pixel_causes_growth {
    True -> {
      image_data
      |> canvas.set_pixel(next_x, y, pixel_val)
    }
    False -> {
      let above_pixel_val = case y + 1 > max_y {
        True -> 0x00000000
        False -> canvas.get_pixel(image_data, x, y + 1)
      }

      let above_pixel_causes_growth =
        properties.has_property(above_pixel_val, properties.causes_growth)

      case above_pixel_causes_growth {
        True -> {
          image_data
          |> canvas.set_pixel(x, y + 1, pixel_val)
        }
        False -> {
          let below_pixel_val = case y - 1 < 0 {
            True -> 0x00000000
            False -> canvas.get_pixel(image_data, x, y - 1)
          }

          let below_pixel_causes_growth =
            properties.has_property(below_pixel_val, properties.causes_growth)

          case below_pixel_causes_growth {
            True -> {
              image_data
              |> canvas.set_pixel(x, y - 1, pixel_val)
            }
            False -> image_data
          }
        }
      }
    }
  }
}
