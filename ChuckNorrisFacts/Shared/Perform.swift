//
//  Do.swift
//  ChuckNorrisFacts
//
//  Created by Munir Wanis on 21/05/18.
//  Copyright © 2018 Wanis. All rights reserved.
//

import Foundation

struct Perform {
    
    static func wait(seconds: Double, completion: @escaping () -> Void) {
        let time = DispatchTime.now() + seconds
        
        DispatchQueue.main.asyncAfter(deadline: time) {
            completion()
        }
    }
    
    static func now(completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            completion()
        }
    }
}
