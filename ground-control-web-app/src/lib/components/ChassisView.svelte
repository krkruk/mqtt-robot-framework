<script lang="ts">
    import ChassisController from './ChassisController.svelte';
    import { publishMqtt } from '$lib/mqtt';

    function handleChassisEvent(event: CustomEvent) {
        const payload = {
            eventType: "chassis",
            payload: event.detail
        };
        publishMqtt('orion/topic/chassis/inbound', payload);
        console.log('Chassis Event:', event.detail);
    }
</script>

<div class="flex flex-col items-center justify-center h-full bg-gray">
    <h1>Chassis Pane Active</h1>
    <ChassisController on:chassisEvent={handleChassisEvent} />
</div>
