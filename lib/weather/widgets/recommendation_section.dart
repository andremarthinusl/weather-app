import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/weather/widgets/glass_card.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../places/models/place.dart';
import '../cubit/recommendation_cubit.dart';

class RecommendationSection extends StatelessWidget {
  const RecommendationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecommendationCubit, RecommendationState>(
      builder: (context, state) {
        if (state.status == RecommendationStatus.initial ||
            state.status == RecommendationStatus.loading) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: GlassCard(
              padding: EdgeInsets.all(24),
              child: Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
          );
        }

        if (state.status == RecommendationStatus.failure) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: GlassCard(
              padding: EdgeInsets.all(24),
              child: Center(
                child: Text('Failed to load recommendations', style: TextStyle(color: Colors.white)),
              ),
            ),
          );
        }

        if (state.places.isEmpty) {
          return const SizedBox.shrink(); // Hide if no recommendations
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'SMART RECOMMENDATION',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.white70,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 280, // Taller area
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: state.places.length,
                itemBuilder: (context, index) {
                  final place = state.places[index];
                  return Container(
                    width: 280, // Much wider cards
                    margin: EdgeInsets.only(
                      right: index == state.places.length - 1 ? 0 : 16,
                    ),
                    child: _RecommendationCard(place: place),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  final Place place;

  const _RecommendationCard({required this.place});

  void _openMap() async {
    final query = Uri.encodeComponent('${place.name} ${place.address}');
    final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }


  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: place.photoUrl != null
                  ? Image.network(
                      place.photoUrl!,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.white12,
                        child: const Icon(Icons.restaurant, color: Colors.white54),
                      ),
                    )
                  : Container(
                      color: Colors.white12,
                      child: const Icon(Icons.restaurant, color: Colors.white54),
                    ),
            ),
          ),
          const SizedBox(height: 12),
          // Title
          Text(
            place.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 4),
          // Rating and Status
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 16),
              const SizedBox(width: 4),
              Text(
                place.rating > 0 ? place.rating.toString() : 'New',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: place.isOpen ? Colors.green.withValues(alpha: 0.2) : Colors.red.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  place.isOpen ? 'OPEN' : 'CLOSED',
                  style: TextStyle(
                    color: place.isOpen ? Colors.greenAccent : Colors.redAccent,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _openMap,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: Colors.white24),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: const Icon(Icons.map, color: Colors.white, size: 18),
                  label: const Text('Maps', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
