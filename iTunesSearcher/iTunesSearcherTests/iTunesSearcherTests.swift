//
//  iTunesSearcherTests.swift
//  iTunesSearcherTests
//
//  Created by 4mvideo it on 29/03/2022.
//

import XCTest
@testable import iTunesSearcher

class iTunesSearcherTests: XCTestCase {
    private let SHORT_TIMEOUT: TimeInterval = 5 // 5 sec
    
    let searcher: iTunesSearcher = iTunesSearcher()
    let validTermJJ = "Jack Johnson"
    let validTermBPF = "Black Pistol Fire"
    let invalidTerm = "podaviemdaevqakdoeva4uoaidnev"
    
    var result: [MusicTrack]?
    var error: Error?

    override func tearDownWithError() throws {
        result = nil
        error = nil
    }
    
    func testShouldReturnSomeContent() throws {
        let expectation = self.expectation(description: "iTunesSearcher returns something")
        
        searcher.fetchForTerm(validTermJJ) { result, error in
            self.result = result
            self.error = error
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: SHORT_TIMEOUT, handler: nil)
        
        XCTAssertNotNil(result)
        XCTAssertNil(error)
    }
    
    func testValidSearchTermReturnsListOfTracks() throws {
        let expectation = self.expectation(description: "iTunesSearcher returns a list of somethings")
        
        searcher.fetchForTerm(validTermJJ) { result, error in
            self.result = result
            self.error = error
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: SHORT_TIMEOUT, handler: nil)
        
        XCTAssertTrue(result!.count > 0)
        XCTAssertNil(error)
    }
    
    func testFetchingMusicTrackDataFromArtist() throws {
        let expectation = self.expectation(description: "iTunesSearcher returns a list of Music Tracks")
        
        searcher.fetchForTerm(validTermJJ) { result, error in
            self.result = result
            self.error = error
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: SHORT_TIMEOUT, handler: nil)
        
        let track = result![0]
        
        XCTAssertNotNil(track.artistName)
        XCTAssert(track.artistName == self.validTermJJ)
        XCTAssertNotNil(track.trackName)
        XCTAssertNotNil(track.releaseDate)
        XCTAssertNil(track.shortDescription)
        XCTAssertNil(error)
    }
    
    func testDifferentSearchesYieldsDifferentResults() {
        let expectationJJ = self.expectation(description: "iTunesSearcher returns a list of Music Tracks from \(validTermJJ)")
        let expectationBPF = self.expectation(description: "iTunesSearcher returns a list of Music Tracks from \(validTermBPF)")
        var resultBPF: [MusicTrack]?
        var errorBPF: Error?
        
        searcher.fetchForTerm(validTermJJ) { result, error in
            self.result = result
            self.error = error
            
            expectationJJ.fulfill()
        }
        
        searcher.fetchForTerm(validTermBPF) { result, error in
            resultBPF = result
            errorBPF = error
            
            expectationBPF.fulfill()
        }
        
        waitForExpectations(timeout: SHORT_TIMEOUT, handler: nil)
        
        XCTAssertNil(self.error)
        XCTAssertNil(errorBPF)
        
        let trackJJ = result![0]
        let trackBPF = resultBPF![0]
        
        XCTAssertNotEqual(trackJJ.artistName, trackBPF.artistName)
    }
    
    func testInvalidSearchReturnsEmpty() {
        let expectation = self.expectation(description: "iTunesSearch returns an empty list from noneexisting match")
        searcher.fetchForTerm(invalidTerm) { result, error in
            self.result = result
            self.error = error
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: SHORT_TIMEOUT, handler: nil)
        
        XCTAssert(result!.count == 0)
        XCTAssertNil(error)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
