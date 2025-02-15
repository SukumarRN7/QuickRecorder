import SwiftUI

struct ContentView: View {
    @StateObject private var recorder: ScreenRecorder = {
        #if os(macOS)
        return ScreenRecorder_macOS()
        #else
        return ScreenRecorder_iOS()
        #endif
    }()

    var body: some View {
        VStack {
            Text("Screen Recorder")
                .font(.largeTitle)
                .padding()

            Button(action: {
                if recorder.isRecording {
                    recorder.stopRecording()
                } else {
                    print("🖥️ NSApplication.shared:", NSApplication.shared as Any)
                    recorder.startRecording();
                }
            }) {
                Text(recorder.isRecording ? "Stop Recording" : "Start Recording")
                    .padding()
                    .background(recorder.isRecording ? Color.red : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            Button(action: {
                if let videoURL = recorder.lastRecordedVideo {
                    recorder.applyTimeLapse(to: videoURL, speedMultiplier: 2.0) { timelapseURL in
                        if let url = timelapseURL {
                            print("Timelapse saved at: \(url)")
                        }
                    }
                } else {
                    print("No recorded video found")
                }
            }) {
                Text("Apply TimeLapse")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}
