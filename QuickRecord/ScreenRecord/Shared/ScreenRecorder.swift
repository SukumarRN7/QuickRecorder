import SwiftUI
import AVFoundation

class ScreenRecorder: NSObject,ObservableObject {
    @Published var isRecording = false
    @Published var lastRecordedVideo: URL?
    
    func startRecording() {
        fatalError("startRecording() must be implemented in platform-specific files.")
    }
    
    func stopRecording() {
        fatalError("stopRecording() must be implemented in platform-specific files.")
    }
    
}
