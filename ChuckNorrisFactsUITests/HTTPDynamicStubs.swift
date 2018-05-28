//
//  HTTPDynamicStubs.swift
//  ChuckNorrisFactsUITests
//
//  Created by Munir Wanis on 29/05/18.
//  Copyright © 2018 Wanis. All rights reserved.
//

import Foundation
import Swifter

enum HTTPMethod {
    case POST
    case GET
}

class HTTPDynamicStubs {
    
    var server = HttpServer()
    
    func setUp() {
        setupInitialStubs()
        try! server.start()
    }
    
    func tearDown() {
        server.stop()
    }
    
    func setupInitialStubs() {
        // Setting up all the initial mocks from the array
        for stub in initialStubs {
            setupStub(url: stub.url, filename: stub.jsonFilename, method: stub.method)
        }
    }
    
    public func setupStub(url: String, filename: String, method: HTTPMethod = .GET) {
        let testBundle = Bundle(for: type(of: self))
        let filePath = testBundle.path(forResource: filename, ofType: "json")
        let fileUrl = URL(fileURLWithPath: filePath!)
        let data = try! Data(contentsOf: fileUrl, options: .uncached)
        // Looking for a file and converting it to JSON
        let json = dataToJSON(data: data)
        
        // Swifter makes it very easy to create stubbed responses
        let response: ((HttpRequest) -> HttpResponse) = { _ in
            if url.contains("correct") { return HttpResponse.ok(.json(json as AnyObject)) }
            if url.contains("wrong") { return HttpResponse.badRequest(.json(json as AnyObject)) }
            if url.contains("empty") { return HttpResponse.ok(.json(json as AnyObject)) }
            return HttpResponse.internalServerError
        }
        
        switch method  {
        case .GET : server.GET[url] = response
        case .POST: server.POST[url] = response
        }
    }
    
    func dataToJSON(data: Data) -> Any? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }
}

struct HTTPStubInfo {
    let url: String
    let jsonFilename: String
    let method: HTTPMethod
}

let initialStubs = [
    HTTPStubInfo(url: "/jokes/search?query=correct", jsonFilename: "json_correct", method: .GET),
    HTTPStubInfo(url: "/jokes/search?query=wrong", jsonFilename: "json_wrong", method: .GET),
    HTTPStubInfo(url: "/jokes/search?query=empty", jsonFilename: "json_empty", method: .GET),
]

