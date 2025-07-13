package pl.orion.uart_mqtt_gateway.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;

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
        private String brokerUrl;
        private int brokerPort;
        private String clientId;
        private int connectionTimeoutS;
        private int keepAliveIntervalS;
        private int reconnectDelayMs;
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