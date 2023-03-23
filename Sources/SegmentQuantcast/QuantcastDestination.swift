//
//  QuantcastDestination.swift
//  QuantcastDestination
// This plugin is NOT SUPPORTED by Segment.  It is here merely as an example,
// and for your convenience should you find it useful.
//

// MIT License
//
// Copyright (c) 2021 Segment
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation
import Segment
import QuantcastSPM

public class QuantcastDestination: DestinationPlugin {
    public let timeline = Timeline()
    public let type = PluginType.destination
    public let key = "Quantcast"
    public var analytics: Analytics? = nil
    
    private var quantcastSettings: QuantcastSettings?
    private var quantcastInstance: QuantcastMeasurement!
        
    public init() { }

    public func update(settings: Settings, type: UpdateType) {
        // Skip if you have a singleton and don't want to keep updating via settings.
        guard type == .initial else { return }
        
        // Grab the settings and assign them for potential later usage.
        // Note: Since integrationSettings is generic, strongly type the variable.
        guard let tempSettings: QuantcastSettings = settings.integrationSettings(forPlugin: self) else { return }
        quantcastSettings = tempSettings
        quantcastInstance = QuantcastSPM.QuantcastMeasurement.sharedInstance()
        quantcastInstance.enableLogging = true
        if !quantcastInstance.isMeasurementActive {
            quantcastInstance.setupMeasurementSession(withAPIKey: tempSettings.apiKey, userIdentifier: nil, labels: nil)
        }
        
    }
    
    public func identify(event: IdentifyEvent) -> IdentifyEvent? {
        
        if let userID = event.userId {
            quantcastInstance.recordUserIdentifier(userID, withLabels: nil)
        }
        
        return event
    }
    
    public func track(event: TrackEvent) -> TrackEvent? {
                    
        quantcastInstance.logEvent(event.event, withLabels: nil)
        
        return event
    }
    
    public func screen(event: ScreenEvent) -> ScreenEvent? {
        
        let screenEvent = "Viewed" + (event.name ?? "") + "Screen"
        
        quantcastInstance.logEvent(screenEvent, withLabels: nil)
        
        return event
    }
}

extension QuantcastDestination: VersionedPlugin {
    public static func version() -> String {
        return __destination_version
    }
}

private struct QuantcastSettings: Codable {
    let apiKey: String
}

