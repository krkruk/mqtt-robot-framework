# Requirements

## Deployment
Requirement: Build a docker image that corresponds to the Tech Stack:

* Svelte,
* Tailwind CSS
* Gamepad API
* MQTT.js
---

The application is build as a docker image. To build an image run:

```
docker build -t ground-control-web-app .
```

To run the image, execute the following
```
docker run -d --name ground-controll-app --net host ground-control-web-app
```

## UI design
I need you to create a web application that performs the following:
1. Splits vertically the screen in a proportion of 20% for the left pane (called a menu), and the right pane.

2. The menu  is meant to provide 3 buttons: Chassis, Manipulator, Science. 
The behavior for each button shall be provide in section "Button behavior" below. Only one button can be in active state.
3 The right side pane shall be split horizontally in 80% (called a playground pane) to 20% ratio (called a telemetry pane).
4. The playground pane shall display widgets associated with any of the active buttons.
5. The telemetry pane shall display text and widgets associated with the active state.
6. The UI shall support both the PC screen with minimal resolution: 1366 x 768, and a mobile app screens in horizontal. 
If the cell phone is located in vertical position, the application shall ask politely the user to set the device horizontally.
The mobile screen shall accept multi touch.

## Controllers
1. The application shall use UI as a source of MQTT events, including "Reusable widgets" mentioned in section below
2. The application shall use two USB controllers at once: a gamepad (Xbox Wireless Controller) and a joystick (Logitech Extreme 3D Pro)
3. Both the gamepad and the joystick are hot-swappable and always active whenever connected.
4. The USB controllers are prioritized in input, which means whenever these are connected, the input provided by the reusable widgets are ignored.
5. The USB controllers are mapped in a way to correspond the UI widgets. Refer to Business logic section for detailed mapping

## Reusable widgets
This section introduces instructions for development of of reusable widgets.

### Chassis Controller

1. The Chassis Controller is a reusable item that can be invoked in many places in the project.
2. The core of of the widget is a draggable area. It comprises a section of a solid background arranged in a shape of a circle.
On top of the background there is a draggable area (a knob), that a user can swipe up and down, left to right, effectively in any direction.
Whenever the user releases the knob, it automatically returns exactly to the middle of the background. The middle of the widget is considered
a center. The axis left-right is called the X-axis, and up-down is called the Y-axis. Both axes produce events whenever the knob is
dragged a value of a 2D vector in range [-1, 1]. Therefore, whenever the knob is moved, it generates an event with X and Y values.
The event can be subscribed later. The event shall be represented as `"left_stick": [x_value_real, y_value_real]`
3. Around the knob background, there are two arrows facing upwards. They are curved so they match the curvature of the knob. These are 
push buttons. Whenever one is pressed, it remains pressed until the user releases it. If the user presses one, the other one is released.
The buttons generate events: `"rotate": 1` for the left button, and `"rotate": -1` for the right button.
4. At the bottom of the widget there are 4 buttons, namely X, Y, A, B. They will be colored as the one found in the Xbox Controller.
These buttons generate events that correspond to a click (a brief press and release): `"button_x": true|false`,
`"button_y": true|false`, `"button_a": true|false`, `"button_b": true|false`.
5. Whenever any state associated with the widget is triggered, emit all current values within the payload. Therefore there will be
only one event to subscribe to.

## Business Logic
### Chassis active state

The user taps the Chassis button in the menu on the left side pane. It opens the playground side pane 
with the chassis controller widget, and the telemetry pane with in the bottom section. 
The bottom section name shall display a label "Mode: Chassis", and accept inbound traffic 
from an MQTT topic `orion/topic/chassis/outbound`. Once the user leaves from the Chassis mode, unsubscribe from the topic.

The application shall accept input from both a physical gamepad and the UI. The application
shall use the following:

* analog stick (the knob): extract analog values X and Y
* 'X' button': pressed value
* send a JSON-serialized message onto the topic `orion/topic/chassis/inbound`

JSON message:
```
{
  "eventType": "chassis",
  "payload": {
    "stick": [x_value_real, y_value_real],
    "button_x": true|false,
    "button_y": true|false,
    "button_a": true|false,
    "button_b": true|false,
    "rotate": [z_value_real]
  }
}
```

Joystick mapping (Gamepad API):
* axes[0] and axes[1] correspond to `stick` field
* axes[2] corresponds to `rotate` field, applies retrieved analog value
* buttons[0] corresponds to `button_x` field
* buttons[1] corresponds to `button_y` field
* buttons[2] corresponds to `button_a` field
* buttons[3] corresponds to `button_b` field


## Manipulator active state 

Display a label in the playground pane: "Manipulator functionality is not implemented yet"


## Science active state 

Display a label in the playground pane: "Science functionality is not implemented yet"

# MQTT configuration

Broker address: localhost:1883
Protocol version: 5
Client-id: ground-control-web-app-${timestamp}
User: user
Password: user
Serialization format: JSON

