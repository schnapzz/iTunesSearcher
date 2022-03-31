//
//  ContentView.swift
//  iTunesSearcher
//
//  Created by 4mvideo it on 29/03/2022.
//

import SwiftUI

struct SearchView: View {
    
    @ObservedObject var musicSearcher = MusicViewModel()
    
    @State var showAlert = false
    @State var text: String = ""
    
    var body: some View {
        NavigationView {
            VStack (spacing: 5) {
                HStack {
                    TextField("Search your favorite music", text: $text)
                        .padding(10)
                        .padding(.horizontal, 10)
                        .background(Color.init(UIColor.systemGray5))
                        .cornerRadius(10)
                        .padding(.horizontal, 10)
                        
                    Button("Search") {
                        if text.count == 0 {
                            showAlert = true
                        } else {
                            musicSearcher.search(for: text)
                        }
                    }.alert("Important message", isPresented: $showAlert) {
                        Button("OK", role: .cancel) { }
                    }
                        
                }
                .padding(.horizontal, 10)
            
                List(musicSearcher.searchResults, id: \.trackName) { track in
                    NavigationLink {
                        MusicTrackView(music: track)
                    } label: {
                        SearchResultRow(music: track)
                    }
                }
            }
            .navigationTitle("iTunes API Test")
        }
    }
}

struct SearchResultRow: View {
    let music: MusicTrack
    
    var body: some View {
        HStack {
            if let artworkURL = music.artwork {
                AsyncImage(url: artworkURL)  { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 50, height: 50)
            }
            else {
                // In the event that there's no artwork available
                Image(systemName: "questionmark")
                    .frame(width: 50, height: 50)
            }
            
            VStack (alignment: .leading) {
                Text(music.trackName)
                    .fontWeight(.heavy)
                    .frame(width: 200, height: 30, alignment: .leading)
                Text(music.artistName)
                    .fontWeight(.light)
                    .frame(width: 200, height: 20, alignment: .leading)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
