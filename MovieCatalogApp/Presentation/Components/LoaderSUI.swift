//
//  LoaderSwiftUI.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 01.11.2024.
//

import SwiftUI
import Lottie

struct LoaderSwiftUI: View {
    @State private var isAnimating = true

    var body: some View {
        LottieView(isAnimating: $isAnimating)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.clear)
    }
}

struct LottieView: UIViewRepresentable {
    @Binding var isAnimating: Bool

    func makeUIView(context: Context) -> LottieAnimationView {
        let animationView = LottieAnimationView(name: "loading")
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        return animationView
    }

    func updateUIView(_ uiView: LottieAnimationView, context: Context) {
        if isAnimating {
            uiView.play()
        } else {
            uiView.stop()
        }
    }
}
