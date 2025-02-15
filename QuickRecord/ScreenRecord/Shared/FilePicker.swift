import SwiftUI
import AppKit

struct FilePicker {
    static func showSavePanel(completion: @escaping (URL?) -> Void) {
        DispatchQueue.main.async {  // Ensure it's on the main thread
            guard let window = NSApplication.shared.keyWindow ?? NSApplication.shared.windows.first else {
                print("❌ No valid NSWindow found!")
                completion(nil)
                return
            }

            let savePanel = NSSavePanel()
            savePanel.title = "Save Screen Recording"
            savePanel.nameFieldStringValue = "screenRecording.mov"
            savePanel.allowedFileTypes = ["mov"]
            savePanel.canCreateDirectories = true

            savePanel.beginSheetModal(for: window) { response in
                if response == .OK {
                    completion(savePanel.url)
                } else {
                    completion(nil)
                }
            }
        }
    }
}
