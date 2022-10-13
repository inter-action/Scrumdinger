//
//  ScrumdingerApp.swift
//  Scrumdinger
//

//

import SwiftUI

@main
struct ScrumdingerApp: App {
    @State private var data = DailyScrum.sampleData
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ScrumsView(scrums: $data)
            }
        }
    }
}
