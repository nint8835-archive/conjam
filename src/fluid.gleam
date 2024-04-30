import canvas
import constants.{max_x, max_y}
import gleam/bool
import properties

pub fn apply_fluid(
  image_data: canvas.ImageData,
  x: Int,
  y: Int,
  next_pixel_offset: Int,
) -> canvas.ImageData {
  use <- bool.guard(when: y >= max_y, return: image_data)

  let next_x = x + next_pixel_offset

  use <- bool.guard(when: next_x < 0 || next_x > max_x, return: image_data)

  use <- canvas.ensure_pixel_exists(image_data, x, y)

  let pixel_val = canvas.get_pixel(image_data, x, y)

  use <- bool.guard(when: pixel_val == 0x00000000, return: image_data)
  use <- bool.guard(
    when: !properties.has_property(pixel_val, properties.fluid),
    return: image_data,
  )

  let below_pixel_val = canvas.get_pixel(image_data, x, y + 1)
  let below_next_pixel_val = canvas.get_pixel(image_data, next_x, y + 1)

  let prev_x = x - next_pixel_offset

  let previous_pixel_val = case prev_x >= 0 && prev_x <= max_x {
    True -> canvas.get_pixel(image_data, prev_x, y)
    False -> 0x00000000
  }

  use <- bool.guard(
    when: !{
      properties.has_property(below_pixel_val, properties.fluid)
      || properties.has_property(below_next_pixel_val, properties.fluid)
      || properties.has_property(previous_pixel_val, properties.fluid)
    },
    return: image_data,
  )

  let next_pixel_val = canvas.get_pixel(image_data, next_x, y)

  case next_pixel_val {
    0x00000000 -> {
      image_data
      |> canvas.set_pixel(next_x, y, pixel_val)
      |> canvas.set_pixel(x, y, 0x00000000)
    }
    _ -> image_data
  }
}
