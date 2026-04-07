<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Java JSP Weather App: Neo-Brutalist</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="style.css">
</head>
<body class="text-black overflow-x-hidden p-4 md:p-8">

    <header class="max-w-6xl mx-auto mb-8">
        <div class="bg-[#ffc900] brutal-border brutal-shadow-static p-6 flex flex-col md:flex-row justify-between items-center">
            <div>
                <h1 class="text-4xl md:text-5xl font-bold uppercase tracking-tight">WeatherApp</h1>
                <p class="text-xl mt-2 font-semibold bg-white inline-block px-2 brutal-border">Java Servlet + JSP Edition</p>
            </div>
            <div class="mt-4 md:mt-0 flex gap-2 flex-wrap">
                <button onclick="switchTab('demo')" class="tab-btn active bg-[#ff90e8] brutal-border brutal-shadow px-4 py-2 font-bold uppercase text-sm">Live App</button>
            </div>
        </div>
    </header>

    <main class="max-w-6xl mx-auto">
        <section id="demo" class="tab-content active">
            <div class="bg-white brutal-border brutal-shadow-static p-6 md:p-10 mb-8">
                <div class="flex flex-col md:flex-row justify-between items-start md:items-center mb-8 gap-4">
                    <h2 class="text-3xl font-bold bg-[#8cf0e1] inline-block px-3 brutal-border">Live Weather Data</h2>
                    
                    <div class="flex w-full md:w-auto gap-2">
                        <div class="relative flex-grow">
                            <input type="text" id="cityInput" list="cities" placeholder="Enter city name..." class="w-full brutal-border px-4 py-3 font-bold focus:outline-none focus:bg-yellow-50 text-lg">
                            <datalist id="cities">
                                <option value="London"></option>
                                <option value="New York"></option>
                                <option value="Tokyo"></option>
                                <option value="Paris"></option>
                                <option value="Mumbai"></option>
                                <option value="Sydney"></option>
                            </datalist>
                        </div>
                        <button onclick="fetchWeatherManual()" class="bg-[#ff5722] text-white brutal-border brutal-shadow px-6 py-3 font-bold hover:bg-[#e64a19]">SEARCH</button>
                        <button onclick="autoDetectLocation()" class="bg-[#000] text-white brutal-border brutal-shadow px-4 py-3 font-bold hover:bg-gray-800" title="Auto Detect Location">📍</button>
                    </div>
                </div>

                <div id="errorBox" class="hidden bg-red-500 text-white brutal-border p-4 mb-8 font-bold text-lg animate-bounce">
                    ⚠️ Error: City not found by the Java Backend. Please try another location.
                </div>

                <div id="loadingBox" class="hidden text-center py-10">
                    <div class="text-5xl animate-spin inline-block">🌀</div>
                    <p class="font-bold text-xl mt-4">Fetching Data from Servlet...</p>
                </div>

                <div id="weatherDashboard" class="hidden">
                    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8 mb-8">
                        
                        <div class="lg:col-span-1 bg-[#8cf0e1] brutal-border brutal-shadow p-6 flex flex-col justify-center items-center text-center">
                            <h3 id="currentCity" class="text-3xl font-bold uppercase mb-2">City Name</h3>
                            <p id="currentDate" class="text-lg font-semibold mb-6">Date</p>
                            <div id="currentIcon" class="text-8xl animate-float mb-4">☀️</div>
                            <div class="text-6xl font-bold mb-2"><span id="currentTemp">0</span>°C</div>
                            <p id="currentDesc" class="text-xl font-bold uppercase bg-white px-3 py-1 brutal-border inline-block">Condition</p>
                        </div>

                        <div class="lg:col-span-2 grid grid-cols-2 gap-4">
                            <div class="bg-[#ff90e8] brutal-border brutal-shadow p-6 flex flex-col justify-center items-center">
                                <span class="text-4xl mb-2">💧</span>
                                <span class="text-lg font-bold uppercase">Humidity</span>
                                <span id="currentHumidity" class="text-3xl font-bold">0%</span>
                            </div>
                            <div class="bg-[#ffc900] brutal-border brutal-shadow p-6 flex flex-col justify-center items-center">
                                <span class="text-4xl mb-2">💨</span>
                                <span class="text-lg font-bold uppercase">Wind Speed</span>
                                <span id="currentWind" class="text-3xl font-bold">0 km/h</span>
                            </div>
                            <div class="bg-white brutal-border brutal-shadow p-6 flex flex-col justify-center items-center">
                                <span class="text-4xl mb-2">🌡️</span>
                                <span class="text-lg font-bold uppercase">Feels Like</span>
                                <span id="currentFeelsLike" class="text-3xl font-bold">0°C</span>
                            </div>
                            <div class="bg-[#b4b4b4] brutal-border brutal-shadow p-6 flex flex-col justify-center items-center">
                                <span class="text-4xl mb-2">⏱️</span>
                                <span class="text-lg font-bold uppercase">Pressure</span>
                                <span id="currentPressure" class="text-3xl font-bold">0 hPa</span>
                            </div>
                        </div>
                    </div>

                    <div class="bg-white brutal-border brutal-shadow p-6 mb-8">
                        <h3 class="text-2xl font-bold mb-6 uppercase bg-[#ffc900] inline-block px-2 brutal-border">Temperature Trend (5 Days)</h3>
                        <div class="chart-container">
                            <canvas id="forecastChart"></canvas>
                        </div>
                    </div>

                    <div class="bg-white brutal-border brutal-shadow p-6">
                        <h3 class="text-2xl font-bold mb-6 uppercase bg-[#ff90e8] inline-block px-2 brutal-border">5-Day Forecast</h3>
                        <div id="forecastGrid" class="grid grid-cols-2 md:grid-cols-5 gap-4">
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <script>
        function switchTab(tabId) {
            document.querySelectorAll('.tab-content').forEach(tab => tab.classList.remove('active'));
            document.getElementById(tabId).classList.add('active');
        }

        let chartInstance = null;

        function renderWeather(data) {
            document.getElementById('currentCity').innerText = data.city;
            document.getElementById('currentDate').innerText = new Date().toLocaleDateString('en-US', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' });
            document.getElementById('currentTemp').innerText = data.current.temp;
            document.getElementById('currentDesc').innerText = data.current.condition;
            document.getElementById('currentIcon').innerText = data.current.icon;
            
            document.getElementById('currentHumidity').innerText = data.current.humidity + '%';
            document.getElementById('currentWind').innerText = data.current.wind + ' km/h';
            document.getElementById('currentFeelsLike').innerText = data.current.feelsLike + '°C';
            document.getElementById('currentPressure').innerText = data.current.pressure + ' hPa';

            const grid = document.getElementById('forecastGrid');
            grid.innerHTML = '';
            data.forecast.forEach(day => {
                const card = document.createElement('div');
                card.className = 'bg-white brutal-border p-4 flex flex-col items-center text-center hover:-translate-y-2 transition-transform';
                card.innerHTML = `
                    <div class="font-bold text-lg mb-2 uppercase border-b-2 border-black w-full pb-1">\${day.day}</div>
                    <div class="text-4xl mb-2">\${day.icon}</div>
                    <div class="font-bold text-xl">\${day.temp}°C</div>
                    <div class="text-sm font-semibold text-gray-600">\${day.condition}</div>
                `;
                grid.appendChild(card);
            });

            renderChart(data.chartLabels, data.chartData);
        }

        function renderChart(labels, dataPoints) {
            const ctx = document.getElementById('forecastChart').getContext('2d');
            if (chartInstance) chartInstance.destroy();

            chartInstance = new Chart(ctx, {
                type: 'line',
                data: {
                    labels: labels,
                    datasets: [{
                        label: 'Temperature (°C)',
                        data: dataPoints,
                        borderColor: '#000',
                        backgroundColor: '#ffc900',
                        borderWidth: 4,
                        pointBackgroundColor: '#ff90e8',
                        pointBorderColor: '#000',
                        pointBorderWidth: 3,
                        pointRadius: 6,
                        pointHoverRadius: 8,
                        fill: true,
                        tension: 0.1
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { display: false } },
                    scales: {
                        x: { grid: { color: '#000', lineWidth: 2, drawBorder: true }, ticks: { font: { family: 'Space Grotesk', weight: 'bold', size: 14 }, color: '#000' } },
                        y: { grid: { color: '#000', lineWidth: 2, drawBorder: true }, ticks: { font: { family: 'Space Grotesk', weight: 'bold', size: 14 }, color: '#000', stepSize: 5 } }
                    }
                }
            });
        }

        function fetchWeatherManual() {
            const city = document.getElementById('cityInput').value.trim();
            if(!city) return;
            processWeatherData(city);
        }

        // UPDATED: Now fetches precise LAT/LON coordinates to send to the Java Backend
        function autoDetectLocation() {
            if (navigator.geolocation) {
                document.getElementById('cityInput').value = "Detecting Location...";
                navigator.geolocation.getCurrentPosition(
                    (position) => {
                        const lat = position.coords.latitude;
                        const lon = position.coords.longitude;
                        // Tell the Java backend we are using exact coordinates via the COORDS: flag
                        processWeatherData(`COORDS:\${lat},\${lon}`);
                    },
                    (error) => {
                        document.getElementById('cityInput').value = "";
                        alert("Geolocation failed. Please ensure location permissions are enabled in your browser.");
                    }
                );
            } else {
                alert("Geolocation is not supported by this browser.");
            }
        }

        // Fetches data from the Java Servlet backend
        function processWeatherData(city) {
            document.getElementById('weatherDashboard').classList.add('hidden');
            document.getElementById('errorBox').classList.add('hidden');
            document.getElementById('loadingBox').classList.remove('hidden');

            fetch('api/weather?city=' + encodeURIComponent(city))
                .then(response => {
                    if (!response.ok) throw new Error("Network response was not ok");
                    return response.json();
                })
                .then(data => {
                    // When exact coordinates are used, update the input box to show the detected city name
                    if (city.startsWith('COORDS:')) {
                        document.getElementById('cityInput').value = data.city;
                    }
                    
                    document.getElementById('loadingBox').classList.add('hidden');
                    renderWeather(data);
                    document.getElementById('weatherDashboard').classList.remove('hidden');
                })
                .catch(error => {
                    console.error("Fetch error:", error);
                    document.getElementById('loadingBox').classList.add('hidden');
                    document.getElementById('errorBox').classList.remove('hidden');
                });
        }

        window.onload = () => {
            document.getElementById('cityInput').value = 'Tokyo';
            fetchWeatherManual();
        };
    </script>
</body>
</html>