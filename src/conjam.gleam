import canvas/canvas
import gleam/bool
import gleam/float
import gleam/int
import gleam/list
import gleam/result

const max_x = 639

const max_y = 479

fn apply_gravity(
  frame_data: canvas.ImageData,
  x: Int,
  y: Int,
) -> canvas.ImageData {
  use <- canvas.ensure_pixel_exists(frame_data, x, y)
  use <- bool.guard(when: y == max_y, return: frame_data)

  let pixel_val =
    frame_data
    |> canvas.get_pixel(x, y)
  let below_pixel_val =
    frame_data
    |> canvas.get_pixel(x, y + 1)
  let below_left_pixel_val =
    frame_data
    |> canvas.get_pixel(x - 1, y + 1)
  let below_right_pixel_val =
    frame_data
    |> canvas.get_pixel(x + 1, y + 1)

  case pixel_val, below_pixel_val, below_left_pixel_val, below_right_pixel_val {
    0x00000000, _, _, _ -> frame_data
    _, 0x00000000, _, _ ->
      frame_data
      |> canvas.set_pixel(x, y + 1, pixel_val)
      |> canvas.set_pixel(x, y, 0x00000000)
    _, _, 0x00000000, _ if x > 0 -> {
      frame_data
      |> canvas.set_pixel(x - 1, y + 1, pixel_val)
      |> canvas.set_pixel(x, y, 0x00000000)
    }
    _, _, _, 0x00000000 if x < max_x -> {
      frame_data
      |> canvas.set_pixel(x + 1, y + 1, pixel_val)
      |> canvas.set_pixel(x, y, 0x00000000)
    }
    _, _, _, _ -> frame_data
  }
}

fn collapse_like(
  frame_data: canvas.ImageData,
  x: Int,
  y: Int,
) -> canvas.ImageData {
  use <- canvas.ensure_pixel_exists(frame_data, x, y)
  use <- bool.guard(when: y == 0, return: frame_data)

  let pixel_val =
    frame_data
    |> canvas.get_pixel(x, y)
  let above_pixel_val =
    frame_data
    |> canvas.get_pixel(x, y - 1)

  case pixel_val == above_pixel_val && pixel_val != 0x00000000 {
    True ->
      frame_data
      |> canvas.set_pixel(x, y, 0x00000000)
    False -> frame_data
  }
}

fn iter_pixels(frame_data: canvas.ImageData, index: Int) -> canvas.ImageData {
  let x = index % canvas.canvas_width
  let y = index / canvas.canvas_width

  case index {
    -1 -> frame_data
    _ -> {
      let new_frame_data =
        frame_data
        |> apply_gravity(x, y)
        |> collapse_like(x, y)

      iter_pixels(new_frame_data, index - 1)
    }
  }
}

fn apply_brush(
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

      case distance > brush_size {
        True -> pixel_data
        False -> {
          pixel_data
          |> canvas.set_pixel(mouse_x + x, mouse_y + y, brush_colour)
        }
      }
    })
  })
}

pub fn draw_frame(
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

  initial_data
  |> iter_pixels(canvas.canvas_height * canvas.canvas_width)
}
