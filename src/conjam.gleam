import canvas/canvas
import gleam/float
import gleam/int
import gleam/list
import gleam/result

const max_x = 159

fn average_channel(values: List(Int)) -> Int {
  values
  |> list.fold(0.0, fn(acc, x) {
    x
    |> int.power(2.0)
    |> result.unwrap(0.0)
    |> fn(x) { x +. acc }
  })
  |> fn(x) { x /. int.to_float(list.length(values)) }
  |> float.square_root()
  |> result.unwrap(0.0)
  |> float.truncate()
}

fn random_colour() -> canvas.Pixel {
  let colours = [#(255, 0, 0, 255), #(0, 255, 0, 255), #(0, 0, 255, 255)]

  colours
  |> list.shuffle()
  |> list.first()
  |> result.unwrap(#(0, 0, 0, 0))
}

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
        _, _, _, #(0, 0, 0, 0) if x < max_x -> {
          frame_data
          |> canvas.set_index(index + canvas.canvas_width + 1, pixel_val)
          |> canvas.set_index(index, #(0, 0, 0, 0))
        }
        #(r1, g1, b1, a1),
          #(r2, g2, b2, a2),
          #(r3, g3, b3, a3),
          #(r4, g4, b4, a4) if x < max_x && x > 0 ->
          frame_data
          |> canvas.set_index(index + canvas.canvas_width, #(
            average_channel([r1, r2, r3, r4]),
            average_channel([g1, g2, g3, g4]),
            average_channel([b1, b2, b3, b4]),
            average_channel([a1, a2, a3, a4]),
          ))
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
      |> canvas.set_index(
        mouse_y * canvas.canvas_width + mouse_x,
        random_colour(),
      )
    }
    False -> data
  }

  initial_data
  |> iter_pixels(frame_number, canvas.canvas_height * canvas.canvas_width)
}
