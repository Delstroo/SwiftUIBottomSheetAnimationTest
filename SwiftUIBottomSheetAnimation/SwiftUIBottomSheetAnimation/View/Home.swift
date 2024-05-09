//
//  Home.swift
//  SwiftUIBottomSheetAnimation
//
//  Created by Delstun McCray on 5/1/24.
//

import SwiftUI

struct Home: View {
    
    @State private var expandedSheet: Bool = false
    @Namespace private var animation
    var body: some View {
        // MARK: Tab View
        TabView {
            // MARK: Sample Tab's
            sampleTabView("Listen Now", "play.circle.fill")
            sampleTabView("Browse", "square.grid.2x2.fill")
            sampleTabView("Radio", "dot.radiowaves.left.and.right")
            sampleTabView("Music", "play.square.stack")
            sampleTabView("Search", "magnifyingglass")
        }
        /// Changing Tab Indicator Color
        .tint(.red)
        .safeAreaInset(edge: .bottom) {
            customBottomSheet()
        }
        .overlay(content: {
            if expandedSheet {
                ExpandedBottomSheet(expandSheet: $expandedSheet, animation: animation)
                /// Transition for more fluent Animation
                    .transition(.asymmetric(insertion: .identity, removal: .offset(y: -5)))
            }
        })
    }
    
    /// Custom Bottom Sheet
    @ViewBuilder
    /// Animating Sheet Background (To Look Like It's Expanding From the Bottom)
    func customBottomSheet() -> some View {
        ZStack {
            if expandedSheet {
                Rectangle()
                    .fill(.clear)
            } else {
                Rectangle()
                    .fill(.ultraThickMaterial)
                    .overlay {
                        MusicInfo(expandedSheet: $expandedSheet, animation: animation)
                        
                    }
                    .matchedGeometryEffect(id: "BGVIEW", in: animation)
            }
        }
        .frame(height: 70)
        /// Seperator Line
        .overlay(alignment: .bottom, content: {
            Rectangle()
                .fill(.gray.opacity(0.3))
                .frame(height: 1)
                .offset(y: -10)
        })
        /// 49: Default Tab Bar Height
        .offset(y: -49)
        
    }

    @ViewBuilder
    func sampleTabView(_ title: String, _ icon: String) -> some View {
        Text(title)
            .tabItem {
                Image(systemName: icon)
                Text(title)
            }
        /// Changing Tab Background Color
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarBackground(.ultraThickMaterial, for: .tabBar)
    }
    
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}

/// Reusable File
struct MusicInfo: View {
    @Binding var expandedSheet: Bool
    var animation: Namespace.ID
    var body: some View {
        HStack(spacing: 0, content: {
            /// Adding Matched Geometry Effect
            ZStack {
                if !expandedSheet {
                    GeometryReader {
                        let size = $0.size
                        
                        Image("Artwork")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width, height: size.height)
                            .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous ))
                    }
                    .matchedGeometryEffect(id: "ARTWORK", in: animation)
                } else {
                    
                }
            }
            .frame(width: 45, height: 45)
                        
            Text("Glimpse Of Us")
                .fontWeight(.semibold)
                .lineLimit(1)
                .padding(.horizontal, 15)
            
            Spacer()
            
            Button {
                
            } label: {
                Image(systemName: "pause.fill")
                    .font(.title2)
            }
            .frame(alignment: .trailing)
            
            Button {
                
            }label: {
                Image(systemName: "forward.fill")
                    .font(.title2)
            }
            .padding(.leading, 25)
            .frame(alignment: .trailing)
        })
        .padding(.horizontal, 15)
        .padding(.bottom, 7)
        .frame(height: 70)
        .contentShape(Rectangle())
        .onTapGesture {
            /// Expanding Bottom Sheet
            withAnimation(.easeInOut(duration: 0.3)) {
                expandedSheet = true
            }
        }
    }
}
