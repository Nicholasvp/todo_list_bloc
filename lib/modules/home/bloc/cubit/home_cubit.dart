// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'package:todo_list_bloc/core/database/database_repository.dart';
import 'package:todo_list_bloc/modules/home/bloc/state/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required this.databaseRepository,
  }) : super(
          HomeInitialState(),
        );

  final DatabaseRepository databaseRepository;

  Future<void> loadData() async {
    final items = await databaseRepository.loadData();
    if (items.isEmpty) {
      emit(
        HomeInitialState(),
      );
      return;
    }
    emit(
      HomeLoadedState(
        items: items,
        textEditingController: state.textEditingController,
      ),
    );
  }

  addItem() async {
    final items = state.items;
    items.add(state.textEditingController.text);
    emit(
      HomeLoadedState(
        items: items,
        textEditingController: state.textEditingController,
      ),
    );
    await databaseRepository.saveData(items);
  }

  deleteItem(int index) async {
    final items = state.items;
    items.removeAt(index);
    await databaseRepository.saveData(items);
    if (items.isEmpty) {
      emit(
        HomeInitialState(),
      );
      return;
    }
    emit(
      HomeLoadedState(
        items: items,
        textEditingController: state.textEditingController,
      ),
    );
  }

  void editItem(BuildContext context, int index) async {
    final items = state.items;
    final item = items[index];
    showDialog(
      context: context,
      builder: (context) {
        final textEditingController = TextEditingController(text: item);
        return AlertDialog(
          title: const Text('Edit Item'),
          content: TextField(
            controller: textEditingController,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                items[index] = textEditingController.text;
                await databaseRepository.saveData(items);
                emit(
                  HomeLoadedState(
                    items: items,
                    textEditingController: state.textEditingController,
                  ),
                );
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
