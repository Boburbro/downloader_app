part of 'download_cubit.dart';

@immutable
sealed class DownloadState {}

final class DownloadInitial extends DownloadState {}

final class DownloadLoading extends DownloadState {
  final double progress;
  DownloadLoading({required this.progress});
}

final class DownloadLoaded extends DownloadState {
  final String path;
  DownloadLoaded({required this.path});
}

final class DownloadFailed extends DownloadState {
  final String message;
  DownloadFailed({required this.message});
}
