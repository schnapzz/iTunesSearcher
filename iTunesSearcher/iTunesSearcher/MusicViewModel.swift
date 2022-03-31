//
//  MusicViewModel.swift
//  iTunesSearcher
//
//  Created by 4mvideo it on 29/03/2022.
//

import SwiftUI

class MusicViewModel: ObservableObject {
    
    @Published var searchResults: [MusicTrack] = []
    @Published var errorOccured: Bool = false
    
    // MARK: - Intents
    func search(for term: String) {
        
        iTunesSearcher().fetchMusicFromSearchTerm(term) { result, error in
            if let _ = error {
                self.errorOccured = true
            }
            
            DispatchQueue.main.async {
                self.searchResults = result
            }
        }
         
    }
}
