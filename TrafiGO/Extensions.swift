//
//  Extensions.swift
//  TrafiGO
//
//  Created by Darek on 15/09/2021.
//

import Foundation
import MapKit
import WebKit

extension MKMapView {
  func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 10000
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}
extension WKWebView {
    func waitUntilFullyLoaded(script: String, completionHandler: @escaping (String) -> Void) {
        let webView = WKWebView()

        webView.evaluateJavaScript("document.readyState === 'complete'") { (evaluation, _) in
            if let fullyLoaded = evaluation as? Bool {
                if !fullyLoaded {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        self.waitUntilFullyLoaded(script: script) { String in
                            print("Webview not fully loaded yet...")
                        }
                    })
                } else {
                    print("Webview fully loaded!")
                    completionHandler(evaluation as! String)
                }
            }
        }
    }
}
