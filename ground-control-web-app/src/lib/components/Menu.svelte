<script lang="ts">
	import { activeView } from '$lib/store';
	import { onMount, onDestroy } from 'svelte';

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

	$: buttonSize = Math.max(25, windowWidth * 0.05); // 5% of window width, min 25px
</script>

<div class="flex flex-col h-full bg-gray text-white p-4">
	<button
		on:click={() => activeView.set('Chassis')}
		class="p-2 my-2 rounded { $activeView === 'Chassis' ? 'bg-orange' : 'bg-black' }"
		style="width: {buttonSize}px; height: {buttonSize}px;"
		title="Chassis"
	>
		<img src="static/icons/chassis.svg" alt="Chassis" class="w-50px h-50px mx-auto">
	</button>
	<button
		on:click={() => activeView.set('Manipulator')}
		class="p-2 my-2 rounded { $activeView === 'Manipulator' ? 'bg-orange' : 'bg-black' }"
		style="width: {buttonSize}px; height: {buttonSize}px;"
		title="Manipulator"
	>
		<img src="static/icons/manipulator.svg" alt="Manipulator" class="w-50px h-50px mx-auto">
	</button>
	<button
		on:click={() => activeView.set('Science')}
		class="p-2 my-2 rounded { $activeView === 'Science' ? 'bg-orange' : 'bg-black' }"
		style="width: {buttonSize}px; height: {buttonSize}px;"
		title="Science"
	>
		<img src="static/icons/science.svg" alt="Science" class="w-50px h-50px mx-auto">
	</button>
</div>