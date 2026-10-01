import UserNotifications

/// Downloads the image sent with a push (FCM `apns.fcm_options.image`, or the
/// `image` data key) and attaches it so iOS shows it in the notification.
/// Runs only when the payload has `mutable-content: 1`.
class NotificationService: UNNotificationServiceExtension {
  private var contentHandler: ((UNNotificationContent) -> Void)?
  private var bestAttemptContent: UNMutableNotificationContent?
  private var downloadTask: URLSessionDownloadTask?
  private let lock = NSLock()

  override func didReceive(
    _ request: UNNotificationRequest,
    withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void
  ) {
    self.contentHandler = contentHandler
    bestAttemptContent = request.content.mutableCopy() as? UNMutableNotificationContent

    guard let content = bestAttemptContent,
          let url = NotificationService.imageURL(from: content.userInfo) else {
      deliver()
      return
    }

    downloadTask = URLSession.shared.downloadTask(with: url) { [weak self] location, response, _ in
      if let location = location,
         let attachment = NotificationService.makeAttachment(
           from: location, url: url, mimeType: response?.mimeType) {
        content.attachments = [attachment]
      }
      self?.deliver()
    }
    downloadTask?.resume()
  }

  /// iOS gives the extension ~30s; show the text-only notification if the image is still loading.
  override func serviceExtensionTimeWillExpire() {
    downloadTask?.cancel()
    deliver()
  }

  /// Calls the content handler exactly once.
  private func deliver() {
    lock.lock()
    let handler = contentHandler
    contentHandler = nil
    lock.unlock()

    guard let handler = handler else { return }
    handler(bestAttemptContent ?? UNNotificationContent())
  }

  private static func imageURL(from userInfo: [AnyHashable: Any]) -> URL? {
    let fcmOptions = userInfo["fcm_options"] as? [String: Any]
    let raw = (fcmOptions?["image"] as? String) ?? (userInfo["image"] as? String)
    guard let raw = raw, let url = URL(string: raw), url.scheme?.lowercased() == "https" else {
      return nil
    }
    return url
  }

  /// iOS needs a file extension it recognises (jpg/png/gif) to render the attachment.
  private static func makeAttachment(from location: URL, url: URL, mimeType: String?) -> UNNotificationAttachment? {
    let ext: String
    switch mimeType?.lowercased() {
    case "image/png": ext = "png"
    case "image/gif": ext = "gif"
    case "image/jpeg", "image/jpg": ext = "jpg"
    default: ext = url.pathExtension.isEmpty ? "jpg" : url.pathExtension
    }

    let fileURL = FileManager.default.temporaryDirectory
      .appendingPathComponent(UUID().uuidString)
      .appendingPathExtension(ext)

    do {
      try FileManager.default.moveItem(at: location, to: fileURL)
      return try UNNotificationAttachment(identifier: "image", url: fileURL, options: nil)
    } catch {
      return nil
    }
  }
}
