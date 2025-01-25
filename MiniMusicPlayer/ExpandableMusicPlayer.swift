//
//  ExpandableMusicPlayer.swift
//  MiniMusicPlayer
//
//  Created by Alex Barauskas on 24.01.2025.
//

import SwiftUI

struct ExpandableMusicPlayer: View {
    @Binding var show: Bool
    /// View Properties
    @State private var expandPlayer: Bool = false
    @State private var offsetY: CGFloat = 0
    @Namespace private var animation
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        GeometryReader{
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            
            ZStack(alignment: .top){
                /// Background
                ZStack {
                    Rectangle()
                        .fill(colorScheme == .dark ? .black : .white)
                    
                    Rectangle()
                        .fill(.linearGradient(colors: [.artwork1,.artwork2,], startPoint: .top, endPoint: .bottom))
                        .opacity(expandPlayer ? 1 : 0)
                }
                .clipShape(.rect(cornerRadius: expandPlayer ? 45 : 15))
                .frame(height: expandPlayer ? nil : 55)
                
                /// Shadows
                .shadow(color: colorScheme == .dark ? .white.opacity(0.06) : .black.opacity(0.06), radius: 5, x: 5, y: 5)
                .shadow(color: colorScheme == .dark ? .white.opacity(0.05) : .black.opacity(0.05), radius: -5, x: -5, y: -5)
                
                MiniPlayer()
                    .opacity(expandPlayer ? 0 : 1)
                
                ExpandedPlayer(size, safeArea)
                    .opacity(expandPlayer ? 1 : 0)
            }
            .frame(height: expandPlayer ? nil : 0, alignment: .top)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, expandPlayer ? 0 : safeArea.bottom + 55)
            .padding(.horizontal, expandPlayer ? 0 : 15)
            .offset(y: offsetY)
            .gesture(
                PanGesture { value in
                    guard expandPlayer else { return }
                    let translation = max(value.translation.height, 0)
                    offsetY = translation
                } onEnd: { value in
                    guard expandPlayer else { return }
                    let translation = max(value.translation.height, 0)
                    let velocity = value.velocity.height / 5
                    
                    withAnimation(.smooth(duration: 0.3, extraBounce: 0)) {
                        if (translation + velocity) > (size.height * 0.5) {
                            /// Closing View
                            expandPlayer = false
                        }
                        offsetY = 0
                    }
                }
            )
            .ignoresSafeArea()
        }
    }
    
    // Mini Player
    @ViewBuilder
    func MiniPlayer() -> some View {
        HStack(spacing:12){
            
            Button("", systemImage: "xmark"){
                show = false
            }
            .aspectRatio(contentMode: .fill)
            .frame(width: 25, height: 25)
            .foregroundStyle(colorScheme == .dark ? .white : .black)
    
            ZStack {
                if !expandPlayer {
                    Image(.album)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(.rect(cornerRadius: 10))
                        .matchedGeometryEffect(id: "Artwork", in: animation)
                }
            }
            .frame(width: 45, height: 45)
            
            Text("Persona 3")
                .foregroundStyle(colorScheme == .dark ? .white : .black)
            
            Spacer(minLength: 0)
            
            Group {
                Button("", systemImage: "play.fill") {
                    
                }
                Button("", systemImage: "forward.fill") {
                    
                }
            }
            .font(.title3)
            .foregroundStyle(colorScheme == .dark ? .white : .black)
        }
        .padding(.horizontal, 10)
        .frame(height: 55)
        .contentShape(.rect)
        .onTapGesture {
            withAnimation(.smooth(duration: 0.3, extraBounce: 0)) {
                expandPlayer = true
            }
        }
//        .swipeActions {
//            Button(role: .destructive) {
////                removeSong(song: song)
//            } label: {
//                Label("Delete", systemImage: "trash")
//            }
//        }
    }
    
    /// Expanded Player
    @ViewBuilder
    func ExpandedPlayer(_ size: CGSize, _ safeArea: EdgeInsets) -> some View {
        VStack(spacing: 12) {
            Capsule()
                .fill(.white.secondary)
                .frame(width: 35, height: 5)
                .offset(y: -10)
            
            /// Sample Player View
            HStack(spacing: 12) {
                ZStack {
                    if expandPlayer {
                        Image(.album)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(.rect(cornerRadius: 10))
                            .matchedGeometryEffect(id: "Artwork", in: animation)
                            .transition(.offset(y: 1))
                    }
                }
                .frame(width: 80, height: 80)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Persona 3")
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                    
                    Text("Atlus")
                        .font(.caption2)
                        .foregroundStyle(.white.secondary)
                }
                
                Spacer(minLength: 0)
                
                HStack(spacing: 0) {
                    Button("", systemImage: "star.circle.fill") {
                        
                    }
                    Button("", systemImage: "ellipsis.circle.fill") {
                        
                    }
                }
                .foregroundStyle(.white, .white.tertiary)
                .font(.title2)
            }
        }
        .padding(15)
        .padding(.top, safeArea.top)
    }
}

#Preview {
    ContentView()
}
