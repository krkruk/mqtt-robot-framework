<script lang="ts">
    import { activeView } from '$lib/store';
    import { subscribeMqtt, unsubscribeMqtt } from '$lib/mqtt';
    import { onDestroy } from 'svelte';

    let telemetryData: any = {};
    let currentMode: string = '';

    $: {
        if ($activeView === 'Chassis') {
            currentMode = 'Chassis';
            subscribeMqtt('orion/topic/chassis/outbound', (payload) => {
                telemetryData = payload;
            });
        } else {
            unsubscribeMqtt('orion/topic/chassis/outbound');
            currentMode = '';
            telemetryData = {};
        }
    }

    onDestroy(() => {
        unsubscribeMqtt('orion/topic/chassis/outbound');
    });
</script>

<div class="h-full bg-gray p-4">
    {#if currentMode}
        <p>Mode: {currentMode}</p>
    {/if}
    {#if Object.keys(telemetryData).length > 0}
        <pre>{JSON.stringify(telemetryData, null, 2)}</pre>
    {/if}
</div>
