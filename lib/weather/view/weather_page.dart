import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/search/search.dart';
import 'package:flutter_weather/weather/weather.dart';
import 'package:flutter_weather/tasks/view/tasks_page.dart';
class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.read<WeatherCubit>().state.status == WeatherStatus.initial) {
        context.read<WeatherCubit>().fetchWeather('Balikpapan');
      }
    });
  }

  void _showSettingsModal(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return BlocProvider.value(
          value: context.read<WeatherCubit>(),
          child: const SettingsModal(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          BlocBuilder<WeatherCubit, WeatherState>(
            buildWhen: (previous, current) => 
              previous.favoriteCities != current.favoriteCities || 
              previous.weather.location != current.weather.location,
            builder: (context, state) {
              if (state.weather.location.isEmpty) return const SizedBox.shrink();
              final isFavorite = state.favoriteCities.contains(state.weather.location);
              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.redAccent : Colors.white,
                ),
                onPressed: () => context.read<WeatherCubit>().toggleFavoriteCity(state.weather.location),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.my_location, color: Colors.white),
            onPressed: () => context.read<WeatherCubit>().fetchWeatherByIp(),
          ),
          IconButton(
            icon: const Icon(Icons.check_circle_outline, color: Colors.white),
            onPressed: () => Navigator.of(context).push(TasksPage.route()),
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () => _showSettingsModal(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background Gradient
          Positioned.fill(
            child: BlocBuilder<WeatherCubit, WeatherState>(
              buildWhen: (previous, current) => 
                previous.weather.condition != current.weather.condition ||
                previous.weather.isDay != current.weather.isDay,
              builder: (context, state) {
                final condition = state.weather.condition;
                final isDay = state.weather.isDay;
                return AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: _getGradientColors(condition, isDay),
                    ),
                  ),
                );
              },
            ),
          ),
          // Particle Effects
          Positioned.fill(
            child: BlocBuilder<WeatherCubit, WeatherState>(
              buildWhen: (previous, current) => 
                previous.weather.condition != current.weather.condition,
              builder: (context, state) {
                if (state.weather.condition == WeatherCondition.clear ||
                    state.weather.condition == WeatherCondition.unknown) {
                  return const SizedBox.shrink();
                }
                return WeatherParticles(condition: state.weather.condition);
              },
            ),
          ),
          // Content
          Center(
            child: BlocBuilder<WeatherCubit, WeatherState>(
              builder: (context, state) {
                return switch (state.status) {
                  WeatherStatus.initial => const WeatherEmpty(),
                  WeatherStatus.loading => const WeatherLoading(),
                  WeatherStatus.failure => const WeatherError(),
                  WeatherStatus.success => WeatherPopulated(
                    weather: state.weather,
                    units: state.temperatureUnits,
                    onRefresh: () {
                      return context.read<WeatherCubit>().refreshWeather();
                    },
                  ),
                };
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white.withValues(alpha: 0.9),
        child: const Icon(Icons.search, semanticLabel: 'Search', color: Colors.black87),
        onPressed: () async {
          final city = await Navigator.of(context).push(SearchPage.route(context.read<WeatherCubit>()));
          if (!context.mounted || city == null || city.isEmpty) return;
          await context.read<WeatherCubit>().fetchWeather(city);
        },
      ),
    );
  }

  List<Color> _getGradientColors(WeatherCondition condition, bool isDay) {
    if (!isDay) {
      // Night theme
      return [const Color(0xFF141E30), const Color(0xFF243B55)];
    }

    switch (condition) {
      case WeatherCondition.clear:
        return [const Color(0xFF4A90E2), const Color(0xFF50E3C2)];
      case WeatherCondition.snowy:
        return [const Color(0xFFE0EAFC), const Color(0xFFCFDEF3)];
      case WeatherCondition.cloudy:
        return [const Color(0xFF757F9A), const Color(0xFFD7DDE8)];
      case WeatherCondition.rainy:
        return [const Color(0xFF3a7bd5), const Color(0xFF3a6073)];
      case WeatherCondition.unknown:
        return [const Color(0xFF6dd5ed), const Color(0xFF2193b0)];
    }
  }
}

class SettingsModal extends StatelessWidget {
  const SettingsModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E1E), // Dark modern modal
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          BlocBuilder<WeatherCubit, WeatherState>(
            buildWhen: (previous, current) =>
                previous.temperatureUnits != current.temperatureUnits,
            builder: (context, state) {
              final isCelsius = state.temperatureUnits.isCelsius;
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Temperature',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        _buildToggleButton(
                          label: '°C',
                          isSelected: isCelsius,
                          onTap: () {
                            if (!isCelsius) {
                              context.read<WeatherCubit>().toggleUnits();
                            }
                          },
                        ),
                        const SizedBox(width: 8),
                        _buildToggleButton(
                          label: '°F',
                          isSelected: !isCelsius,
                          onTap: () {
                            if (isCelsius) {
                              context.read<WeatherCubit>().toggleUnits();
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 24), // Give it some space at the bottom
        ],
      ),
    );
  }

  Widget _buildToggleButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white24 : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white54,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

