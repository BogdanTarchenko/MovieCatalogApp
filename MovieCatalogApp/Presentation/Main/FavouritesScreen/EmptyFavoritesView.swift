//
//  EmptyFavoritesView.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 04.11.2024.
//

import SwiftUI

struct EmptyFavoritesView: View {
    @ObservedObject var viewModel: FavoritesViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Image(uiImage: UIImage(named: "favorites_background")!)
                .resizable()
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 32, style: .circular))
                .ignoresSafeArea(edges: .top)

            Spacer(minLength: 32)

            VStack(alignment: .leading, spacing: 8) {
                Text(LocalizedString.Favorites.emptyTitle)
                    .font(.custom("Manrope-Bold", size: 24))
                    .foregroundStyle(.textDefault)
                Text(LocalizedString.Favorites.emptyDescription)
                    .font(.custom("Manrope-Medium", size: 16))
                    .foregroundStyle(.textDefault)
            }
            .padding(.horizontal, 24)

            Spacer(minLength: 24)

            Button(action: {
                viewModel.findFilmButtonTapped()
            }) {
                Text(LocalizedString.Favorites.buttonTitle)
                    .font(.custom("Manrope-Bold", size: 14))
                    .foregroundColor(.textDefault)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 14)
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color(red: 223/255, green: 40/255, blue: 0/255), Color(red: 255/255, green: 102/255, blue: 51/255)]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(8)
            .padding(.horizontal, 24)

            Spacer(minLength: 32)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Text(LocalizedString.Favorites.favoritesTitle)
                    .font(.custom("Manrope-Bold", size: 24))
                    .foregroundColor(.textDefault)
            }
        }
        .toolbarBackground(.hidden, for: .navigationBar)
    }
}
