#if os(iOS)
import SwiftUI
import ReplayKit
import UIKit

class ScreenRecorder_iOS: ScreenRecorder {
    private let recorder = RPScreenRecorder.shared()

    override func startRecording() {
        recorder.startRecording { error in
            if let error = error {
                print("Error starting recording: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    self.isRecording = true
                }
            }
        }
    }

    override func stopRecording() {
        recorder.stopRecording { previewController, error in
            if let error = error {
                print("Error stopping recording: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    self.isRecording = false
                    self.lastRecordedVideo = FileManager.default.temporaryDirectory.appendingPathComponent("screenRecording.mov") // ✅ Store recorded file
                }
            }
        }
    }
}
#endif
