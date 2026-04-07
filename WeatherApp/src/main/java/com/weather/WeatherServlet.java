package com.weather;

import java.io.IOException;

import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Scanner;
import java.util.Locale;

// IMPORTANT: Tomcat 10+ requires jakarta.* instead of javax.*
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

@WebServlet("/api/weather")
public class WeatherServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // 🔥 INSERT YOUR OPENWEATHERMAP API KEY HERE 🔥
    private static final String API_KEY = "";

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String city = request.getParameter("city");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();

        if (city == null || city.trim().isEmpty() || city.equalsIgnoreCase("errorcity")) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\": \"City not found\"}");
            out.flush();
            return;
        }

        try {
            String currentUrl;
            String forecastUrl;

            // Check if the frontend sent LAT/LON coordinates instead of a city name
            if (city.startsWith("COORDS:")) {
                String[] coords = city.substring(7).split(",");
                String lat = coords[0];
                String lon = coords[1];
                currentUrl = "https://api.openweathermap.org/data/2.5/weather?lat=" + lat + "&lon=" + lon + "&appid=" + API_KEY + "&units=metric";
                forecastUrl = "https://api.openweathermap.org/data/2.5/forecast?lat=" + lat + "&lon=" + lon + "&appid=" + API_KEY + "&units=metric";
            } else {
                // Encode city name for URL (handles spaces and special characters safely)
                String encodedCity = URLEncoder.encode(city, "UTF-8");
                currentUrl = "https://api.openweathermap.org/data/2.5/weather?q=" + encodedCity + "&appid=" + API_KEY + "&units=metric";
                forecastUrl = "https://api.openweathermap.org/data/2.5/forecast?q=" + encodedCity + "&appid=" + API_KEY + "&units=metric";
            }

            // 1. Fetch Data
            JsonObject currentJson = fetchJsonFromApi(currentUrl, gson);
            JsonObject forecastJson = fetchJsonFromApi(forecastUrl, gson);

            // 2. Map the real OpenWeather JSON to the frontend UI format
            Map<String, Object> weatherData = mapRealData(currentJson, forecastJson);
            
            // Send to frontend
            out.print(gson.toJson(weatherData));
            
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"Failed to fetch data. Verify city name and API Key.\"}");
        } finally {
            out.flush();
        }
    }

    private JsonObject fetchJsonFromApi(String urlString, Gson gson) throws Exception {
        URL url = new URL(urlString);
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        connection.setRequestMethod("GET");
        
        if (connection.getResponseCode() != 200) {
            throw new Exception("API Error: " + connection.getResponseCode());
        }

        InputStreamReader reader = new InputStreamReader(connection.getInputStream());
        Scanner scanner = new Scanner(reader);
        StringBuilder responseContent = new StringBuilder();
        while (scanner.hasNext()) {
            responseContent.append(scanner.nextLine());
        }
        scanner.close();
        
        return gson.fromJson(responseContent.toString(), JsonObject.class);
    }

    private Map<String, Object> mapRealData(JsonObject currentJson, JsonObject forecastJson) {
        Map<String, Object> finalData = new HashMap<>();

        String cityName = currentJson.get("name").getAsString();
        JsonObject currentMain = currentJson.getAsJsonObject("main");
        JsonObject currentWind = currentJson.getAsJsonObject("wind");
        String currentCondition = currentJson.getAsJsonArray("weather").get(0).getAsJsonObject().get("main").getAsString();

        Map<String, Object> current = new HashMap<>();
        current.put("temp", Math.round(currentMain.get("temp").getAsDouble()));
        current.put("feelsLike", Math.round(currentMain.get("feels_like").getAsDouble()));
        current.put("humidity", currentMain.get("humidity").getAsInt());
        current.put("wind", Math.round(currentWind.get("speed").getAsDouble() * 3.6)); 
        current.put("pressure", currentMain.get("pressure").getAsInt());
        current.put("condition", currentCondition);
        current.put("icon", getIconForCondition(currentCondition));

        List<Map<String, Object>> forecastList = new ArrayList<>();
        List<String> labels = new ArrayList<>();
        List<Long> temps = new ArrayList<>();

        JsonArray list = forecastJson.getAsJsonArray("list");
        
        for (int i = 0; i < list.size() && forecastList.size() < 5; i += 8) {
            JsonObject item = list.get(i).getAsJsonObject();
            long unixTimestamp = item.get("dt").getAsLong();
            
            java.util.Date date = new java.util.Date(unixTimestamp * 1000L);
            // FIX: Force Locale.ENGLISH to prevent Hindi/Local language translations
            String dayName = new java.text.SimpleDateFormat("EEE", Locale.ENGLISH).format(date);

            JsonObject main = item.getAsJsonObject("main");
            long temp = Math.round(main.get("temp").getAsDouble());
            String cond = item.getAsJsonArray("weather").get(0).getAsJsonObject().get("main").getAsString();

            Map<String, Object> dayData = new HashMap<>();
            dayData.put("day", dayName);
            dayData.put("temp", temp);
            dayData.put("condition", cond);
            dayData.put("icon", getIconForCondition(cond));

            forecastList.add(dayData);
            labels.add(dayName);
            temps.add(temp);
        }

        finalData.put("city", cityName.toUpperCase());
        finalData.put("current", current);
        finalData.put("forecast", forecastList);
        finalData.put("chartLabels", labels);
        finalData.put("chartData", temps);

        return finalData;
    }

    private String getIconForCondition(String condition) {
        if (condition.contains("Clear")) return "☀️";
        if (condition.contains("Cloud")) return "☁️";
        if (condition.contains("Rain") || condition.contains("Drizzle")) return "🌧️";
        if (condition.contains("Snow")) return "❄️";
        if (condition.contains("Thunderstorm")) return "🌩️";
        return "🌈"; 
    }
}