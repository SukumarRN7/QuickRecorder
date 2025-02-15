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
    
    func applyTimeLapse(to inputURL: URL, speedMultiplier: Float, completion: @escaping (URL?) -> Void) {
        let asset = AVURLAsset(url: inputURL)
            let composition = AVMutableComposition()
            
            guard let videoTrack = asset.tracks(withMediaType: .video).first else {
                print("Error: No video track found")
                completion(nil)
                return
            }
            
            do {
                let videoCompositionTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
                try videoCompositionTrack?.insertTimeRange(CMTimeRange(start: .zero, duration: asset.duration), of: videoTrack, at: .zero)
                videoCompositionTrack?.scaleTimeRange(CMTimeRange(start: .zero, duration: asset.duration), toDuration: CMTimeMultiplyByFloat64(asset.duration, multiplier: 1.0 / Double(speedMultiplier)))
            } catch {
                print("Error modifying video: \(error.localizedDescription)")
                completion(nil)
                return
            }

            let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent("timelapse.mov")
            if FileManager.default.fileExists(atPath: outputURL.path) {
                try? FileManager.default.removeItem(at: outputURL)
            }

            let exportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality)
            exportSession?.outputURL = outputURL
            exportSession?.outputFileType = .mov
            exportSession?.exportAsynchronously {
                if exportSession?.status == .completed {
                    print("Timelapse video saved to: \(outputURL)")
                    completion(outputURL)
                } else {
                    print("Error exporting timelapse: \(exportSession?.error?.localizedDescription ?? "Unknown error")")
                    completion(nil)
                }
            }
        }
    
}
