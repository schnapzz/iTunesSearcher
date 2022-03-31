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
    
    let itunesSearcher: iTunesSearcher = iTunesSearcher()
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
        
        itunesSearcher.fetchMusicFromSearchTerm(validTermJJ) { result, _ in
            self.result = result
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: SHORT_TIMEOUT, handler: nil)
        
        XCTAssertNotNil(result)
    }
    
    func testValidSearchTermReturnsListOfTracks() throws {
        let expectation = self.expectation(description: "iTunesSearcher returns a list of somethings")
        
        itunesSearcher.fetchMusicFromSearchTerm(validTermJJ) { result, _ in
            self.result = result
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: SHORT_TIMEOUT, handler: nil)
        
        XCTAssertTrue(result!.count > 0)
    }
    
    func testFetchingMusicTrackDataFromArtist() throws {
        let expectation = self.expectation(description: "iTunesSearcher returns a list of Music Tracks")
        
        itunesSearcher.fetchMusicFromSearchTerm(validTermJJ) { result, _ in
            self.result = result
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: SHORT_TIMEOUT, handler: nil)
        
        let track = result![0]
        
        XCTAssertNotNil(track.artistName)
        XCTAssert(track.artistName == self.validTermJJ)
        XCTAssertNotNil(track.trackName)
        XCTAssertNotNil(track.releaseDate)
        XCTAssertNil(track.shortDescription)
    }
    
    func testDifferentSearchesYieldsDifferentResults() {
        let expectationJJ = self.expectation(description: "iTunesSearcher returns a list of Music Tracks from \(validTermJJ)")
        let expectationBPF = self.expectation(description: "iTunesSearcher returns a list of Music Tracks from \(validTermBPF)")
        var resultBPF: [MusicTrack]?
        
        itunesSearcher.fetchMusicFromSearchTerm(validTermJJ) { result, _ in
            self.result = result
            expectationJJ.fulfill()
        }
        
        itunesSearcher.fetchMusicFromSearchTerm(validTermBPF) { result, _ in
            resultBPF = result
            expectationBPF.fulfill()
        }
        
        waitForExpectations(timeout: SHORT_TIMEOUT, handler: nil)
        
        let trackJJ = result![0]
        let trackBPF = resultBPF![0]
        
        XCTAssertNotEqual(trackJJ.artistName, trackBPF.artistName)
    }
    
    func testInvalidSearchReturnsEmpty() {
        let expectation = self.expectation(description: "iTunesSearch returns an empty list from noneexisting match")
        itunesSearcher.fetchMusicFromSearchTerm(invalidTerm) { result, _ in
            self.result = result
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: SHORT_TIMEOUT, handler: nil)
        
        XCTAssert(result!.count == 0)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
