//
//  MoviePosterSUI.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 04.11.2024.
//

import SwiftUI
import Kingfisher

struct MoviePosterView: View {
    let movie: AllMovieData
    var onTap: (() -> Void)?

    var body: some View {
        VStack {
            ZStack(alignment: .topLeading) {
                KFImage(URL(string: movie.posterURL))
                    .resizable()
                    .scaledToFill()
                    .cornerRadius(8)
                    .clipped()
                
                if let averageRating = averageRating(for: movie) {
                    HStack {
                        Text(String(format: "%.1f", averageRating))
                            .font(.custom("Manrope-Medium", size: 12))
                            .foregroundColor(.textDefault)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(colorForRating(averageRating))
                    .cornerRadius(4)
                    .padding(.top, 8)
                    .padding(.leading, 8)
                }
            }
            .onTapGesture {
                onTap?()
            }
        }
        .frame(maxWidth: 116, maxHeight: 166)
    }

    private func averageRating(for movie: AllMovieData) -> Double? {
        guard !movie.reviews.isEmpty else { return nil }
        let totalRating = movie.reviews.reduce(0) { $0 + $1.rating }
        return Double(totalRating) / Double(movie.reviews.count)
    }

    private func colorForRating(_ rating: Double) -> Color {
        switch rating {
        case 0.0..<2.5:
            return blend(color1: Color(.darkRed), color2: .red, ratio: CGFloat(rating / 4.0))
        case 2.5..<6.0:
            return blend(color1: .red, color2: .orange, ratio: CGFloat((rating - 2.5) / 3.0))
        case 6.0...10.0:
            return blend(color1: .orange, color2: .green, ratio: CGFloat((rating - 6.0) / 3.0))
        default:
            return .green
        }
    }

    private func blend(color1: Color, color2: Color, ratio: CGFloat) -> Color {
        let ratio = max(0, min(0.75, ratio))
        
        let uiColor1 = UIColor(color1)
        let uiColor2 = UIColor(color2)
        
        var (r1, g1, b1, a1): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        var (r2, g2, b2, a2): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)

        uiColor1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        uiColor2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)

        return Color(
            red: Double(r1 + (r2 - r1) * ratio),
            green: Double(g1 + (g2 - g1) * ratio),
            blue: Double(b1 + (b2 - b1) * ratio),
            opacity: Double(a1 + (a2 - a1) * ratio)
        )
    }
}
