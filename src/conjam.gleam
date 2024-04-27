import canvas/canvas
import gleam/float
import gleam/int
import gleam/list
import gleam/result

const max_x = 639

const max_y = 479

fn random_colour() -> canvas.Pixel {
  let colours = [0xff0000ff, 0x00ff00ff, 0x0000ffff]

  colours
  |> list.shuffle()
  |> list.first()
  |> result.unwrap(0x00000000)
}

fn apply_gravity(frame_data: canvas.ImageData, index: Int) -> canvas.ImageData {
  let x = index % canvas.canvas_width
  let y = index / canvas.canvas_width

  case y == max_y {
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
        0x00000000, _, _, _ -> frame_data
        _, 0x00000000, _, _ ->
          frame_data
          |> canvas.set_pixel(x, y + 1, pixel_val)
          |> canvas.set_index(index, 0x00000000)
        _, _, 0x00000000, _ if x > 0 -> {
          frame_data
          |> canvas.set_index(index + canvas.canvas_width - 1, pixel_val)
          |> canvas.set_index(index, 0x00000000)
        }
        _, _, _, 0x00000000 if x < max_x -> {
          frame_data
          |> canvas.set_index(index + canvas.canvas_width + 1, pixel_val)
          |> canvas.set_index(index, 0x00000000)
        }
        _, _, _, _ -> frame_data
      }
    }
  }
}

fn collapse_like(frame_data: canvas.ImageData, index: Int) -> canvas.ImageData {
  let x = index % canvas.canvas_width
  let y = index / canvas.canvas_width

  let index_val = canvas.get_pixel(frame_data, x, y)

  case index_val == 0x00000000 {
    True -> frame_data
    False -> {
      let matching =
        canvas.get_neighbours_matching(frame_data, x, y, fn(pixel) {
          index_val == pixel
        })

      case matching {
        0 -> frame_data
        _ -> {
          frame_data
          |> canvas.set_pixel(x, y, 0x00000000)
        }
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
      let new_frame_data =
        frame_data
        |> apply_gravity(index)
        |> collapse_like(index)

      iter_pixels(new_frame_data, frame_number, index - 1)
    }
  }
}

const brush_size = 20

fn apply_brush(
  frame_data: canvas.ImageData,
  mouse_x: Int,
  mouse_y: Int,
) -> canvas.ImageData {
  let colour = random_colour()

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

      case distance > brush_size {
        True -> pixel_data
        False -> {
          pixel_data
          |> canvas.set_pixel(mouse_x + x, mouse_y + y, colour)
        }
      }
    })
  })
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
      |> apply_brush(mouse_x, mouse_y)
    }
    False -> data
  }

  initial_data
  |> iter_pixels(frame_number, canvas.canvas_height * canvas.canvas_width)
}
