import canvas/canvas
import gleam/float
import gleam/int

fn scale(max_val: Int, target_num: Int, current_val: Int) -> Int {
  float.truncate(
    int.to_float(current_val % max_val)
    /. int.to_float(max_val)
    *. int.to_float(target_num),
  )
}

fn iter_pixels(
  frame_number: Int,
  index: Int,
  frame_data: canvas.ImageData,
) -> canvas.ImageData {
  case index {
    307_200 -> frame_data
    _ ->
      iter_pixels(
        frame_number,
        index + 1,
        canvas.set_index(frame_data, index, {
          let y = index / 640
          let x = index % 640
          let r = scale(640, 255, x)
          let g = scale(480, 255, y)
          let b = scale(255, 255, frame_number)

          #(r, g, b, 255)
        }),
      )
  }
}

pub fn draw_frame(frame_number: Int) {
  use data <- canvas.mutate_frame()

  iter_pixels(frame_number, 0, data)
}
