import { draw_frame } from '@/conjam.mjs';
import './index.css';

const scaleFactor = 4;

let frameNumber = 0;
let lastFrameTime = performance.now();
let mouseDown = false;
let mouseX = 0;
let mouseY = 0;

function tickFrame() {
    draw_frame(frameNumber, mouseDown, mouseX, mouseY);
    const newFrameTime = performance.now();
    const fps = 1000 / (newFrameTime - lastFrameTime);

    if (frameNumber % 600 === 0) {
        console.log(`Frame ${frameNumber} took ${newFrameTime - lastFrameTime}ms (${fps}fps)`);
    }

    lastFrameTime = newFrameTime;

    frameNumber++;
    requestAnimationFrame(tickFrame);
}

function init() {
    const canvas = document.getElementById('canvas')!;

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
