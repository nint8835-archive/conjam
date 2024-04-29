const canvasWidth = 640;
const canvasHeight = 480;

/**
 * Gets the data for a pixel at a given index.
 * @param {ImageData} imageData - The image data.
 * @param {number} index - The index of the pixel.
 * @returns {number} The pixel data.
 */
export function getIndex(imageData, index) {
  const data = imageData.data;
  const baseIndex = index * 4;
  return (
    (data[baseIndex] << 24) |
    (data[baseIndex + 1] << 16) |
    (data[baseIndex + 2] << 8) |
    data[baseIndex + 3]
  );
}

/**
 * Sets the data for a pixel at a given index.
 * @param {ImageData} imageData - The image data.
 * @param {number} index - The index of the pixel.
 * @param {number} value - The pixel data.
 * @returns {ImageData} - The image data.
 */
export function setIndex(imageData, index, value) {
  const baseIndex = index * 4;
  const data = imageData.data;

  data[baseIndex] = (value >> 24) & 0xff;
  data[baseIndex + 1] = (value >> 16) & 0xff;
  data[baseIndex + 2] = (value >> 8) & 0xff;
  data[baseIndex + 3] = value & 0xff;

  return imageData;
}

/**
 * Mutates a frame.
 * @param {(ImageData) -> ImageData} mutator - The mutator function.
 */
export function mutateFrame(mutator) {
  const canvas = document.getElementById("canvas");
  const context = canvas.getContext("2d");

  const initialImageData = context.getImageData(
    0,
    0,
    canvasWidth,
    canvasHeight
  );
  const mutatedImageData = mutator(initialImageData);
  context.putImageData(mutatedImageData, 0, 0);
}

/**
 * Gets neighbouring pixels matching a given function
 * @param {ImageData} imageData - The image data.
 * @param {number} x - The x-coordinate of the pixel.
 * @param {number} y - The y-coordinate of the pixel.
 * @param {(number) -> bool} matcher - The function to match the pixel.
 */
export function getNeighboursMatching(imageData, x, y, matcher) {
  let count = 0;
  for (let dx = -1; dx <= 1; dx++) {
    for (let dy = -1; dy <= 1; dy++) {
      const newX = x + dx;
      const newY = y + dy;

      if (
        newX < 0 ||
        newX >= canvasWidth ||
        newY < 0 ||
        newY >= canvasHeight
        // (x === newX && y === newY)
        // (dx !== 0 && dy !== 0)
      ) {
        continue;
      }

      if (matcher(getIndex(imageData, newY * canvasWidth + newX))) {
        count++;
      }
    }

    return count;
  }
}

/**
 * Ensures a given pixel exists before applying a callback.
 * @param {ImageData} imageData - The image data.
 * @param {number} x - The x-coordinate of the pixel.
 * @param {number} y - The y-coordinate of the pixel.
 * @param {() => ImageData} callback - The callback to apply.
 * @returns {ImageData} - The resulting image data.
 */
export function ensurePixelExists(imageData, x, y, callback) {
  if (!imageData.data[(y * canvasWidth + x) * 4 + 3]) {
    return imageData;
  }

  return callback(imageData, x, y);
}

/**
 * Returns whether a given pixel value has a given property.
 * @param {number} pixelVal - The pixel value.
 * @param {number} property - The property.
 * @returns {bool} - Whether the pixel value has the property.
 */
export function hasProperty(pixelVal, property) {
  return !!(pixelVal & property);
}
