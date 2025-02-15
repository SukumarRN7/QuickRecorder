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
            VStack(spacing: 12) {
                Text("Screen Recorder")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)

                Button(action: {
                    if recorder.isRecording {
                       recorder.stopRecording()
                   } else {
                       print("🖥️ NSApplication.shared:", NSApplication.shared as Any)
                       recorder.startRecording();
                   }
                }) {
                    HStack {
                        Image(systemName: recorder.isRecording ? "stop.circle.fill" : "record.circle.fill")
                            .font(.system(size: 22))
                        Text(recorder.isRecording ? "Stop Recording" : "Start Recording")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(recorder.isRecording ? Color.red : Color.green)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
                }
                .buttonStyle(PlainButtonStyle())

                Divider()
                    .background(Color.white.opacity(0.2))

                Button(action: {
                    NSApplication.shared.terminate(nil)
                }) {
                    Text("Quit")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.8))
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding()
            .frame(width: 200)
            .background(BlurView())
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: Color.black.opacity(0.3), radius: 6, x: 0, y: 4)
            .padding(.horizontal, 8)
        }
}


// 💡 macOS-style blurred background
struct BlurView: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = .hudWindow
        view.blendingMode = .behindWindow
        view.state = .active
        return view
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
}
