import mqtt from 'mqtt';

const brokerAddress = 'mqtt://localhost:1883';
const clientId = `ground-control-web-app-${Math.random().toString(16).slice(2)}`;

const options = {
    clientId,
    username: 'user',
    password: 'user',
    protocolVersion: 5,
    clean: true,
};

let client: mqtt.MqttClient | null = null;

export function connectMqtt() {
    if (client && client.connected) {
        return client;
    }

    client = mqtt.connect(brokerAddress, options);

    client.on('connect', () => {
        console.log('Connected to MQTT broker');
    });

    client.on('error', (error) => {
        console.error('MQTT connection error:', error);
    });

    client.on('close', () => {
        console.log('Disconnected from MQTT broker');
    });

    return client;
}

export function publishMqtt(topic: string, payload: any) {
    if (client && client.connected) {
        client.publish(topic, JSON.stringify(payload), { qos: 0, retain: false });
    } else {
        console.warn('MQTT client not connected. Cannot publish.');
    }
}

export function subscribeMqtt(topic: string, callback: (payload: any) => void) {
    if (client && client.connected) {
        client.subscribe(topic, { qos: 0 }, (err) => {
            if (!err) {
                console.log(`Subscribed to ${topic}`);
            }
        });
        client.on('message', (receivedTopic, message) => {
            if (receivedTopic === topic) {
                try {
                    const payload = JSON.parse(message.toString());
                    callback(payload);
                } catch (e) {
                    console.error('Failed to parse MQTT message:', e);
                }
            }
        });
    } else {
        console.warn('MQTT client not connected. Cannot subscribe.');
    }
}

export function unsubscribeMqtt(topic: string) {
    if (client && client.connected) {
        client.unsubscribe(topic, (err) => {
            if (!err) {
                console.log(`Unsubscribed from ${topic}`);
            }
        });
    }
}
