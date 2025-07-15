<script lang="ts">
    import { createEventDispatcher, onMount, onDestroy } from 'svelte';

    const dispatch = createEventDispatcher();

    let knobX = 0;
    let knobY = 0;
    let isDragging = false;
    let container: HTMLElement;
    let containerRect: DOMRect;

    let rotateValue = 0;
    let buttonX = false;
    let buttonY = false;
    let buttonA = false;
    let buttonB = false;

    let windowWidth = 0;

    onMount(() => {
        if (typeof window !== 'undefined') {
            windowWidth = window.innerWidth;
            window.addEventListener('resize', () => {
                windowWidth = window.innerWidth;
            });
        }
    });

    onDestroy(() => {
        if (typeof window !== 'undefined') {
            window.removeEventListener('resize', () => {
                windowWidth = window.innerWidth;
            });
        }
    });

    $: containerSize = windowWidth * 0.20; // 20% of window width
    $: knobSize = windowWidth * 0.05; // 5% of window width
    $: knobTranslateFactor = (containerSize / 2) - (knobSize / 2); // Max translation for knob

    function updatePayload() {
        const payload = {
            stick: [knobX, knobY],
            button_x: buttonX,
            button_y: buttonY,
            button_a: buttonA,
            button_b: buttonB,
            rotate: rotateValue
        };
        dispatch('chassisEvent', payload);
    }

    function startDrag(event: MouseEvent | TouchEvent) {
        console.log('Drag started', event.type);
        isDragging = true;
        containerRect = container.getBoundingClientRect();
        if (typeof document !== 'undefined') {
            document.addEventListener('mousemove', drag);
            document.addEventListener('mouseup', stopDrag);
            document.addEventListener('touchmove', drag);
            document.addEventListener('touchend', stopDrag);
        }
    }

    function drag(event: MouseEvent | TouchEvent) {
        if (!isDragging) return;

        let clientX, clientY;
        if (event instanceof MouseEvent) {
            clientX = event.clientX;
            clientY = event.clientY;
        } else {
            clientX = event.touches[0].clientX;
            clientY = event.touches[0].clientY;
        }

        const centerX = containerRect.left + containerRect.width / 2;
        const centerY = containerRect.top + containerRect.height / 2;
        const radius = containerRect.width / 2;

        let newX = clientX - centerX;
        let newY = clientY - centerY;

        const distance = Math.sqrt(newX * newX + newY * newY);

        if (distance > radius) {
            const angle = Math.atan2(newY, newX);
            newX = radius * Math.cos(angle);
            newY = radius * Math.sin(angle);
        }

        knobX = parseFloat((newX / radius).toFixed(2));
        knobY = parseFloat((-newY / radius).toFixed(2)); // Y-axis inverted for UI
        updatePayload();
    }

    function stopDrag() {
        console.log('Drag stopped');
        isDragging = false;
        knobX = 0;
        knobY = 0;
        updatePayload();
        if (typeof document !== 'undefined') {
            document.removeEventListener('mousemove', drag);
            document.removeEventListener('mouseup', stopDrag);
            document.removeEventListener('touchmove', drag);
            document.removeEventListener('touchend', stopDrag);
        }
    }

    function handleRotate(value: number) {
        console.log('Rotate button pressed', value);
        rotateValue = value;
        updatePayload();
    }

    function handleButton(button: string, pressed: boolean) {
        console.log(`Button ${button} ${pressed ? 'pressed' : 'released'}`);
        if (button === 'X') buttonX = pressed;
        if (button === 'Y') buttonY = pressed;
        if (button === 'A') buttonA = pressed;
        if (button === 'B') buttonB = pressed;
        updatePayload();
    }
</script>

<div class="flex flex-col items-center justify-center h-full p-4">
    <div bind:this={container} class="relative rounded-full bg-black flex items-center justify-center border-2 border-white"
         style="width: {containerSize}px; height: {containerSize}px;"
         on:mousedown={startDrag} on:touchstart={startDrag}>
        <div class="absolute rounded-full bg-orange cursor-grab border-2 border-orange-800 shadow-lg"
             style="width: {knobSize}px; height: {knobSize}px; transform: translate({knobX * knobTranslateFactor}px, {-knobY * knobTranslateFactor}px);">
        </div>
    </div>

    <!-- Rotation Arrows -->
    <div class="flex mt-4 space-x-8">
        <button class="w-12 h-12 rounded-full bg-gray flex items-center justify-center"
                on:mousedown={() => handleRotate(-1)} on:mouseup={() => handleRotate(0)} on:mouseleave={() => handleRotate(0)}
                on:touchstart={() => handleRotate(-1)} on:touchend={() => handleRotate(0)}>
            <span class="text-white text-2xl">&#x21B1;</span>
        </button>
        <button class="w-12 h-12 rounded-full bg-gray flex items-center justify-center"
                on:mousedown={() => handleRotate(1)} on:mouseup={() => handleRotate(0)} on:mouseleave={() => handleRotate(0)}
                on:touchstart={() => handleRotate(1)} on:touchend={() => handleRotate(0)}>
            <span class="text-white text-2xl">&#x21B0;</span>
        </button>
    </div>

    <!-- Xbox Buttons -->
    <div class="flex mt-8 space-x-4">
        <button class="w-16 h-16 rounded-full bg-orange text-white text-xl font-bold"
                on:mousedown={() => handleButton('X', true)} on:mouseup={() => handleButton('X', false)} on:mouseleave={() => handleButton('X', false)}
                on:touchstart={() => handleButton('X', true)} on:touchend={() => handleButton('X', false)}>
            X
        </button>
        <button class="w-16 h-16 rounded-full bg-gray text-white text-xl font-bold"
                on:mousedown={() => handleButton('Y', true)} on:mouseup={() => handleButton('Y', false)} on:mouseleave={() => handleButton('Y', false)}
                on:touchstart={() => handleButton('Y', true)} on:touchend={() => handleButton('Y', false)}>
            Y
        </button>
        <button class="w-16 h-16 rounded-full bg-orange text-white text-xl font-bold"
                on:mousedown={() => handleButton('A', true)} on:mouseup={() => handleButton('A', false)} on:mouseleave={() => handleButton('A', false)}
                on:touchstart={() => handleButton('A', true)} on:touchend={() => handleButton('A', false)}>
            A
        </button>
        <button class="w-16 h-16 rounded-full bg-gray text-white text-xl font-bold"
                on:mousedown={() => handleButton('B', true)} on:mouseup={() => handleButton('B', false)} on:mouseleave={() => handleButton('B', false)}
                on:touchstart={() => handleButton('B', true)} on:touchend={() => handleButton('B', false)}>
            B
        </button>
    </div>
</div>
