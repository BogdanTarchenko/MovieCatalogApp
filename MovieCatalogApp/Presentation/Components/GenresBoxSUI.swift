//
//  GenresBoxSUI.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 02.11.2024.
//

import SwiftUI

struct GenresContainerView: View {
    var title: String = LocalizedString.MovieDetails.genresTitle
    var genres: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 4) {
                Image(uiImage: UIImage(named: "genres")!)
                    .tint(.gray)
                Text(title)
                    .font(.custom("Manrope-Medium", size: 16))
                    .foregroundStyle(.textDefault)
                Spacer()
            }
            
            let groupedGenres = genres.chunked(into: 2)
            VStack(alignment: .leading) {
                ForEach(groupedGenres.indices, id: \.self) { index in
                    HStack(spacing: 8) {
                        ForEach(groupedGenres[index], id: \.self) { genre in
                            GenresItemView(genre: genre)
                        }
                    }
                }
            }
        }
        .padding(16)
        .background(Color.darkFaded)
        .cornerRadius(16)
    }
}

struct GenresItemView: View {
    var genre: String
    @State private var isSelected: Bool = false
    
    var body: some View {
        Button(action: {
            isSelected.toggle()
        }) {
            Text(genre)
                .font(.custom("Manrope-Medium", size: 16))
                .foregroundStyle(.textDefault)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    Group {
                        if isSelected {
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 223/255, green: 40/255, blue: 0/255),
                                    Color(red: 255/255, green: 102/255, blue: 51/255)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        } else {
                            Color.dark
                        }
                    }
                )
                .cornerRadius(8)
        }
    }
}


