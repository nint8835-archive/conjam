import canvas/canvas
import gleam/float
import gleam/int
import gleam/list
import gleam/result

const max_x = 159

const max_y = 119

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

fn average_pixels(frame_data: canvas.ImageData, index: Int) -> canvas.ImageData {
  let x = index % canvas.canvas_width
  let y = index / canvas.canvas_width

  case y == max_y || x == 0 || x == max_x {
    True -> frame_data
    False -> {
      let pixel_val =
        frame_data
        |> canvas.get_index(index)

      case pixel_val {
        #(0, 0, 0, 0) -> frame_data
        _ -> {
          let down_left_pixel_val =
            frame_data
            |> canvas.get_index(index + canvas.canvas_width - 1)
          let down_pixel_val =
            frame_data
            |> canvas.get_index(index + canvas.canvas_width)
          let down_right_pixel_val =
            frame_data
            |> canvas.get_index(index + canvas.canvas_width + 1)

          let pixels =
            [
              pixel_val,
              down_left_pixel_val,
              down_pixel_val,
              down_right_pixel_val,
            ]
            |> list.filter(fn(x) { x != #(0, 0, 0, 0) })

          frame_data
          |> canvas.set_index(index, #(
            average_channel(
              pixels
              |> list.map(fn(x) { x.0 }),
            ),
            average_channel(
              pixels
              |> list.map(fn(x) { x.1 }),
            ),
            average_channel(
              pixels
              |> list.map(fn(x) { x.2 }),
            ),
            average_channel(
              pixels
              |> list.map(fn(x) { x.3 }),
            ),
          ))
        }
      }
    }
  }
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
      let new_frame_data =
        frame_data
        |> apply_gravity(index)
        |> average_pixels(index)

      iter_pixels(new_frame_data, frame_number, index - 1)
    }
  }
}

const brush_size = 5

fn apply_brush(
  frame_data: canvas.ImageData,
  mouse_x: Int,
  mouse_y: Int,
) -> canvas.ImageData {
  let colour = random_colour()

  list.range(brush_size / -2, brush_size / 2 + 1)
  |> list.fold(frame_data, fn(row_data, y) {
    list.range(brush_size / -2, brush_size / 2 + 1)
    |> list.fold(row_data, fn(pixel_data, x) {
      pixel_data
      |> canvas.set_pixel(mouse_x + x, mouse_y + y, colour)
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
