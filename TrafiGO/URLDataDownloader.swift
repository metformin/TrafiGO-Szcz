//
//  URLDataDownloader.swift
//  TrafiGO
//
//  Created by Darek on 18/09/2021.
//

import Foundation
import WebKit
import SwiftSoup
import Combine


class BusStopInfoDownloader: NSObject, WKNavigationDelegate {
    
    var web = WKWebView()
    var subscriptions = Set<AnyCancellable>()
    let url = "https://www.zditm.szczecin.pl/s"
    let timeTable = PassthroughSubject<[[String]],Error>()
    override init() {
        super.init()
        web.navigationDelegate = self
    }

    func downloadInfoAboutSpecificBusStop(stopID:Int){
        let stopURL = URL(string: url + String(stopID))
        print("DEBUG: Stop URL: \(stopURL)(2)")
       
        let request = URLRequest(url: stopURL!)
        web.load(request)
    }
    
    func getHTML() -> Future<String,Error> {
        Future { promise in
//            let jsCode = "document.getElementsByTagName(\"tbody\")[0].outerHTML"
            let jsCode = "document.getElementsByTagName(\"table\")[0].outerHTML"

            print(jsCode)
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                self.web.evaluateJavaScript(jsCode) {(result, error) in
                    if error != nil {
                        print(error ?? "Error with evaluate JS")
                    }
                    guard let htmlString = result as? String else {
                        return
                    }
                    promise(.success(htmlString.replacingOccurrences(of: "&nbsp;", with: " ")))
                }
            }
        }
        
    }
    
    func htmlParse(htmlString: String){
        var tableContent = [[String]]()
        
        do {
            let doc: Document = try SwiftSoup.parse(htmlString)
            let tbody = try doc.select("tbody")
            for row in try tbody.select("tr") {
                var rowContent = [String]()
                for col in try row.select("td") {
                    let colContent = try col.text()
                    rowContent.append(colContent)
                }
                tableContent.append(rowContent)
            }
        } catch Exception.Error(_, let message) {
            print("ERR: \(message)")
        } catch {
            print("error")
        }
        print("DEBUG: Table: \(tableContent)(6)")
        timeTable.send(tableContent)
        print("DEBUG: -------------")
    }
    
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("DEBUG: Started to load)")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        print("DEBUG: Finished loading")
        getHTML()
            .sink { complition in
                switch complition{
                case .finished: print("")
                case .failure: print ("DEBUG: Finished with errors")
                }
            } receiveValue: {[weak self] htmlString in
                self?.htmlParse(htmlString: htmlString)
            }
            .store(in: &subscriptions)
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }

}

