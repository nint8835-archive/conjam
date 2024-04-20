import canvas/canvas
import gleam/float
import gleam/int
import gleam/list

fn scale(max_val: Int, target_num: Int, current_val: Int) -> Int {
  float.truncate(
    int.to_float(current_val)
    /. int.to_float(max_val)
    *. int.to_float(target_num),
  )
}

pub fn create_test_pixels() {
  use data <- canvas.mutate_frame()

  list.range(0, 479)
  |> list.fold(data, fn(row_data, y) {
    list.range(0, 639)
    |> list.fold(row_data, fn(current_data, x) {
      current_data
      |> canvas.set_pixel(x, y, #(
        scale(640, 255, x),
        scale(480, 255, y),
        scale({ 640 + 480 }, 255, x + y),
        255,
      ))
    })
  })
}
