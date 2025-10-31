import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/tvshow.model.dart';
import '../store/list.store.dart';
import '../store/rating.store.dart';
import '../component/add_list_modal.dart';

class TvShowListItem extends StatelessWidget {
  final TvShow tvShow;

  const TvShowListItem({super.key, required this.tvShow});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ListStore>(context);
    final ratingStore = Provider.of<RatingStore>(context);

    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(tvShow.poster, width: 100),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  tvShow.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                ExpandableText(
                  tvShow.synopsis,
                  expandText: 'ver mais',
                  collapseText: 'ver menos',
                  maxLines: 5,
                  linkColor: Colors.blue,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black54,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.playlist_add,
                        color: Color(0xFFD81B60),
                      ),
                      onPressed: () async {
                        final RenderBox button =
                            context.findRenderObject() as RenderBox;
                        final RenderBox overlay =
                            Overlay.of(context).context.findRenderObject()
                                as RenderBox;
                        final Offset position = button.localToGlobal(
                          Offset.zero,
                          ancestor: overlay,
                        );

                        final allLists = store.lists
                            .map((list) => list.name)
                            .toList();

                        final selectedList = await showMenu<String>(
                          context: context,
                          position: RelativeRect.fromLTRB(
                            position.dx + 150,
                            position.dy + button.size.height - 30,
                            position.dx + button.size.width,
                            position.dy,
                          ),
                          items: allLists.isEmpty
                              ? [
                                  PopupMenuItem<String>(
                                    enabled: false,
                                    child: TextButton.icon(
                                      onPressed: () {
                                        Navigator.pop(context);

                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return ListFormModal();
                                          },
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.add,
                                        color: Colors.grey,
                                      ),
                                      label: const Text(
                                        'Criar nova lista',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                ]
                              : allLists
                                    .map(
                                      (listName) => PopupMenuItem<String>(
                                        value: listName,
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.list_alt,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(width: 10),
                                            Text(listName),
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList(),
                        );

                        final tvShowAlreadyInAnyList = store.lists
                            .map(
                              (list) => list.tvShows
                                  .map((tv) => tv.id == tvShow.id)
                                  .contains(true),
                            )
                            .contains(true);

                        if (selectedList != null) {
                          final listId = store.lists
                              .firstWhere((list) => list.name == selectedList)
                              .id;
                          allLists.firstWhere(
                            (listName) => listName == selectedList,
                          );
                          await store.addToTheList(listId, tvShow.id);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                tvShowAlreadyInAnyList
                                    ? "Série já existe na lista!"
                                    : store.addToTheListError != null
                                    ? "Erro ao adicionar à lista!"
                                    : "${tvShow.title} adicionado à lista $selectedList",
                              ),
                              backgroundColor: store.addToTheListError != null
                                  ? Colors.redAccent
                                  : Colors.pink,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },

                      tooltip: "Adicionar à lista",
                    ),
                    // Botão Avaliar
                    IconButton(
                      icon: const Icon(
                        Icons.star_border,
                        color: Color(0xFFD81B60),
                      ),
                      onPressed: () async {
                        final RenderBox button =
                            context.findRenderObject() as RenderBox;
                        final RenderBox overlay =
                            Overlay.of(context).context.findRenderObject()
                                as RenderBox;
                        final Offset position = button.localToGlobal(
                          Offset.zero,
                          ancestor: overlay,
                        );

                        final allScaless = ratingStore.ratingScales
                            .map((list) => list.label)
                            .toList();

                        final selectedScale = await showMenu<String>(
                          context: context,
                          position: RelativeRect.fromLTRB(
                            position.dx + 200,
                            position.dy + button.size.height - 30,
                            position.dx + button.size.width,
                            position.dy,
                          ),
                          items: allScaless
                              .map(
                                (scale) => PopupMenuItem<String>(
                                  value: scale,
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.list_alt,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(scale),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        );

                        if (selectedScale != null) {
                          final indexScale =
                              allScaless.indexOf(selectedScale) + 1;

                          await ratingStore.createRating(tvShow.id, indexScale);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                store.error != null
                                    ? "Erro ao registrar avaliação!"
                                    : "Avaliação de ${tvShow.title} foi registrada com sucesso!",
                              ),
                              backgroundColor: store.addToTheListError != null
                                  ? Colors.redAccent
                                  : Colors.pink,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },

                      tooltip: "Avaliar",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
