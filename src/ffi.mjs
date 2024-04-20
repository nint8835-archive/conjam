/**
 * Gets the data for a pixel at a given index.
 * @param {ImageData} imageData - The image data.
 * @param {number} index - The index of the pixel.
 * @returns {Array<number>} The pixel data.
 */
export function getIndex(imageData, index) {
  return imageData.data.slice(index * 4, index * 4 + 4);
}

/**
 * Sets the data for a pixel at a given index.
 * @param {ImageData} imageData - The image data.
 * @param {number} index - The index of the pixel.
 * @param {Array<number>} value - The pixel data.
 * @returns {ImageData} - The image data.
 */
export function setIndex(imageData, index, value) {
  imageData.data[index * 4] = value[0];
  imageData.data[index * 4 + 1] = value[1];
  imageData.data[index * 4 + 2] = value[2];
  imageData.data[index * 4 + 3] = value[3];

  return imageData;
}
