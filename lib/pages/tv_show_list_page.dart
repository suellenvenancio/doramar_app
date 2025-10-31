import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/tvshow.model.dart';
import '../store/list.store.dart';

class SeriesListPage extends StatefulWidget {
  final List<TvShow> tvShows;
  final String listId;

  const SeriesListPage({
    super.key,
    required this.tvShows,
    required this.listId,
  });

  @override
  State<SeriesListPage> createState() => _SeriesListPageState();
}

class _SeriesListPageState extends State<SeriesListPage> {
  late List<TvShow> tvShows;
  late String listId;

  @override
  void initState() {
    super.initState();
    tvShows = widget.tvShows;
    listId = widget.listId;
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ListStore>(context);

    if (tvShows.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(27),
          child: Text(
            'Nenhum dorama na lista. Volte a tela séries para adicionar um título na lista!',
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
        child: ReorderableListView.builder(
          itemCount: tvShows.length,
          onReorder: (oldIndex, newIndex) async {
            if (newIndex > oldIndex) newIndex--;
            setState(() {
              final item = tvShows.removeAt(oldIndex);
              tvShows.insert(newIndex, item);
            });

            await store.updateList(tvShows[newIndex].id, listId, newIndex);
          },
          itemBuilder: (context, index) {
            final tvShow = tvShows[index];

            return Card(
              key: ValueKey(tvShow.title),
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

                  title: Text(
                    tvShow.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  trailing: const Icon(
                    Icons.drag_handle_rounded,
                    color: Color(0xFFD81B60),
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
