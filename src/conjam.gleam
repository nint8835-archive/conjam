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

fn collapse_like(
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

  case pixel_val == below_pixel_val && pixel_val != 0x00000000 {
    True ->
      frame_data
      |> canvas.set_pixel(x, y + 1, 0x00000000)
    False -> frame_data
  }
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

      let new_x = mouse_x + x
      let new_y = mouse_y + y

      case
        distance > brush_size
        || new_x < 0
        || new_x > max_x
        || new_y < 0
        || new_y > max_y
      {
        True -> pixel_data
        False -> {
          pixel_data
          |> canvas.set_pixel(new_x, new_y, brush_colour)
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
