<script lang="ts">
	import '../app.css';
	export const prerender = true;
	import { activeView } from '$lib/store';
	import Menu from '$lib/components/Menu.svelte';
	import ChassisView from '$lib/components/ChassisView.svelte';
	import ManipulatorView from '$lib/components/ManipulatorView.svelte';
	import ScienceView from '$lib/components/ScienceView.svelte';
	import TelemetryPane from '$lib/components/TelemetryPane.svelte';
	import { connectMqtt } from '$lib/mqtt';
	import { startGamepadPolling, stopGamepadPolling } from '$lib/gamepad';
	import { onMount, onDestroy } from 'svelte';

	let mqttClient: any;

	onMount(() => {
		mqttClient = connectMqtt();
		startGamepadPolling();
	});

	onDestroy(() => {
		if (mqttClient) {
			mqttClient.end();
		}
		stopGamepadPolling();
	});
</script>

<div class="relative flex h-screen overflow-hidden">
	<!-- Menu Pane (always visible) -->
	<div style="width: 20%; background-color: var(--color-gray);">
		<Menu />
	</div>

	<!-- Main Content -->
	<div class="flex flex-col flex-1" style="width: 80%;">
		<div class="p-4" style="height: 80%; background-color: var(--color-gray);">
			{#if $activeView === 'Chassis'}
				<ChassisView />
			{:else if $activeView === 'Manipulator'}
				<ManipulatorView />
			{:else if $activeView === 'Science'}
				<ScienceView />
			{/if}
		</div>
		<TelemetryPane class="bg-gray" style="height: 20%;"/>
	</div>
</div>