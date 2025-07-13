package pl.orion.uart_mqtt_gateway.service;

public interface MqttService {
    void connect();
    void disconnect();
    void publish(String topic, String payload);
    void subscribe(String topic, MqttMessageHandler handler);
    void unsubscribe(String topic);
}