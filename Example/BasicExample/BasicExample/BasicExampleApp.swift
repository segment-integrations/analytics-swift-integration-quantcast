//
//  BasicExampleApp.swift
//  BasicExample
//
//  Created by Brandon Sneed on 2/23/22.
//

import SwiftUI
import Segment
import SegmentQuantcast

@main
struct BasicExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

extension Analytics {
    static var main: Analytics {
        let analytics = Analytics(configuration: Configuration(writeKey: "1Y90gFG3fBWv33PsE5piliJjF6xIOVmV")
                    .flushAt(3)
                    .trackApplicationLifecycleEvents(true))
        analytics.add(plugin: QuantcastDestination())
        return analytics
    }
}
