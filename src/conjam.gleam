import canvas/canvas

fn apply_gravity(frame_data: canvas.ImageData, index: Int) -> canvas.ImageData {
  let x = index % canvas.canvas_width
  let y = index / canvas.canvas_width

  case y == canvas.canvas_height - 1 {
    True -> frame_data
    False -> {
      let pixel_val =
        frame_data
        |> canvas.get_index(index)
      let below_pixel_val =
        frame_data
        |> canvas.get_index(index + canvas.canvas_width)
      let below_left_pixel_val =
        frame_data
        |> canvas.get_index(index + canvas.canvas_width - 1)
      let below_right_pixel_val =
        frame_data
        |> canvas.get_index(index + canvas.canvas_width + 1)

      case
        pixel_val,
        below_pixel_val,
        below_left_pixel_val,
        below_right_pixel_val
      {
        #(0, 0, 0, 0), _, _, _ -> frame_data
        _, #(0, 0, 0, 0), _, _ ->
          frame_data
          |> canvas.set_index(index + canvas.canvas_width, pixel_val)
          |> canvas.set_index(index, #(0, 0, 0, 0))
        _, _, #(0, 0, 0, 0), _ if x > 0 -> {
          frame_data
          |> canvas.set_index(index + canvas.canvas_width - 1, pixel_val)
          |> canvas.set_index(index, #(0, 0, 0, 0))
        }
        _, _, _, #(0, 0, 0, 0) if x < 159 -> {
          frame_data
          |> canvas.set_index(index + canvas.canvas_width + 1, pixel_val)
          |> canvas.set_index(index, #(0, 0, 0, 0))
        }
        _, _, _, _ -> frame_data
      }
    }
  }
}

fn iter_pixels(
  frame_data: canvas.ImageData,
  frame_number: Int,
  index: Int,
) -> canvas.ImageData {
  case index {
    -1 -> frame_data
    _ -> {
      let new_frame_data = case
        index / canvas.canvas_width
        == canvas.canvas_height - 1
      {
        True -> frame_data
        False ->
          frame_data
          |> apply_gravity(index)
      }

      iter_pixels(new_frame_data, frame_number, index - 1)
    }
  }
}

pub fn draw_frame(
  frame_number: Int,
  mouse_down: Bool,
  mouse_x: Int,
  mouse_y: Int,
) {
  use data <- canvas.mutate_frame()

  let initial_data = case mouse_down {
    True -> {
      data
      |> canvas.set_index(mouse_y * canvas.canvas_width + mouse_x, #(
        255,
        255,
        255,
        255,
      ))
    }
    False -> data
  }

  initial_data
  |> iter_pixels(frame_number, canvas.canvas_height * canvas.canvas_width)
}
