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
    @State private var offsetY: CGFloat = 0
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            
            ZStack {
                /// Making it as Rounded Rectangle with Device Corner Radius
                RoundedRectangle(cornerRadius: animateContent ? deveiceCornerRadius : 0, style: .continuous)
                    .fill(.ultraThickMaterial)
                    .overlay(content: {
                        RoundedRectangle(cornerRadius: animateContent ? deveiceCornerRadius : 0, style: .continuous)
                            .fill(Color(uiColor: .secondarySystemFill.withAlphaComponent(0.30)))
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
                        /// Matching with Slide Animation
                        .offset(y: animateContent ? 0 : size.height)

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
                    /// For Smaller Devices the padding will be 10 and for larger devices the padding will be 30
                    .padding(.vertical, size.height < 700 ? 10 : 30)
                    
                    /// Player View
                    PlayerView(size)
                    /// Moving it From Bottom
                        .offset(y: animateContent ? 0 : size.height)
                })
                .padding(.top, safeArea.top + (safeArea.bottom == 0 ? 10 : 0))
                .padding(.bottom, safeArea.bottom == 0 ? 10 : safeArea.bottom)
                .padding(.horizontal, 25)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .clipped()
            }
            .contentShape(Rectangle())
            .offset(y: offsetY)
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        let translationY = value.translation.height
                        offsetY = (translationY > 0 ? translationY : 0)
                    }).onEnded({ value in
                        withAnimation(.easeInOut(duration: 0.35)) {
                            if offsetY > size.height * 0.4  {
                                expandSheet = false
                                animateContent = false
                            } else {
                                offsetY = .zero
                            }
                        }
                    })
            )
            .ignoresSafeArea(.container, edges: .all)

        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.35)) {
                animateContent = true
            }
        }
    }
    @ViewBuilder
    func PlayerView(_ mainSize: CGSize) -> some View {
        GeometryReader {
            let size = $0.size
            /// Dynamic Spacing Using Available Height
            let spacing = size.height * 0.04
            
            /// Sizing it for more compact look
            VStack(spacing: spacing) {
                VStack(spacing: spacing) {
                    HStack(alignment:.center, spacing: spacing) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Glimpse of Us")
                                .font(.title3)
                                .fontWeight(.semibold)
                            
                            Text("Joji")
                                .foregroundStyle(.gray)
                        }
                        Spacer(minLength: 0)
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundColor(.white)
                                .padding(12)
                                .background {
                                    Circle()
                                        .fill(.ultraThinMaterial)
                                        .environment(\.colorScheme, .light)
                                }
                        }
                    }
                    
                    /// Timing Indicator
                    Capsule()
                        .fill(.ultraThinMaterial)
                        .environment(\.colorScheme, .light)
                        .frame(height: 5)
                        .padding(.top, spacing)
                    
                    /// Timing Label View
                    HStack {
                        Text("0:00")
                            .font(.caption)
                            .foregroundStyle(.gray)
                        
                        Spacer(minLength: 0)
                        
                        Text("3:33")
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                }
                .frame(height: size.height / 2.5, alignment: .top)
                
                /// Playback Controls
                HStack(spacing: size.width * 0.18) {
                    Button {
                        
                    } label: {
                        Image(systemName: "backward.fill")
                        /// Dynamic Sizing for Smaller to Larger iPhones
                            .font(size.height < 300 ? .title3 : .title)
                    }
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "pause.fill")
                        /// Dynamic Sizing for Smaller to Larger iPhones
                            .font(size.height < 300 ? .largeTitle : .system(size: 50))
                    }
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "forward.fill")
                        /// Dynamic Sizing for Smaller to Larger iPhones
                            .font(size.height < 300 ? .title3 : .title)
                    }
                }
                .foregroundStyle(.white)
                .frame(maxHeight: .infinity)
                
                /// Volume & Other Controls
                VStack(spacing: spacing) {
                    HStack(spacing: 15) {
                        Image(systemName: "speaker.fill")
                            .foregroundStyle(.gray)
                        
                        Capsule()
                            .fill(.ultraThinMaterial)
                            .environment(\.colorScheme, .light)
                            .frame(height: 5)
                        
                        Image(systemName: "speaker.wave.3.fill")
                            .foregroundStyle(.gray)
                    }
                    
                    HStack(alignment: .top, spacing: size.width * 0.18) {
                        Button(action: {}, label: {
                            Image(systemName: "quote.bubble")
                                .font(.title2)
                        })
                        
                        VStack(spacing: 6) {
                            Button(action: {}, label: {
                                Image(systemName: "airpods.gen3")
                                    .font(.title2)
                            })
                            Text("Delstroo's Airpods")
                                .font(.caption)
                        }
                        
                        Button(action: {}, label: {
                            Image(systemName: "list.bullet")
                                .font(.title2)
                        })
                    }
                    .foregroundStyle(.white)
                    .blendMode(.overlay)
                    .padding(.top, spacing)
                }
                .frame(height: size.height / 2.5, alignment: .bottom)
  
            }
        }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}

extension View {
    var deveiceCornerRadius: CGFloat {
        let key = "_displayCornerRadius"
        if let screen = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.screen {
            if let cornerRadius = screen.value(forKey: key) as? CGFloat {
                return cornerRadius
            }
            return 0
        }
        return 0
    }
}
