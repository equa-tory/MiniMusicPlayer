//
//  ContentView.swift
//  MiniMusicPlayer
//
//  Created by Alex Barauskas on 24.01.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var showMiniPlayer: Bool = false
    
    var body: some View {
        TabView{
            Tab.init("Home", systemImage: "house"){
                Text("Home")
            }
            Tab.init("Search", systemImage: "magnifyingglass"){
                Text("Search")
            }
            Tab.init("Notifications", systemImage: "bell"){
                Text("Notifications")
            }
            Tab.init("Settings", systemImage: "gearshape"){
                Text("Settings")
            }
        }
        .overlay{
            Group {
                if showMiniPlayer {
                    ExpandableMusicPlayer(show: $showMiniPlayer)
                }
            }
        }
        .onAppear{
            showMiniPlayer = true
        }
    }
}

#Preview {
    ContentView()
}
