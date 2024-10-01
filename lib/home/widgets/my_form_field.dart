import 'package:downloader_app/home/cubit/download_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyFormField extends StatefulWidget {
  const MyFormField({super.key});

  @override
  State<MyFormField> createState() => _MyFormFieldState();
}

class _MyFormFieldState extends State<MyFormField> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text("Enter URL"),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              BlocBuilder<DownloadCubit, DownloadState>(builder: (ctx, state) {
                if (state is DownloadLoading) {
                  return FilledButton(
                    onPressed: null,
                    child: Text(state.progress.toStringAsFixed(1)),
                  );
                }
                return FilledButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    context.read<DownloadCubit>().download(controller.text);
                  },
                  child: const Text("DOWNLOAD"),
                );
              }),
            ],
          )
        ],
      ),
    );
  }
}
