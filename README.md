# 🌩️ Neo-Brutalist WeatherApp: Java Servlet Edition

A highly stylized, full-stack weather dashboard that completely reimagines the traditional Java web application. By combining the robust, battle-tested backend architecture of Jakarta Servlets with a loud, unapologetic Neo-Brutalist frontend, this application delivers real-time meteorological data and 5-day forecasting without compromising on visual identity.

This project intentionally breaks away from sterile corporate UI trends, utilizing harsh structural borders, high-contrast palettes, and pure CSS keyframe animations, all while executing secure, server-side REST API communications through a bespoke Java controller.

-----

## ✨ Core Features & Technical Highlights

  * **Unapologetic Neo-Brutalist UI/UX:** \* Features a custom user interface defined by thick `brutal-border` classes, heavy static and hover-responsive drop shadows (`brutal-shadow`), and a vibrant color scheme (Lime green `#00FF85`, Cyber-pink `#ff90e8`, and Warning yellow `#ffc900`).
      * The background utilizes a transparent crosshatch texture to enhance the mechanical, raw aesthetic of the brutalist design language.
  * **Smart Geolocation & Precision Routing:** \* Integrates the browser's native HTML5 Geolocation API to instantly fetch precise latitude and longitude coordinates.
      * Bypasses standard city-string searches by dispatching a custom `COORDS:lat,lon` payload to the backend, ensuring hyper-accurate, hyper-local weather retrieval directly from OpenWeatherMap's coordinate endpoints.
  * **Interactive Data Visualization (Chart.js):** \* Implements a responsive, 5-day temperature trend line graph.
      * The chart is heavily customized to match the brutalist theme, featuring thick 4px border widths, high-contrast data points, and customized Space Grotesk typography on the axes.
  * **Performant CSS Animation Engine:** \* Utilizes custom `@keyframes` for frictionless UI transitions, including smooth tab switching (`fadeIn`), organic floating weather icons (`animate-float`), and dynamic loading state spinners.
  * **Robust Backend JSON Parsing (BFF Pattern):** \* The `WeatherServlet` acts as a Backend-For-Frontend secure gateway. It completely shields the OpenWeatherMap API key from the client browser.
      * Leverages Google's **Gson** library to intercept, parse, and heavily prune the massive payload returned by OpenWeatherMap, serializing only the strict necessary data points into a clean, lightweight DTO (Data Transfer Object) for the frontend to digest.
  * **Cross-Regional Safe Formatting:** \* Explicitly enforces `Locale.ENGLISH` on all UNIX timestamp conversions (`java.util.Date`) within the backend logic. This prevents fatal UI rendering errors that can occur when the host operating system attempts to translate day strings (like "Mon" or "Tue") into localized regional languages.

-----

## 🏗️ Technical Architecture

This application strictly adheres to the separation of concerns, ensuring the frontend remains dumb and reactive while the backend handles all heavy computational logic and external HTTP routing.

**The Backend (Controller & Service Layers):**

  * **Java (Jakarta EE):** Runs on the modern `jakarta.servlet.*` specification.
  * **Gson 2.x:** Handles complex JSON deserialization from the external API and serialization for the client response.
  * **HttpURLConnection:** Native Java networking for secure, dependency-free external API calls.

**The Frontend (View Layer):**

  * **JSP (JavaServer Pages):** Acts as the primary HTML scaffolding and initial view renderer.
  * **Tailwind CSS (CDN):** Rapid utility-class injection for the complex grid and flexbox layouts required by the dashboard.
  * **Vanilla JavaScript (ES6+):** Manages asynchronous `fetch()` promises, DOM manipulation, error boundary handling, and Chart.js instantiation.
  * **Google Fonts:** `Space Grotesk` drives the blocky, technical typography essential to the aesthetic.

-----

## 📂 Deep Directory Structure

