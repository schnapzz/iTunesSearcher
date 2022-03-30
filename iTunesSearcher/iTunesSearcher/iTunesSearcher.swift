//
//  Searcher.swift
//  iTunesSearcher
//
//  Created by 4mvideo it on 29/03/2022.
//

import Foundation

struct iTunesResponse: Codable {
    var resultCount: Int
    var results: [MusicTrack]
}

// The object that mirror the api
struct MusicTrack: Codable {
    private(set) var trackName: String?
    private var artworkUrl100: String?
    private(set) var artwork: URL?
    private(set) var artistName: String?
    private(set) var releaseDate: String?
    private(set) var shortDescription: String?
}

struct iTunesSearcher {
    private let baseStringUrl = "https://itunes.apple.com/search"
    
    func fetchForTerm(_ term: String, completionHandler: @escaping ([MusicTrack], Error?) -> Void ) {
        if let searchUrl = constructSearchURL(from: term) {
            let session = URLSession(configuration: .default)
            let dataTask = session.dataTask(with: searchUrl) { data, response, error in
                
                let response = response as? HTTPURLResponse
                if response?.statusCode == 200, let json = data {
                    let decoder = JSONDecoder()
                    completionHandler(try! decoder.decode(iTunesResponse.self, from: json).results, error)
                }
            }
            dataTask.resume()
        } else {
            completionHandler([], nil)
        }
    }
    
    private func constructSearchURL(from term: String) -> URL? {
        if var comp = URLComponents(string: baseStringUrl) {
            comp.query = "media=music&country=dk&term=" + term
            return comp.url
        }
        return nil
    }
}
