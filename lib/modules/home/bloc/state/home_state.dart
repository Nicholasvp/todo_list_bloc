// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

abstract class HomeState {
  final List<String> items;
  final TextEditingController textEditingController;
  HomeState({
    required this.items,
    required this.textEditingController,
  });
}

class HomeInitialState extends HomeState {
  HomeInitialState() : super(items: [], textEditingController: TextEditingController());
}

class HomeLoadingState extends HomeState {
  HomeLoadingState({required super.items, required super.textEditingController});
}

class HomeLoadedState extends HomeState {
  HomeLoadedState({required super.items, required super.textEditingController});
}

class HomeErrorState extends HomeState {
  HomeErrorState({
    required this.message,
    required super.items,
    required super.textEditingController,
  });

  final String message;
}
