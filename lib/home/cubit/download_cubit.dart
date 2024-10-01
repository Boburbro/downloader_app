import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

part 'download_state.dart';

class DownloadCubit extends Cubit<DownloadState> {
  DownloadCubit() : super(DownloadInitial());

  Future<void> download(String url) async {
    // return;
    emit(DownloadLoading(progress: 0.0));
    bool hasPermission = await requestWritePermission();

    if (!hasPermission) {
      emit(DownloadFailed(message: "NO PERMISSION"));
      return;
    }

    final directory = (await getApplicationDocumentsDirectory()).path;
    final initialfileName = url.split('/').last;
    var fileName = url.split('/').last;
    int n = 0;
    while (await checkFileExists(fileName)) {
      n++;
      fileName =
          "${initialfileName.split(".").first}($n).${initialfileName.split(".").last}";
    }
    final filePath = "$directory/$fileName";
    final request = http.Request("GET", Uri.parse(url));
    final response = await request.send();

    final file = File(filePath);
    final fileStream = file.openWrite();
    final contentLength = response.contentLength ?? 0;
    // ignore: non_constant_identifier_names
    double download_bytes = 0;

    response.stream.listen(
      (value) {
        download_bytes += value.length;
        fileStream.add(value);
        emit(DownloadLoading(progress: (download_bytes / contentLength) * 100));
      },
      onDone: () {
        fileStream.close();
        emit(DownloadLoaded(path: filePath));
      },
      onError: (error) {
        fileStream.close();
        emit(DownloadFailed(message: "DOWNLOAD FAILED: $error"));
      },
    );

    await Future.delayed(const Duration(seconds: 4));
    emit(DownloadInitial());
  }

  static Future<bool> requestWritePermission() async {
    final info = await DeviceInfoPlugin().androidInfo;
    if (Platform.isAndroid && info.version.sdkInt > 29) {
      await Permission.manageExternalStorage.request();
    } else {
      await Permission.storage.request();
    }

    await Permission.storage.request();
    return await Permission.storage.request().isGranted;
  }

  Future<bool> checkFileExists(String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);

      if (await file.exists()) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }
}
