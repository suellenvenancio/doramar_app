import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test/component/search_input.dart';
import '../models/genres.model.dart';
import '../models/tvshow.model.dart';

import '../store/genre.store.dart';
import '../store/tvshow_store.dart';
import 'tv_show_list_item.dart';

class TvShowList extends StatefulWidget {
  const TvShowList({super.key});

  @override
  State<TvShowList> createState() => _TvShowListState();
}

class _TvShowListState extends State<TvShowList> {
  String searchQuery = '';
  bool isFilterActive = false;
  Set<String> selectedGenres = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 174, 201, 1),
      body: SafeArea(
        child: Column(
          children: [
            SearchInput(
              selectedGenres: selectedGenres,
              onSearchChanged: (String query) {
                setState(() {
                  searchQuery = query;
                });
              },
              onGenresChanged: (Set<String> genres) {
                setState(() {
                  selectedGenres = genres;
                });
              },
            ),
            Expanded(
              child: Consumer<TvShowStore>(
                builder: (context, tvShowStore, child) {
                  if (tvShowStore.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (tvShowStore.error != null &&
                      tvShowStore.error!.isNotEmpty) {
                    return Center(child: Text(tvShowStore.error!));
                  }

                  if (tvShowStore.tvShows.isEmpty) {
                    return const Center(
                      child: Text("Nenhum dorama encontrado!"),
                    );
                  }

                  Iterable<TvShow> showsToFilter = tvShowStore.tvShows;
                  final List<Genre> genres = Provider.of<GenreStore>(
                    context,
                  ).genres;

                  if (searchQuery.isNotEmpty) {
                    showsToFilter = showsToFilter.where(
                      (tvShow) =>
                          tvShow.title.toLowerCase().contains(searchQuery),
                    );
                  }

                  if (selectedGenres.isNotEmpty) {
                    showsToFilter = showsToFilter.where((tvShow) {
                      return tvShow.genres?.any(
                            (tvGenre) => selectedGenres.contains(tvGenre.name),
                          ) ??
                          false;
                    });
                  }

                  final filteredShows = showsToFilter.toList();

                  return ListView.builder(
                    itemCount: filteredShows.length,
                    itemBuilder: (context, index) {
                      final tvShow = filteredShows[index];

                      return TvShowListItem(
                        key: ValueKey(tvShow.id),
                        tvShow: tvShow,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
