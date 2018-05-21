//
//  Log.swift
//  ChuckNorrisFacts
//
//  Created by Munir Wanis on 21/05/18.
//  Copyright © 2018 Wanis. All rights reserved.
//

import Foundation

public class Log: NSObject {
    private static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .short
        return formatter
    }()
    
    private static var logDate: String {
        return dateFormatter.string(from: Date())
    }
    
    public static func api(_ data: Data) {
        message("Payload")
        logJson(data: data)
    }
    
    public static func message(_ message: String?) {
        guard let message = message else { return }
        log(message: "[\(applicationName) - \(logDate)] \(message)")
    }
    
    public static func message(_ error: Error) {
        message("An error occurred")
        log(message: error)
    }
}

// MARK: - Private methods

extension Log {
    private static func logJson(data: Data) {
        guard let jsonData = try? JSONSerialization.jsonObject(with: data),
            let prettyJSON = try? JSONSerialization.data(withJSONObject: jsonData, options: .prettyPrinted) else {
            return
        }
        let jsonString = String(data: prettyJSON, encoding: .utf8)
        log(message: jsonString ?? "")
    }
    
    private static func log(message: Any) {
        #if !RELEASE
        print(message)
        #endif
    }
}
