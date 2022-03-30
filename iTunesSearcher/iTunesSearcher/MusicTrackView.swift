//
//  MusicTrackView.swift
//  iTunesSearcher
//
//  Created by 4mvideo it on 30/03/2022.
//

import SwiftUI

struct MusicTrackView: View {
    
    let musicTrack: MusicTrack
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            AsyncImage(url: musicTrack.artwork){ image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 200, height: 200)
            
            Text(musicTrack.artistName)
            Text(musicTrack.trackName)
            
            if let releaseDateString = musicTrack.trackReleaseDate() {
                Text("From \(releaseDateString)")
            }
            
            if let desc = musicTrack.shortDescription {
                Text(desc)
            } else {
                Text("No description available for the track")
            }
            
            Spacer()
        }
    }
}
