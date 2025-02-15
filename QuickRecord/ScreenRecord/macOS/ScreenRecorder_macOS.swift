#if os(macOS)
import SwiftUI
import AVFoundation


class ScreenRecorder_macOS: ScreenRecorder, AVCaptureFileOutputRecordingDelegate {
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: (any Error)?) {
        if let error = error {
                    print("❌ Recording finished with error: \(error.localizedDescription)")
                } else {
                    print("✅ Recording successfully saved to: \(outputFileURL.path)")
                }
    }
    
    private var session: AVCaptureSession?
    private var output: AVCaptureMovieFileOutput?
    private var recordingURL: URL?
    
    private func getTemporaryRecordingURL() -> URL? {
        let downloadsDir = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!
        return downloadsDir.appendingPathComponent("screenRecording.mov")
    }
    
    private func moveRecording(to saveURL: URL) {
           guard let recordingURL = self.recordingURL else {
               print("❌ No recorded file available.")
               return
           }

           do {
               try FileManager.default.moveItem(at: recordingURL, to: saveURL)
               print("✅ Recording saved at:", saveURL.path)
           } catch {
               print("❌ Failed to save recording:", error.localizedDescription)
           }
       }

    override func startRecording() {
        let session = AVCaptureSession()
        self.session = session
        session.sessionPreset = .high

        guard let screenInput = AVCaptureScreenInput(displayID: CGMainDisplayID()) else {
            print("❌ Error: Could not get screen input")
            return
        }

        if session.canAddInput(screenInput) {
            session.addInput(screenInput)
        } else {
            print("❌ Error: Could not add screen input")
            return
        }

        let output = AVCaptureMovieFileOutput()
        output.movieFragmentInterval = .invalid  // Disable fragmented recording
        
        if session.canAddOutput(output) {
            session.addOutput(output)
            self.output = output
        } else {
            print("❌ Error: Could not add movie file output")
            return
        }
        session.sessionPreset = .high
        session.commitConfiguration()
        session.startRunning()

        guard let tempURL = getTemporaryRecordingURL() else {
            print("❌ Failed to create temporary file URL")
            return
        }

        print("📂 Saving recording to:", tempURL.path)

        output.startRecording(to: tempURL, recordingDelegate: self)

        DispatchQueue.main.async {
            self.isRecording = true
        }
    }

    override func stopRecording() {
        output?.stopRecording()
        session?.stopRunning()

        DispatchQueue.main.async {
            self.isRecording = false
            FilePicker.showSavePanel { saveURL in
                if let url = saveURL {
                    self.moveRecording(to: url)
                } else {
                    print("❌ User canceled file save")
                }
            }
        }
    }
}

class RecordingDelegate: NSObject, AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print("Error recording: \(error.localizedDescription)")
        } else {
            print("Recording saved at: \(outputFileURL)")
        }
    }
}
#endif
