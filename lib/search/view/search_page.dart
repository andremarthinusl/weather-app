import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_repository/weather_repository.dart';
import 'package:flutter_weather/search/search.dart';
import 'package:flutter_weather/weather/weather.dart';

class SearchPage extends StatelessWidget {
  const SearchPage._();

  static Route<String> route(WeatherCubit weatherCubit) {
    return MaterialPageRoute(
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: weatherCubit),
          BlocProvider(create: (context) => SearchCubit(context.read<WeatherRepository>())),
        ],
        child: const SearchPage._(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('City Search', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        leading: const BackButton(),
      ),
      body: const SearchView(),
    );
  }
}

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    labelText: 'Search City',
                    hintText: 'e.g. Balikpapan',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _textController.clear();
                        context.read<SearchCubit>().onSearchQueryChanged('');
                      },
                    ),
                  ),
                  onChanged: (text) {
                    context.read<SearchCubit>().onSearchQueryChanged(text);
                  },
                  onSubmitted: (text) {
                    if (text.isNotEmpty) {
                      Navigator.of(context).pop(text);
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                key: const Key('searchPage_search_iconButton'),
                icon: const Icon(Icons.search, semanticLabel: 'Submit'),
                onPressed: () {
                  if (_textController.text.isNotEmpty) {
                    Navigator.of(context).pop(_textController.text);
                  }
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: BlocBuilder<SearchCubit, SearchState>(
            builder: (context, state) {
              if (state.status == SearchStatus.initial || (state.locations.isEmpty && state.status == SearchStatus.success && _textController.text.isEmpty)) {
                return BlocBuilder<WeatherCubit, WeatherState>(
                  builder: (context, weatherState) {
                    final favorites = weatherState.favoriteCities;
                    if (favorites.isEmpty) {
                      return const Center(child: Text('Search for a city or pick a favorite'));
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Text('Favorite Cities', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: favorites.map((city) {
                            return ActionChip(
                              avatar: const Icon(Icons.favorite, color: Colors.redAccent, size: 16),
                              label: Text(city),
                              onPressed: () {
                                Navigator.of(context).pop(city);
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    );
                  },
                );
              }
              
              if (state.status == SearchStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (state.status == SearchStatus.failure) {
                return const Center(child: Text('Failed to load results'));
              }
              
              if (state.locations.isEmpty && _textController.text.isNotEmpty && state.status == SearchStatus.success) {
                return const Center(child: Text('No cities found'));
              }

              return ListView.builder(
                itemCount: state.locations.length,
                itemBuilder: (context, index) {
                  final location = state.locations[index];
                  return ListTile(
                    leading: const Icon(Icons.location_city),
                    title: Text(location),
                    onTap: () {
                      Navigator.of(context).pop(location);
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
