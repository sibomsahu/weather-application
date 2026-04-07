🌩️ Neo-Brutalist WeatherApp (Java Servlet + JSP)
A full-stack weather dashboard that breaks away from boring corporate designs. Built with a Java Servlet backend and a heavily stylized Neo-Brutalist frontend, this app delivers real-time weather data and 5-day forecasts using the OpenWeatherMap API.

It leverages pure CSS animations, heavy borders, and high-contrast color palettes to create a unique UI, while maintaining a robust Java backend that handles API communication, data transformation, and JSON serialization.

✨ Key Features
Neo-Brutalist Aesthetic: Custom UI featuring harsh borders (brutal-border), static and interactive hard shadows (brutal-shadow), and a vibrant color palette (Lime green, Cyber-pink, and Warning yellow) layered over a transparent crosshatch texture.

Smart Geolocation: Uses the browser's native Geolocation API to fetch precise latitude/longitude coordinates, sending a custom COORDS: flag to the backend for hyper-accurate local weather.

Interactive Data Visualization: Integrates Chart.js to render a responsive, styled 5-day temperature trend line graph that matches the brutalist aesthetic (thick borders, high-contrast points).

Custom Animations: Features custom CSS @keyframes for smooth tab switching (fadeIn), floating weather icons (animate-float), and dynamic loading spinners.

Robust Backend Parsing: The WeatherServlet acts as a secure API gateway. It safely encodes URL parameters, handles HTTP connection errors, and maps messy OpenWeather API JSON into clean, UI-ready frontend DTOs using Gson.

Localization Safe: Explicitly enforces Locale.ENGLISH on UNIX timestamp conversions to prevent unexpected date formatting errors on localized operating systems.

🛠️ Tech Stack
Backend:

Java (Jakarta EE): Uses jakarta.servlet.* (Requires Tomcat 10 or newer).

Gson (Google): For serializing Java Maps/Lists into clean JSON responses.

OpenWeatherMap API: Data provider for current weather and 5-day/3-hour forecast endpoints.

Frontend:

JSP (JavaServer Pages): Acts as the HTML container.

Tailwind CSS (via CDN): For rapid utility-class layout structuring.

Vanilla JavaScript: Handles async fetch() calls, DOM updates, and Chart.js rendering.

Chart.js: For the temperature trend visualization.

Google Fonts: Space Grotesk for that blocky, technical typography.

📂 Project Structure
Plaintext
WeatherApp/
│
├── src/main/java/
│   └── com.weather/
│       └── WeatherServlet.java     # The main API controller & JSON mapper
│
├── src/main/webapp/
│   ├── index.jsp                   # Main application view
│   ├── style.css                   # Custom brutalist styles & keyframes
│   └── WEB-INF/
│       └── lib/
│           └── gson.jar            # JSON dependency
🚀 Setup & Installation
Because this application uses the modern jakarta.* namespace, you must use Apache Tomcat 10 or higher. Older versions of Tomcat (v9 and below) still use the deprecated javax.* namespace and will fail to compile.

Clone the repository:

Bash
git clone https://github.com/sibomsahu/weather-application.git
cd weather-application
Add your API Key:

Open src/main/java/com/weather/WeatherServlet.java.

Locate line 26:

Java
private static final String API_KEY = "YOUR_OPENWEATHERMAP_API_KEY";
Replace the placeholder with your actual OpenWeatherMap API key.

Deploy to your Server:

If using an IDE like IntelliJ IDEA or Eclipse, configure a Tomcat 10+ server.

Ensure gson.jar is properly added to your Project Structure/Build Path under WEB-INF/lib.

Build the artifact and deploy.

Run the App:

Navigate to http://localhost:8080/WeatherApp/ (or your configured application context path).

🧠 How the API Flow Works
Rather than exposing the OpenWeatherMap API key to the client browser, this app uses a secure backend-for-frontend (BFF) pattern:

Client Request: The user types a city or clicks "Auto Detect Location". The JS fetch() calls /api/weather?city=Name (or /api/weather?city=COORDS:lat,lon).

Servlet Intercept: WeatherServlet.java captures the GET request. It checks if the input is a city string or exact coordinates.

Upstream Fetch: The Java backend makes an HttpURLConnection to OpenWeatherMap's servers, utilizing the hidden API key.

Data Transformation: The raw, heavy JSON from OpenWeatherMap is parsed by Gson. The mapRealData() method extracts only the data needed by the UI, calculates averages, formats dates, and determines the correct emojis.

Client Render: The lightweight, formatted JSON is sent back to index.jsp where JavaScript updates the DOM and redraws the Chart.js canvas.
