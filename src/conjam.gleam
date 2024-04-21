import canvas/canvas

fn iter_pixels(
  frame_number: Int,
  index: Int,
  frame_data: canvas.ImageData,
) -> canvas.ImageData {
  case index {
    -1 -> frame_data
    _ -> {
      let new_frame_data = case
        index / canvas.canvas_width
        == canvas.canvas_height - 1
      {
        True -> frame_data
        False -> {
          let pixel_val =
            frame_data
            |> canvas.get_index(index)
          let below_pixel_val =
            frame_data
            |> canvas.get_index(index + canvas.canvas_width)

          case pixel_val, below_pixel_val {
            #(0, 0, 0, 0), _ -> frame_data
            _, #(0, 0, 0, 0) ->
              frame_data
              |> canvas.set_index(index + canvas.canvas_width, pixel_val)
              |> canvas.set_index(index, #(0, 0, 0, 0))
            _, _ -> {
              let diagonal_left_val =
                frame_data
                |> canvas.get_index(index + canvas.canvas_width - 1)
              let diagonal_right_val =
                frame_data
                |> canvas.get_index(index + canvas.canvas_width + 1)
              let x = index % canvas.canvas_width

              case diagonal_left_val, diagonal_right_val {
                #(0, 0, 0, 0), _ if x > 0 -> {
                  frame_data
                  |> canvas.set_index(
                    index + canvas.canvas_width - 1,
                    pixel_val,
                  )
                  |> canvas.set_index(index, #(0, 0, 0, 0))
                }
                _, #(0, 0, 0, 0) if x < 639 -> {
                  frame_data
                  |> canvas.set_index(
                    index + canvas.canvas_width + 1,
                    pixel_val,
                  )
                  |> canvas.set_index(index, #(0, 0, 0, 0))
                }
                _, _ -> frame_data
              }
            }
          }
        }
      }

      iter_pixels(frame_number, index - 1, new_frame_data)
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
  iter_pixels(
    frame_number,
    canvas.canvas_height * canvas.canvas_width,
    initial_data,
  )
}