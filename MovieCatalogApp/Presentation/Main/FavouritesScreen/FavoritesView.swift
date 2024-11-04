//
//  FavoritesView.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 04.11.2024.
//

import SwiftUI

struct FavoritesView: View {
    
    @StateObject var viewModel: FavoritesViewModel
    @State private var selectedMovieID: String = SC.empty
    @State private var showMovieDetails = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                Color(.background)
                    .ignoresSafeArea()
                
                if viewModel.isFavoritesEmpty {
                    EmptyFavoritesView(viewModel: viewModel)
                } else {
                    FavoritesContentView(viewModel: viewModel, selectedMovieID: selectedMovieID)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                Task {
                    await viewModel.updateFavoritesStatus()
                }
            }
        }
    }
}

