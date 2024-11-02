//
//  RatingBoxSUI.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 02.11.2024.
//

import SwiftUI

struct RatingContainerView: View {
    var title: String = LocalizedString.MovieDetails.ratingTitle
    var rating: [String]
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 4) {
                Image(uiImage: UIImage(named: "star")!)
                    .tint(.gray)
                Text(title)
                    .font(.custom("Manrope-Medium", size: 16))
                    .foregroundStyle(.textDefault)
                Spacer()
            }
            HStack(spacing: 8) {
                MovieCatalogItemView(rating: rating[0], logo: UIImage(named: "small_logo")!)
                    .frame(maxWidth: .infinity)
                RatingItemView(rating: rating[1], logo: UIImage(named: "kinopoisk_logo")!)
                RatingItemView(rating: rating[2], logo: UIImage(named: "imdb_logo")!)
            }
        }
        .padding(16)
        .background(Color.darkFaded)
        .cornerRadius(16)
    }
}

struct RatingItemView: View {
    var rating: String
    var logo: UIImage
    
    var body: some View {
        HStack {
            Image(uiImage: logo)
            Text(rating)
                .font(.custom("Manrope-Bold", size: 20))
                .foregroundStyle(.textDefault)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.dark)
        .cornerRadius(8)
    }
}

struct MovieCatalogItemView: View {
    var rating: String
    var logo: UIImage
    
    var body: some View {
        HStack {
            Image(uiImage: logo)
            Text(rating)
                .font(.custom("Manrope-Bold", size: 20))
                .foregroundStyle(.textDefault)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.dark)
        .cornerRadius(8)
    }
}
