# uart-mqtt-gateway

`uart-mqtt-gateway` service translates UART full-duplex communication into
MQTT-driven events. In that way, any onboard device shall be connected to TCP/IP stack
and therefore be controllable remotely.

[System level component diagram](../uml/c4model/01_system_level/020_system_rover_software_component_diagram.puml)

The service is meant to be a part of a bigger picture project that designs and builds a Mars rover
to compete in European Rover Challange. The robot comprises several microcontrollers that
control chassis and driving model, manipulator and inverse kinematics, science experiments
and monitor power usage and li-ion battery management.

Each microcontroller shall be connected to a PC (x64) with a UART-USB converter. The `uart-mqtt-gateway`
service shall route communication inbounds and outbounds. The application shall accept
incoming UART traffic and convert the messages into MQTT messages. Similarly, the service shall
deliver MQTT messages into corresponding UART devices. In that way, the application provides:
* full-duplex comunication
* a universal interface to implement higher level logic (i.e., inverse kinematics, traversal planning,
mission scripting etc.)

The service is the key to integrate individual components into a single robotic platform.

## Functionalities

* **Hot-swappable UART connectivity**: Connect/disconnect your device on-the-fly.
* **Automatic message routing**: Route messages onto corresponding MQTT topics, configurable mapping
* **Accept inbound messages**: Read inbound MQTT messages and redirect into corresponding UART devices

## Architecture

The service leverages Java multithreading capabilities:
* Any newly detected shall spin up a new thread
* Any freshly removed device shall be safely removed from resources and MQTT messages will not be processed
* The service shall periodically (1s by default, configurable), check for new devices
* The service shall rely on a universally acknowledged JSON schema to map a device onto corresponding MQTT topics, as presented below
* The service shall publish any errors onto MQTT error topic to notify a human operator
* The service shall not interfere with the payload. It shall read only one predefined 
field (`eventType`, by default) to match configuration and corresponding MQTT topics
* The configuration shall be specfied in a separate file: `uart-mqtt-mapping.yml`
* The application shall be launched at port 8088 by default (see yaml configuration)

[Sequence diagram](../uml/c4model/02_container_level/020_container_rover_software_sequence_diagram_chassis_firmware.puml)

### JSON schema
```
{
 "eventType": "(power|manipulator|chassis|science)",
 "payload": {
   "value1": "",
   [...]
 }
}
```

Legend (mandatory fields):
* `eventType` - a device unique identifier. A single label shall be associated with only one UART device

### `uart-mqtt-mapping.yml`
```
uuart-mqtt-gateway:
  error-topic: orion/topic/error

  mqtt:
      broker-url: localhost
      broker-port: 1883
      client-id: uart-mqtt-gateway
      connection-timeout-s: 5
      keep-alive-interval-s: 60
      reconnect-delay-ms: 5000

  serial:
      scan-interval-ms: 1000
      delimiter: "\n\n"
      allowed-port-name-prefixes: 
        - /dev/ttyUSB
        - /dev/ttyACM
      baud-rate: 115200
      data-bits: 8
      stop-bits: 1
      parity-bit: 0
      read-timeout-ms: 100
      write-timeout-ms: 100

  uart-mqtt-mapping:
      - label: chassis-microcontroller
        eventType: chassis
        mqtt:
          inbound: orion/topic/chassis/inbound
          outbound: orion/topic/chassis/outbound
      - label: manipulator-microcontroller
        eventType: manipulator
        mqtt:
          inbound: orion/topic/manipulator/inbound
          outbound: orion/topic/manipulator/outbound
      - label: power-microcontroller
        eventType: power
        mqtt:
          inbound: orion/topic/power/inbound
          outbound: orion/topic/power/outbound
      - label: science-microcontroller
        eventType: science
        mqtt:
          inbound: orion/topic/science/inbound
          outbound: orion/topic/science/outbound

```


## Tech stack

* Java 21
* jSerialComm
* MQTT (hivemq-mqtt-client)
* Spring Boot
* Gradle (gradle-wrapper)
* Docker

## Launch

Assign the correct user group to access serial port:
```
sudo usermod -a -G dialout $USER
```

Launch MQTT server locally:
```
docker run -it --net host eclipse-mosquitto
```

Assuming the default configuration is sufficient, simply run:
```
./gradlew bootRun
```

Alternatively, you can launch the application with Docker:
```/usr/bin/env bash
docker build -t uart-mqtt-gateway .
```

To run the Docker container with access to serial ports:
```/usr/bin/env bash
docker run -d --privileged -v /dev:/dev uart-mqtt-gateway