```text
weather-application/
│
├── src/main/java/
│   └── com.weather/
│       └── WeatherServlet.java     # Primary API controller; handles routing, fetching, and JSON mapping
│
├── src/main/webapp/
│   ├── index.jsp                   # Main application view & JavaScript logic container
│   ├── style.css                   # Custom brutalist classes, textures, and keyframe animations
│   └── WEB-INF/
│       ├── web.xml                 # Deployment descriptor (if not using annotations exclusively)
│       └── lib/
│           └── gson.jar            # Required Google Gson dependency for JSON processing
│
├── .gitignore
└── README.md
```

-----

## 🔄 The API Lifecycle Flow

Understanding the data pipeline from user click to DOM update:

1.  **The Trigger:** The user submits a city name via the datalist input or clicks the "📍" auto-detect button.
2.  **The Request:** Vanilla JS intercepts the event, hides the dashboard, reveals the loading spinner, and dispatches a `GET` fetch request to `/api/weather?city=[ENCODED_INPUT]`.
3.  **The Intercept:** Tomcat routes the request to `WeatherServlet.java`. The servlet evaluates if the payload is a standard string or a `COORDS:` flag.
4.  **The Fetch:** The servlet securely appends the hidden `API_KEY` and executes a server-to-server HTTP request to the OpenWeatherMap `2.5/weather` and `2.5/forecast` endpoints.
5.  **The Transformation:** Raw JSON is streamed into a `StringBuilder`, mapped via `fetchJsonFromApi()`, and then rigorously pruned in `mapRealData()`. Temperatures are mathematically rounded, wind speeds converted to km/h, and UNIX timestamps converted to human-readable days.
6.  **The Handshake:** A single, optimized JSON object is flushed to the `HttpServletResponse` `PrintWriter`.
7.  **The Render:** The frontend resolves the promise, hides the loader, iterates through the forecast arrays to build the DOM cards dynamically, and redraws the Chart.js canvas with the new data.

-----

## 🚀 Setup & Installation Guide

Because this application utilizes the modern Jakarta namespace, **you must deploy it on Apache Tomcat 10.0 or higher**. Legacy versions of Tomcat (v9 and below) rely on the deprecated `javax.*` namespace and will trigger severe compilation failures.

### 1\. Clone the Repository

```bash
git clone https://github.com/sibomsahu/weather-application.git
cd weather-application
```

### 2\. Configure Your API Key

  * Navigate to `src/main/java/com/weather/WeatherServlet.java`.
  * Locate the static constant on line 26:
    ```java
    private static final String API_KEY = "YOUR_OPENWEATHERMAP_API_KEY";
    ```
  * Replace the placeholder string with your active OpenWeatherMap API key.

### 3\. Dependency Management

  * Verify that `gson.jar` is physically present in the `src/main/webapp/WEB-INF/lib/` directory.
  * If you are utilizing an IDE such as IntelliJ IDEA or Eclipse Enterprise, ensure this `lib` folder is explicitly added to your Project Structure's Build Path/Artifact configuration.

### 4\. Build and Deploy

  * Configure a local **Tomcat 10+** server instance within your IDE.
  * Build the exploded WAR artifact and deploy it to the server context.
  * Launch the server and navigate your browser to `http://localhost:8080/WeatherApp/` (adjust the port and context path according to your specific server configuration).

-----

## 🔮 Future Roadmap

  * **Server-Side Caching:** Implement a temporary `HashMap` cache or integrate Redis to store forecast data for highly searched cities for 10-15 minutes, drastically reducing external API calls and latency.
  * **Progressive Web App (PWA):** Generate a `manifest.json` and register a service worker to allow users to install the dashboard locally and cache the static Neo-Brutalist assets for offline shell rendering.
  * **Dynamic Theming:** Transition the hardcoded hex values into CSS variables, allowing the backend to serve different brutalist color palettes based on the actual weather conditions (e.g., stark monochrome for rain, hyper-saturated neon for clear skies).

-----

-----

\<div align="center"\>
<br>
\<b\>Crafted & Developed by\</b\>
\<h2\>Sibom Sahu\</h2\>
\<i\>4th-Year IT Student & Full-Stack Developer\</i\>
<br><br>
\<code\>System Architecture\</code\> • \<code\>Creative Web Design\</code\> • \<code\>Java Enterprise\</code\>
\</div\>
