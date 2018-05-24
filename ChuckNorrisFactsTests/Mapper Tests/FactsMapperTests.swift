//
//  FactsMapperTests.swift
//  ChuckNorrisFactsTests
//
//  Created by Munir Wanis on 23/05/18.
//  Copyright © 2018 Wanis. All rights reserved.
//

@testable import ChuckNorrisFacts
import Foundation
import Nimble
import Quick

class FactsMapperTests: QuickSpec {
    override func spec() {
        describe("factsMapper") {
            let map: FactsMapperProtocol = FactsMapper()
            
            context("when map fails") {
                it("should throw parse error") {
                    let payload: Data = """
                    { "random": "json" }
                    """.data(using: .utf8)!
                    
                    var cnError: Error?
                    
                    do {
                        _ = try map.facts(from: payload)
                    } catch {
                        cnError = error
                    }
                    
                    expect(cnError as? CNError).to(equal(CNError.parsePayloadError))
                }
            }
            
            context("when map is empty") {
                it("should be empty") {
                    let payload: Data = """
                    {
                        \"total\": 0,
                        \"result\": []
                    }
                    """.data(using: .utf8)!

                    
                    var facts: Facts?
                    var mapError: Error?
                    
                    do {
                        facts = try map.facts(from: payload)
                    } catch {
                        mapError = error
                    }
                    
                    expect(mapError).to(beNil())
                    expect(facts).to(beEmpty())
                }
            }
            
            context("when map has elements") {
                it("should be with elements") {
                    let payload: Data = """
                    {
                        \"total\": 2,
                        \"result\": [
                            {
                                \"category\": null,
                                \"icon_url\": \"https://assets.chucknorris.host/img/avatar/chuck-norris.png\",
                                \"id\": \"HFoFixVCQCKJNqPkAoUNkg\",
                                \"url\": \"https://api.chucknorris.io/jokes/HFoFixVCQCKJNqPkAoUNkg\",
                                \"value\": \"Calvin Klein always used to wear Chuck Norris\\u0027 discarded slacks.\"
                            },
                            {
                                \"category\": null,
                                \"icon_url\": \"https://assets.chucknorris.host/img/avatar/chuck-norris.png\",
                                \"id\": \"qJ9lipf0RFeWLTNGNbwCBg\",
                                \"url\": \"https://api.chucknorris.io/jokes/qJ9lipf0RFeWLTNGNbwCBg\",
                                \"value\": \"The jokes are slacking, Chuck will Virtually Roundhouse your asses!\"
                            }
                        ]
                    }
                    """.data(using: .utf8)!
                    
                    var facts: Facts?
                    var mapError: Error?
                    
                    do {
                        facts = try map.facts(from: payload)
                    } catch {
                        mapError = error
                    }
                    
                    expect(mapError).to(beNil())
                    expect(facts != nil).to(beTruthy())
                    expect(facts!.count > 0).to(beTruthy())
                    
                    let containID = facts?.contains(where: { fact in
                        return fact.id == "HFoFixVCQCKJNqPkAoUNkg"
                    })
                    expect(containID).to(beTruthy())
                }
            }
        }
    }
}
