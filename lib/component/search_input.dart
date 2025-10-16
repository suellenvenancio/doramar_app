import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test/utils/input_formater.dart';
import '../store/genre.store.dart';

class SearchInput extends StatelessWidget {
  final Set<String> selectedGenres;
  final Function(String) onSearchChanged;
  final Function(Set<String>) onGenresChanged;

  const SearchInput({
    super.key,
    required this.selectedGenres,
    required this.onSearchChanged,
    required this.onGenresChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              inputFormatters: [LowerCaseTextFormatter()],
              decoration: InputDecoration(
                hintText: 'Buscar drama...',
                prefixIcon: const Icon(Icons.search, color: Colors.pink),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: onSearchChanged,
            ),
          ),
          const SizedBox(width: 10),
          Builder(
            builder: (context) {
              final genreStore = Provider.of<GenreStore>(context);

              return IconButton(
                icon: const Icon(Icons.filter_list, color: Colors.pink),
                tooltip: 'Filtrar resultados',
                onPressed: () async {
                  final RenderBox button =
                      context.findRenderObject() as RenderBox;
                  final RenderBox overlay =
                      Overlay.of(context).context.findRenderObject()
                          as RenderBox;
                  final double rightMargin = 10;
                  final double maxMenuWidth = 200;

                  final RelativeRect position = RelativeRect.fromLTRB(
                    overlay.size.width - maxMenuWidth - rightMargin,
                    button.localToGlobal(Offset.zero, ancestor: overlay).dy +
                        50.0,
                    rightMargin,
                    0,
                  );

                  final genres = genreStore.genres.map((g) => g.name).toList();
                  final tempSelectedGenres = Set<String>.from(selectedGenres);

                  await showMenu(
                    context: context,
                    position: position,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    items: [
                      PopupMenuItem(
                        enabled: false,
                        child: StatefulBuilder(
                          builder: (context, setStateDialog) {
                            return ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxHeight: 350,
                                maxWidth: 250,
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Gêneros',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    ...genres.map((genre) {
                                      return CheckboxListTile(
                                        dense: true,
                                        contentPadding: EdgeInsets.zero,
                                        title: Text(
                                          genre,
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        value: tempSelectedGenres.contains(
                                          genre,
                                        ),
                                        onChanged: (checked) {
                                          setStateDialog(() {
                                            if (checked == true) {
                                              tempSelectedGenres.add(genre);
                                            } else {
                                              tempSelectedGenres.remove(genre);
                                            }
                                          });
                                        },
                                      );
                                    }),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Cancelar'),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.pink,
                                          ),
                                          onPressed: () {
                                            onGenresChanged(tempSelectedGenres);
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Aplicar'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
