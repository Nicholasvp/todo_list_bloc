// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'package:todo_list_bloc/core/database/database_repository.dart';
import 'package:todo_list_bloc/modules/home/bloc/state/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(
    this.databaseRepository,
    super.initialState,
  );

  final DatabaseRepository databaseRepository;

  addItem() async {
    final items = state.items;
    final item = state.textEditingController.text;
    emit(HomeLoadingState(
      items: items,
      textEditingController: state.textEditingController,
    ));
    await Future.delayed(const Duration(milliseconds: 200));

    items.add(item);
    state.textEditingController.clear();
    emit(
      HomeLoadedState(
        items: items,
        textEditingController: state.textEditingController,
      ),
    );
  }

  deleteItem(int index) {
    final items = state.items;
    items.removeAt(index);
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
              onPressed: () {
                items[index] = textEditingController.text;
                emit(
                  HomeLoadedState(
                    items: items,
                    textEditingController: state.textEditingController,
                  ),
                );
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
