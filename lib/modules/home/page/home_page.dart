import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_bloc/modules/home/bloc/cubit/home_cubit.dart';
import 'package:todo_list_bloc/modules/home/bloc/state/home_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    final cubit = BlocProvider.of<HomeCubit>(context);
    cubit.loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<HomeCubit>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Column(
        children: [
          const Text(
            'Todo List',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          BlocBuilder<HomeCubit, HomeState>(
            bloc: cubit,
            builder: (context, state) {
              if (state is HomeLoadedState || state is HomeLoadingState) {
                return Expanded(
                  child: ListView.separated(
                    itemCount: state.items.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(state.items[index]),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                cubit.editItem(context, index);
                              },
                              icon: const Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () {
                                cubit.deleteItem(index);
                              },
                              icon: const Icon(Icons.done),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }
              return const Expanded(
                child: Center(
                  child: Text('Nenhum item encontrado'),
                ),
              );
            },
          ),
          const SizedBox(height: 80),
        ],
      ),
      bottomSheet: BlocBuilder<HomeCubit, HomeState>(
        bloc: cubit,
        builder: (context, state) {
          return Container(
            margin: const EdgeInsets.all(32),
            child: TextFormField(
              controller: state.textEditingController,
              decoration: InputDecoration(
                labelText: 'Item',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    cubit.addItem();
                  },
                  icon: state is HomeLoadingState ? const CircularProgressIndicator() : const Icon(Icons.add),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
