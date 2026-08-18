enum DownloadStage { none, downloading, downloaded, failed }

/// Tracks one material's local download state so the list can show a
/// download icon, a progress ring, or an "open" icon per row.
class MaterialDownloadStatus {
  final DownloadStage stage;

  /// 0..1 while [stage] is `downloading`; meaningless otherwise.
  final double progress;

  /// Set once [stage] is `downloaded` — the file's path on disk.
  final String? localPath;
  final String? error;

  const MaterialDownloadStatus.none()
      : stage = DownloadStage.none,
        progress = 0,
        localPath = null,
        error = null;

  const MaterialDownloadStatus.downloading(this.progress)
      : stage = DownloadStage.downloading,
        localPath = null,
        error = null;

  const MaterialDownloadStatus.downloaded(this.localPath)
      : stage = DownloadStage.downloaded,
        progress = 1,
        error = null;

  const MaterialDownloadStatus.failed(this.error)
      : stage = DownloadStage.failed,
        progress = 0,
        localPath = null;
}
