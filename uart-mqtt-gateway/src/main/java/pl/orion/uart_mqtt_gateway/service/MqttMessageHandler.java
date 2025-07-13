package pl.orion.uart_mqtt_gateway.service;

public interface MqttMessageHandler {
    void handleMessage(String topic, String payload);
}