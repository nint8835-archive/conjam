import brush.{apply_brush}
import canvas
import collapse.{collapse_like}
import constants.{max_x, max_y}
import gravity.{apply_gravity}

pub fn draw_frame(
  frame_number: Int,
  mouse_down: Bool,
  mouse_x: Int,
  mouse_y: Int,
  brush_size: Int,
  brush_colour: canvas.Pixel,
) {
  use data <- canvas.mutate_frame()

  let initial_data = case mouse_down {
    True -> {
      data
      |> apply_brush(mouse_x, mouse_y, brush_size, brush_colour)
    }
    False -> data
  }

  let initial_move_direction = 2 * { frame_number % 2 } - 1

  let initial_x = case initial_move_direction {
    -1 -> max_x
    1 -> 0
    _ -> panic("Mathematically impossible")
  }

  initial_data
  |> iter_pixels(initial_x, max_y, initial_move_direction)
}

fn iter_pixels(
  frame_data: canvas.ImageData,
  x: Int,
  y: Int,
  next_pixel_offset: Int,
) -> canvas.ImageData {
  case x, y {
    _, -1 -> frame_data
    -1, _ -> iter_pixels(frame_data, max_x, y - 1, next_pixel_offset)
    x, _ if x > max_x -> iter_pixels(frame_data, 0, y - 1, next_pixel_offset)
    _, _ -> {
      let new_frame_data =
        frame_data
        |> apply_gravity(x, y, next_pixel_offset)
        |> collapse_like(x, y)

      iter_pixels(new_frame_data, x + next_pixel_offset, y, next_pixel_offset)
    }
  }
}
