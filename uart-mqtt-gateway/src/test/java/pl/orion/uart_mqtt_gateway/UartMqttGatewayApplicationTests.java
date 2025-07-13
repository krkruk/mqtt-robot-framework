package pl.orion.uart_mqtt_gateway;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import pl.orion.uart_mqtt_gateway.service.DeviceManagerService;
import pl.orion.uart_mqtt_gateway.service.MqttService;

@SpringBootTest
class UartMqttGatewayApplicationTests {

	@MockBean
	private DeviceManagerService deviceManagerService;

	@MockBean
	private MqttService mqttService;

	@Test
	void contextLoads() {
	}

}
