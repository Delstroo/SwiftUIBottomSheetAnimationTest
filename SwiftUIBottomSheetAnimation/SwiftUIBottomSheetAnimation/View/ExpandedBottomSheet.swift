//
//  ExpandedBottomSheet.swift
//  SwiftUIBottomSheetAnimation
//
//  Created by Delstun McCray on 5/8/24.
//

import SwiftUI

struct ExpandedBottomSheet: View {
    @Binding var expandSheet: Bool
    var animation: Namespace.ID
        /// View Properties
    @State private var animateContent: Bool = false
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            
            ZStack {
                Rectangle()
                    .fill(.ultraThickMaterial)
                    .overlay(content: {
                        Rectangle()
                            .fill(Color("background"))
                            .opacity( animateContent ? 1 : 0)
                    })
                    .overlay(alignment: .top) {
                        MusicInfo(expandedSheet: $expandSheet, animation: animation)
                        /// Disable Interaction (Since it's not necessary here.)
                            .allowsHitTesting(false)
                            .opacity(animateContent ? 0 : 1)
                    }
                    .matchedGeometryEffect(id: "BGVIEW", in: animation)
                 
                VStack(spacing: 15, content: {
                    /// Grab Indicator
                    Capsule()
                        .fill(.gray)
                        .frame(width: 40, height: 5)
                        .opacity(animateContent ? 1 : 0)
                    
                    /// Artwork
                    GeometryReader {
                        let size = $0.size
                        
                        Image("Artwork")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                    }
                    /// Side Note: Always add the matched geometry effect before the frame() modifier.
                    .matchedGeometryEffect(id: "ARTWORK", in: animation)

                    /// For Square Artwork Image
                    .frame(height: size.width - 50)
                })
                .padding(.top, safeArea.top + (safeArea.bottom == 0 ? 10 : 0))
                .padding(.bottom, safeArea.bottom == 0 ? 10 : safeArea.bottom)
                .padding(.horizontal, 25)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.35)) {
                        expandSheet = false
                        animateContent = false
                    }
                }
            }
            .ignoresSafeArea(.container, edges: .all)

        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.35)) {
                animateContent = true
            }
        }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
