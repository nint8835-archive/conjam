import { draw_frame } from '@/conjam.mjs';

import { writable } from 'svelte/store';


const scaleFactor = 1;

const state = {
    frameNumber : 0,
    frameRate: 0,
    lastFrameTime : performance.now(),
    mouseDown : false,
    mouseX : 0,
    mouseY : 0,
}
export const store = writable(state);

function tickFrame() {
    draw_frame(state.frameNumber, state.mouseDown, state.mouseX, state.mouseY);
    const newFrameTime = performance.now();

    if (state.frameNumber % 60 === 0) {
        state.frameRate = 1000 / (newFrameTime - state.lastFrameTime);
    }

    state.lastFrameTime = newFrameTime;
    state.frameNumber++;
    store.update(() => state);
    requestAnimationFrame(tickFrame);
}

export function init() {
    const canvas = document.getElementById('canvas')! as HTMLCanvasElement;

    const ctx = canvas.getContext('2d')!;
    const imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);

    const colours = [
        [255, 0, 0, 0],
        [0, 255, 0],
        [0, 0, 255],
    ];

    for (let i = 0; i < imageData.data.length; i += 4) {
        const [r, g, b] = colours[Math.floor(Math.random() * colours.length)];

        imageData.data[i] = r;
        imageData.data[i + 1] = g;
        imageData.data[i + 2] = b;
        imageData.data[i + 3] = 255;
    }

    ctx.putImageData(imageData, 0, 0);

    canvas.addEventListener('mousedown', (event) => {
        state.mouseDown = true;
        state.mouseX = Math.trunc(event.offsetX / scaleFactor);
        state.mouseY = Math.trunc(event.offsetY / scaleFactor);
    });
    canvas.addEventListener('mouseup', () => {
        state.mouseDown = false;
    });
    canvas.addEventListener('mousemove', (event) => {
        state.mouseX = Math.trunc(event.offsetX / scaleFactor);
        state.mouseY = Math.trunc(event.offsetY / scaleFactor);
    });

    requestAnimationFrame(tickFrame);
}