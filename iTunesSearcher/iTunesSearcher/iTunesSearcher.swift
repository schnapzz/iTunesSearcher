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
    private(set) var trackName: String
    private var artworkUrl100: String?
    var artwork: URL? {
        get {
            if let artworkUrl100 = artworkUrl100 {
                return URL(string: artworkUrl100)
            }
            return nil
        }
    }
    private(set) var artistName: String
    private var releaseDate: String
    private(set) var shortDescription: String?
    
    func trackReleaseDate() -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.locale = Locale(identifier: "da_DK")
        if let date = formatter.date(from: releaseDate) {
            let str = date.formatted(date: .numeric, time: .omitted)
            return str
        }
        return nil
    }
}

struct iTunesSearcher {
    
    private let SUCCESFUL_RESPONSE = 200
    private let baseStringUrl = "https://itunes.apple.com/search"
    
    func fetchMusicFromSearchTerm(_ term: String, completionHandler: @escaping ([MusicTrack], Error?) -> Void ) {
        if let searchUrl = constructSearchURL(from: term) {
            let session = URLSession(configuration: .default)
            let dataTask = session.dataTask(with: searchUrl) { data, response, error in

                let response = response as? HTTPURLResponse
                if response?.statusCode == SUCCESFUL_RESPONSE, let json = data {
                    let decoder = JSONDecoder()
                    let itunesResponse = try! decoder.decode(iTunesResponse.self, from: json)
                    completionHandler(itunesResponse.results, error)
                } else {
                    completionHandler([], error)
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
