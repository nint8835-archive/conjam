import { generate_image_data } from '@/conjam.mjs';
import './index.css';

function init() {
    const canvas = document.getElementById('canvas') as HTMLCanvasElement;
    const context = canvas.getContext('2d')!;
    const imageData = context.getImageData(0, 0, canvas.width, canvas.height);
    const newImageData = new ImageData(
        new Uint8ClampedArray(generate_image_data(Array.from(imageData.data))),
        imageData.width,
        imageData.height,
    );
    context.putImageData(newImageData, 0, 0);
}

init();
