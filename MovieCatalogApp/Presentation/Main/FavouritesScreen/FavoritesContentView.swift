//
//  FavoritesContentView.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 04.11.2024.
//

import SwiftUI

struct FavoritesContentView: View {
    @ObservedObject var viewModel: FavoritesViewModel
    @State var selectedMovieID: String = SC.empty

    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                Text(LocalizedString.Favorites.favoritesTitle)
                    .font(.custom("Manrope-Bold", size: 24))
                    .foregroundColor(.textDefault)

                VStack(alignment: .leading, spacing: 16) {
                    GradientText(text: LocalizedString.Favorites.favoriteGenres)

                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(viewModel.favoriteGenres, id: \.self) { genre in
                            FavoriteGenreBoxSUI(genre: genre.name?.capitalized ?? SC.empty, action: {
                                viewModel.removeGenre(genreName: genre.name ?? SC.empty)
                            })
                        }
                    }
                }

                VStack(alignment: .leading) {
                    GradientText(text: LocalizedString.Favorites.favoriteMovies)

                    Spacer(minLength: 16)

                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(viewModel.favoriteMovies, id: \.id) { movie in
                            MoviePosterView(movie: movie) {
                                selectedMovieID = movie.id
                                viewModel.filmTapped(movieID: selectedMovieID)
                            }
                        }
                    }
                }
                
                Spacer(minLength: 32)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
        }
    }
}
