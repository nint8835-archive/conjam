import gleam/javascript/array
import gleam/list

type Pixel =
  #(Int, Int, Int, Int)

fn create_pixel(data: List(Int)) -> Pixel {
  case data {
    [r, g, b, a] -> #(r, g, b, a)
    _ -> panic("Invalid input")
  }
}

fn deconstruct_pixel(pixel: Pixel) -> List(Int) {
  let #(r, g, b, a) = pixel
  [r, g, b, a]
}

fn process_pixel(_: Pixel, i: Int) -> Pixel {
  case i % 11 {
    0 -> #(255, 0, 0, 255)
    1 -> #(0, 255, 0, 255)
    2 -> #(0, 0, 255, 255)
    3 -> #(255, 255, 0, 255)
    _ -> #(0, 0, 0, 255)
  }
}

pub fn generate_image_data(in: array.Array(Int)) -> array.Array(Int) {
  in
  |> array.to_list
  |> list.sized_chunk(into: 4)
  |> list.map(create_pixel)
  |> list.index_map(process_pixel)
  |> list.map(deconstruct_pixel)
  |> list.flatten
  |> array.from_list
}
