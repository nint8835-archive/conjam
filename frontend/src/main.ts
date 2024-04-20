import { draw_frame } from '@/conjam.mjs';
import './index.css';

let frameNumber = 0;
let lastFrameTime = performance.now();

function tickFrame() {
    draw_frame(frameNumber);
    const newFrameTime = performance.now();
    const fps = 1000 / (newFrameTime - lastFrameTime);
    lastFrameTime = newFrameTime;

    if (frameNumber % 600 === 0) {
        console.log(`Frame ${frameNumber} took ${newFrameTime - lastFrameTime}ms (${fps}fps)`);
    }

    frameNumber++;
    requestAnimationFrame(tickFrame);
}

function init() {
    requestAnimationFrame(tickFrame);
}

init();
