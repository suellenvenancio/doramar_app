import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../component/add_list_modal.dart';
import '../models/tvshow.model.dart';
import '../store/list.store.dart';
import 'tv_show_list_page.dart';

class ListPage extends StatefulWidget {
  final String listId;
  final bool showListDetails;

  const ListPage({
    super.key,
    required this.listId,
    required this.showListDetails,
  });

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  late String listId;
  late List<TvShow> tvShows;
  late bool showListDetails;

  @override
  void initState() {
    super.initState();
    listId = widget.listId;
    showListDetails = widget.showListDetails;
  }

  @override
  Widget build(BuildContext context) {
    final listStore = Provider.of<ListStore>(context);

    return Scaffold(
      floatingActionButton: !showListDetails
          ? FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ListFormModal(); // Seu modal para adicionar lista
                  },
                );
              },
              backgroundColor: const Color(0xFFD81B60), // Ícone de "mais"
              tooltip: 'Adicionar nova lista', // Cor vibrante de destaque
              child: const Icon(Icons.add, color: Colors.white, size: 30),
            )
          : null,
      backgroundColor: Color.fromRGBO(255, 174, 201, 1),
      body: Builder(
        builder: (context) {
          if (listStore.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (listStore.error != null && listStore.error!.isNotEmpty) {
            return Center(child: Text(listStore.error!));
          }

          if (listStore.lists.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    'Nenhuma lista encontrada.',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ],
            );
          }
          final listsView = ListView.builder(
            itemCount: listStore.lists.length,
            itemBuilder: (context, index) {
              final listItem = listStore.lists[index];

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black, // Suaviza a sombra
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFC1E3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.star_border_rounded,
                      color: Color(0xFFD81B60),
                      size: 29,
                    ),
                  ),
                  title: Text(
                    listItem.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF212121),
                    ),
                  ),
                  subtitle: const Text(
                    "Toque para ver detalhes",
                    style: TextStyle(color: Color(0xFF757575), fontSize: 14),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xFFD81B60),
                    size: 18,
                  ),
                  onTap: () {
                    setState(() {
                      listId = listItem.id;
                      tvShows = listItem.tvShows;
                      showListDetails = true;
                    });
                  },
                ),
              );
            },
          );
          return showListDetails
              ? SeriesListPage(tvShows: tvShows, listId: listId)
              : listsView;
        },
      ),
    );
  }
}
