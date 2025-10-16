import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../store/rating.store.dart';

class ReviewPage extends StatelessWidget {
  const ReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<RatingStore>(context);
    final allTvShowsRatings = store.ratings;

    if (allTvShowsRatings.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(27),
          child: Text(
            'Nenhum programa de TV foi avaliado!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 19, color: Colors.black),
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: const Color(0xFFFFC1E3),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: ListView.builder(
          itemCount: allTvShowsRatings.length,

          itemBuilder: (context, index) {
            final tvShowRating = allTvShowsRatings[index];
            const Map<String, Color> kRatingColorMap = {
              'Péssimo': Color.fromARGB(255, 255, 0, 0), // Vermelho
              'Entediante': Color.fromARGB(255, 255, 140, 0), // Laranja Escuro
              'Mediano': Color.fromARGB(255, 255, 204, 0), // Amarelo
              'Muito bom': Color.fromARGB(
                255,
                173,
                216,
                230,
              ), // Azul Claro/Suave
              'Amei': Color(0xFFD81B60), // Rosa/Tema da App (Destaque)
            };

            final ratingColor =
                kRatingColorMap[tvShowRating.scale.label] ?? Colors.grey;
            return Card(
              key: ValueKey(tvShowRating.tvShow?.title),
              margin: const EdgeInsets.symmetric(vertical: 6),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  leading: Container(
                    width: 8,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: ratingColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  title: Text(
                    tvShowRating.tvShow?.title ?? '',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  subtitle: Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        tvShowRating.scale.label,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF757575),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
