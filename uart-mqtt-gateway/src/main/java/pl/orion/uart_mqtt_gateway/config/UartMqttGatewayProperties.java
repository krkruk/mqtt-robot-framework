package pl.orion.uart_mqtt_gateway.config;

import lombok.Data;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.context.properties.bind.Name;

import java.util.List;


@ConfigurationProperties(prefix = "uart-mqtt-gateway")
@Data
public class UartMqttGatewayProperties {
    private String errorTopic;

    private Mqtt mqtt;
    private Serial serial;
    private List<UartMqttMapping> uartMqttMapping;

    @Data
    public static class Mqtt {
        private String clientId;

        @Name("broker.url")
        private String brokerUrl;

        @Name("broker.port")
        private int brokerPort;

        @Name("broker.username")
        private String brokerUsername;

        @Name("broker.password")
        private String brokerPassword;

        @Name("connection.timeout.ms")
        private long connectionTimeoutMs;

        @Name("connection.keepalive.ms")
        private long connectionKeepaliveMs;

        @Name("connection.reconnect.delay.ms")
        private long connectionReconnectDelayMs;
    }

    @Data
    public static class Serial {
        private int scanIntervalMs;
        private List<String> allowedPortNamePrefixes;
        private int baudRate;
        private int dataBits;
        private int stopBits;
        private int parityBit;
        private int readTimeoutMs;
        private int writeTimeoutMs;
        private int bufferSize;
        private String delimiter;
    }

    @Data
    public static class UartMqttMapping {
        private String label;
        private String eventType;
        private MqttMapping mqtt;

        @Data
        public static class MqttMapping {
            private String inbound;
            private String outbound;
        }
    }
}