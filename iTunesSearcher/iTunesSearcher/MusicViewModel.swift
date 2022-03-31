//
//  MusicViewModel.swift
//  iTunesSearcher
//
//  Created by 4mvideo it on 29/03/2022.
//

import SwiftUI

class MusicViewModel: ObservableObject {
    
    @Published var searchResults: [MusicTrack] = []
    
    // MARK: - Intents
    func search(for term: String) {
        
        iTunesSearcher().fetchMusicFromSearchTerm(term) { result, error in
            if let err = error {
                // TODO: Handle errors
            }
            DispatchQueue.main.async {
                self.searchResults = result
            }
        }
         
    }
}
