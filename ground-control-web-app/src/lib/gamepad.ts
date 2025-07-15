import { publishMqtt } from '$lib/mqtt';

let gamepadInterval: number | null = null;
let connectedGamepads: Gamepad[] = [];

const GAMEPAD_MAPPING = {
    axes: {
        stick_x: 0,
        stick_y: 1,
        rotate: 2,
    },
    buttons: {
        button_x: 0,
        button_y: 1,
        button_a: 2,
        button_b: 3,
    }
};

function pollGamepads() {
    const gamepads = navigator.getGamepads ? navigator.getGamepads() : [];
    connectedGamepads = [];

    for (let i = 0; i < gamepads.length; i++) {
        const gamepad = gamepads[i];
        if (gamepad) {
            connectedGamepads.push(gamepad);
            processGamepadInput(gamepad);
        }
    }
}

function processGamepadInput(gamepad: Gamepad) {
    const payload = {
        eventType: "chassis",
        payload: {
            stick: [
                parseFloat(gamepad.axes[GAMEPAD_MAPPING.axes.stick_x].toFixed(2)),
                parseFloat(gamepad.axes[GAMEPAD_MAPPING.axes.stick_y].toFixed(2))
            ],
            button_x: gamepad.buttons[GAMEPAD_MAPPING.buttons.button_x].pressed,
            button_y: gamepad.buttons[GAMEPAD_MAPPING.buttons.button_y].pressed,
            button_a: gamepad.buttons[GAMEPAD_MAPPING.buttons.button_a].pressed,
            button_b: gamepad.buttons[GAMEPAD_MAPPING.buttons.button_b].pressed,
            rotate: parseFloat(gamepad.axes[GAMEPAD_MAPPING.axes.rotate].toFixed(2))
        }
    };
    publishMqtt('orion/topic/chassis/inbound', payload);
}

export function startGamepadPolling() {
    if (gamepadInterval === null) {
        gamepadInterval = window.setInterval(pollGamepads, 100);
        console.log('Gamepad polling started.');
    }
}

export function stopGamepadPolling() {
    if (typeof window !== 'undefined' && gamepadInterval !== null) {
        window.clearInterval(gamepadInterval);
        gamepadInterval = null;
        console.log('Gamepad polling stopped.');
    }
}

export function isGamepadConnected(): boolean {
    return connectedGamepads.length > 0;
}
