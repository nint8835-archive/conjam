import { draw_frame } from '@/conjam.mjs';
import { writable } from 'svelte/store';

const scaleFactor = 1;

const state = {
    lastFrameTime: performance.now(),
    currentFrameTime: performance.now(),

    mouseDown: false,
    mouseX: 0,
    mouseY: 0,
};
export const store = writable(state);

const settings = {
    brushSize: 10,
    brushColour: '#ff0000',

    autoTick: true,
};
export const settingsStore = writable(settings);

export function tickFrame() {
    draw_frame(
        state.mouseDown,
        state.mouseX,
        state.mouseY,
        settings.brushSize,
        (parseInt(settings.brushColour.substring(1), 16) << 8) | 0xff,
    );
    state.currentFrameTime = performance.now();
    store.update(() => ({ ...state }));
    state.lastFrameTime = state.currentFrameTime;

    if (settings.autoTick) {
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
