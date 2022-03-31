//
//  MusicTrackView.swift
//  iTunesSearcher
//
//  Created by 4mvideo it on 30/03/2022.
//

import SwiftUI

struct MusicTrackView: View {
    
    let music: MusicTrack
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 10) {
                AsyncImage(url: music.artwork){ image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: artworkForHalfWidth(geometry), height: artworkForHalfWidth(geometry))
                
                Text(music.artistName)
                Text(music.trackName)
                
                if let releaseDateString = music.trackReleaseDate() {
                    Text("From \(releaseDateString)")
                }
                
                // Present the description if available, otherwise inform the user
                if let desc = music.shortDescription {
                    Text(desc)
                } else {
                    Text("No description available for the track")
                }
                
                Spacer()
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
        }
    }
    
    private func artworkForHalfWidth(_ geometry: GeometryProxy) -> CGFloat {
        geometry.size.width / 2
    }
}
