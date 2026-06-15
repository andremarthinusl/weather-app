import 'package:flutter/material.dart';
import 'package:flutter_weather/weather/weather.dart';
import 'package:flutter_weather/weather/view/weather_page.dart';

class WeatherPopulated extends StatelessWidget {
  const WeatherPopulated({
    required this.weather,
    required this.units,
    required this.onRefresh,
    super.key,
  });

  final Weather weather;
  final TemperatureUnits units;
  final ValueGetter<Future<void>> onRefresh;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 100), // Push down to give breathing room
        children: [
          // Main current weather
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  weather.location,
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  weather.formattedTemperature(units),
                  style: theme.textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 80, // Large display for temperature
                    color: Colors.white,
                  ),
                ),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 1200),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: child,
                    );
                  },
                  child: Text(
                    weather.condition.toEmoji,
                    style: const TextStyle(fontSize: 80), // Larger emoji
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'H: ${weather.dailyForecast.isNotEmpty ? weather.dailyForecast.first.temperatureMax.toStringAsFixed(0) : '--'}° L: ${weather.dailyForecast.isNotEmpty ? weather.dailyForecast.first.temperatureMin.toStringAsFixed(0) : '--'}°',
                  style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),

          // Hourly Forecast
          if (weather.hourlyForecast.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: GlassCard(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: weather.hourlyForecast.length,
                    itemBuilder: (context, index) {
                      final hourly = weather.hourlyForecast[index];
                      final isNow = index == 0;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              isNow ? 'Now' : '${hourly.time.hour.toString().padLeft(2, '0')}',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: isNow ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                            Text(
                              hourly.condition.toEmoji,
                              style: const TextStyle(fontSize: 24),
                            ),
                            Text(
                              '${hourly.temperature.toStringAsFixed(0)}°',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

          const SizedBox(height: 16),

          // Daily Forecast and Wind
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 10 Day Forecast (actually 7 from OpenMeteo default)
                Expanded(
                  flex: 3,
                  child: GlassCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.calendar_month, color: Colors.white70, size: 16),
                            const SizedBox(width: 8),
                            Text(
                              '7-DAY FORECAST',
                              style: theme.textTheme.labelSmall?.copyWith(color: Colors.white70),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ...weather.dailyForecast.map((daily) {
                          final isToday = daily.time.day == DateTime.now().day;
                          final dayString = isToday ? 'Today' : _getWeekday(daily.time.weekday);
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 45,
                                  child: Text(
                                    dayString,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Text(daily.condition.toEmoji, style: const TextStyle(fontSize: 18)),
                                SizedBox(
                                  width: 25,
                                  child: Text(
                                    '${daily.temperatureMin.toStringAsFixed(0)}°',
                                    style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 8),
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: Colors.white24,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    // A simple visual indicator could go here
                                  ),
                                ),
                                SizedBox(
                                  width: 25,
                                  child: Text(
                                    '${daily.temperatureMax.toStringAsFixed(0)}°',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Wind and Extras
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      GlassCard(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.air, color: Colors.white70, size: 16),
                                const SizedBox(width: 8),
                                Text(
                                  'WIND',
                                  style: theme.textTheme.labelSmall?.copyWith(color: Colors.white70),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '${weather.windSpeed} km/h',
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Direction: ${weather.windDirection}°',
                              style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      GlassCard(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.water_drop, color: Colors.white70, size: 16),
                                const SizedBox(width: 8),
                                Text(
                                  'HUMIDITY',
                                  style: theme.textTheme.labelSmall?.copyWith(color: Colors.white70),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${weather.humidity.toStringAsFixed(0)}%',
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      GlassCard(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.thermostat, color: Colors.white70, size: 16),
                                const SizedBox(width: 8),
                                Text(
                                  'FEELS LIKE',
                                  style: theme.textTheme.labelSmall?.copyWith(color: Colors.white70),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${weather.feelsLike.toStringAsFixed(0)}°',
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      GlassCard(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.wb_sunny, color: Colors.amberAccent, size: 16),
                                const SizedBox(width: 8),
                                Text(
                                  'UV INDEX',
                                  style: theme.textTheme.labelSmall?.copyWith(color: Colors.white70),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${weather.uvIndex.toStringAsFixed(0)}',
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      GlassCard(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.masks, color: Colors.white70, size: 16),
                                const SizedBox(width: 8),
                                Text(
                                  'AIR QUALITY',
                                  style: theme.textTheme.labelSmall?.copyWith(color: Colors.white70),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${weather.aqi.toStringAsFixed(0)} - ${_getAqiLabel(weather.aqi)}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: _getAqiColor(weather.aqi),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'PM2.5: ${weather.pm25.toStringAsFixed(1)}',
                              style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 100), // Bottom padding
        ],
      ),
    );
  }

  String _getWeekday(int weekday) {
    switch (weekday) {
      case 1: return 'Mon';
      case 2: return 'Tue';
      case 3: return 'Wed';
      case 4: return 'Thu';
      case 5: return 'Fri';
      case 6: return 'Sat';
      case 7: return 'Sun';
      default: return '';
    }
  }

  String _getAqiLabel(double aqi) {
    if (aqi <= 50) return 'Good';
    if (aqi <= 100) return 'Moderate';
    if (aqi <= 150) return 'Unhealthy (SG)';
    if (aqi <= 200) return 'Unhealthy';
    if (aqi <= 300) return 'Very Unhealthy';
    return 'Hazardous';
  }

  Color _getAqiColor(double aqi) {
    if (aqi <= 50) return Colors.greenAccent;
    if (aqi <= 100) return Colors.yellowAccent;
    if (aqi <= 150) return Colors.orangeAccent;
    if (aqi <= 200) return Colors.redAccent;
    if (aqi <= 300) return Colors.purpleAccent;
    return Colors.brown;
  }
}

extension on WeatherCondition {
  String get toEmoji {
    switch (this) {
      case WeatherCondition.clear:
        return '☀️';
      case WeatherCondition.rainy:
        return '🌧️';
      case WeatherCondition.cloudy:
        return '☁️';
      case WeatherCondition.snowy:
        return '🌨️';
      case WeatherCondition.unknown:
        return '❓';
    }
  }
}

extension on Weather {
  String formattedTemperature(TemperatureUnits units) {
    return '${temperature.value.toStringAsFixed(0)}°';
  }
}
