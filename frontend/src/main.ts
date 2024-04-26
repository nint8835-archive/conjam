import { draw_frame } from '@/conjam.mjs';
import './index.css';

const scaleFactor = 1;

let frameNumber = 0;
let lastFrameTime = performance.now();
let mouseDown = false;
let mouseX = 0;
let mouseY = 0;

const fpsElement = document.getElementById('fps')! as HTMLDivElement;

function tickFrame() {
    draw_frame(frameNumber, mouseDown, mouseX, mouseY);
    const newFrameTime = performance.now();
    const fps = 1000 / (newFrameTime - lastFrameTime);

    if (frameNumber % 60 === 0) {
        fpsElement.textContent = `FPS: ${Math.trunc(fps)}`;
    }

    lastFrameTime = newFrameTime;

    frameNumber++;
    requestAnimationFrame(tickFrame);
}

function init() {
    const canvas = document.getElementById('canvas')! as HTMLCanvasElement;

    // const ctx = canvas.getContext('2d')!;
    // const imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);

    // for (let i = 0; i < imageData.data.length; i += 4) {
    //     const r = Math.random() * 255;
    //     const g = Math.random() * 255;
    //     const b = Math.random() * 255;

    //     imageData.data[i] = r;
    //     imageData.data[i + 1] = g;
    //     imageData.data[i + 2] = b;
    //     imageData.data[i + 3] = 255;
    // }

    // ctx.putImageData(imageData, 0, 0);

    canvas.addEventListener('mousedown', (event) => {
        mouseDown = true;
        mouseX = Math.trunc(event.offsetX / scaleFactor);
        mouseY = Math.trunc(event.offsetY / scaleFactor);
    });
    canvas.addEventListener('mouseup', () => {
        mouseDown = false;
    });
    canvas.addEventListener('mousemove', (event) => {
        mouseX = Math.trunc(event.offsetX / scaleFactor);
        mouseY = Math.trunc(event.offsetY / scaleFactor);
    });

    requestAnimationFrame(tickFrame);
}

init();
