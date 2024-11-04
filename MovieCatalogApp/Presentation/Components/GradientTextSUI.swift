//
//  GradientTextSUI.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 04.11.2024.
//

import SwiftUI

struct GradientText: View {
    var text: String
    var font: Font = .custom("Manrope-Bold", size: 20)
    var gradientColors: [Color] = [
        Color(red: 223/255, green: 40/255, blue: 0/255),
        Color(red: 255/255, green: 102/255, blue: 51/255)
    ]
    
    var body: some View {
        Text(text)
            .font(font)
            .foregroundStyle(
                LinearGradient(
                    gradient: Gradient(colors: gradientColors),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
    }
}
