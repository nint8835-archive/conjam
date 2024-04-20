import { draw_frame } from '@/conjam.mjs';
import './index.css';

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
        mouseX = event.offsetX;
        mouseY = event.offsetY;
    });
    canvas.addEventListener('mouseup', () => {
        mouseDown = false;
    });
    canvas.addEventListener('mousemove', (event) => {
        mouseX = event.offsetX;
        mouseY = event.offsetY;
    });

    requestAnimationFrame(tickFrame);
}

init();
