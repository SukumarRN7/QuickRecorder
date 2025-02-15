import SwiftUI

@main
struct QuickRecordApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            EmptyView() // No main window, only menu bar
        }
    }
}
