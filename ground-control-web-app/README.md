# Ground Control Web App

This is a web application designed to control a rover, featuring a modular UI, real-time telemetry, and support for various input methods.

## Features

*   **Modular UI:** Vertical split layout with a collapsible menu, playground, and telemetry panes.
*   **Chassis Controller:** Interactive draggable knob for movement control, with rotation and action buttons.
*   **MQTT Integration:** Real-time communication for sending commands and receiving telemetry data.
*   **Gamepad API Support:** Prioritized input from USB gamepads (Xbox Wireless Controller) and joysticks (Logitech Extreme 3D Pro).
*   **Responsive Design:** Supports PC screens and mobile devices (landscape orientation enforced).
*   **Dockerized Deployment:** Application can be built and run as a Docker image.

## Tech Stack

*   [SvelteKit](https://kit.svelte.dev/): Web framework
*   [Tailwind CSS](https://tailwindcss.com/): Utility-first CSS framework
*   [Gamepad API](https://developer.mozilla.org/en-US/docs/Web/API/Gamepad_API): For USB controller input
*   [MQTT.js](https://mqttjs.com/): MQTT client for browser and Node.js
*   [Docker](https://www.docker.com/): Containerization platform

## Setup

To get the project up and running locally, follow these steps:

1.  **Clone the repository:**
    ```bash
    git clone <repository-url>
    cd ground-control-web-app
    ```

2.  **Install dependencies:**
    ```bash
    npm install
    ```

3.  **Download Icons (Manual Step):**
    The application uses custom SVG icons for the menu. Please download the following icons and place them in the `static/icons/` directory:
    *   Chassis: [https://uxwing.com/wp-content/themes/uxwing/download/transportation-automotive/car-tire-wheel-icon.png](https://uxwing.com/wp-content/themes/uxwing/download/transportation-automotive/car-tire-wheel-icon.png) (Rename to `chassis.svg`)
    *   Manipulator: [https://uxwing.com/wp-content/themes/uxwing/download/business-professional-services/mechanical-arm-icon.png](https://uxwing.com/wp-content/themes/uxwing/download/business-professional-services/mechanical-arm-icon.png) (Rename to `manipulator.svg`)
    *   Science: [https://uxwing.com/wp-content/themes/uxwing/download/medical-science-lab/flask-icon.png](https://uxwing.com/wp-content/themes/uxwing/download/medical-science-lab/flask-icon.png) (Rename to `science.svg`)

    *Note: Ensure the downloaded files are converted to SVG format if they are PNGs, and named correctly.* For example, you can use an online converter or a graphics editor.

## Running the Application

### Development Mode

To run the application in development mode:

```bash
npm run dev
```

The application will be accessible at `http://localhost:8080`.

### Docker

To build and run the application using Docker:

1.  **Build the Docker image:**
    ```bash
    docker build -t ground-control-web-app .
    ```

2.  **Run the Docker container:**
    ```bash
    docker run -d --name ground-control-app --net host ground-control-web-app
    ```

    The application will be accessible via your host machine's network, typically at `http://localhost:8080`.

## Usage

*   **Menu:** Use the buttons on the left-hand side (Chassis, Manipulator, Science) to switch between different control modes.
*   **Chassis Controller:** When in Chassis mode, use the draggable knob to control movement. The rotation buttons and Xbox-style buttons (X, Y, A, B) provide additional controls.
*   **Telemetry Pane:** The bottom right pane displays real-time telemetry data when in Chassis mode.

## Color Palette

The application uses a custom color palette:
*   Orange: `#FFA500`
*   Black: `#000000`
*   Gray: `#808080`
*   White: `#FFFFFF`

## Theme

This project integrates components and styling from the Crypgo theme. The `tailwind.config.js` has been updated to include its extended theme properties.