import { draw_frame } from '@/conjam.mjs';
import { writable } from 'svelte/store';

const scaleFactor = 1;

let state = {
    frameNumber: 0,
    lastFrameTime: performance.now(),
    currentFrameTime: performance.now(),

    mouseDown: false,
    mouseX: 0,
    mouseY: 0,

    brushSize: 10,
    brushColour: '11111111110110001000000011111111',

    autoTick: true,
};
export const store = writable(state);
store.subscribe((value) => {
    state = value;
});

export function tickFrame() {
    draw_frame(
        state.frameNumber,
        state.mouseDown,
        state.mouseX,
        state.mouseY,
        state.brushSize,
        parseInt(state.brushColour, 2),
    );

    store.update((lastState) => ({
        ...lastState,
        lastFrameTime: lastState.currentFrameTime,
        currentFrameTime: performance.now(),
        frameNumber: lastState.frameNumber + 1,
    }));

    if (state.autoTick) {
        requestAnimationFrame(tickFrame);
    }
}

export function init() {
    const canvas = document.getElementById('canvas')! as HTMLCanvasElement;

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
