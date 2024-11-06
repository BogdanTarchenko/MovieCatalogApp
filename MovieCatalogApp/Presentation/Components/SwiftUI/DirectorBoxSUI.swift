//
//  DirectorBoxSUI.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 02.11.2024.
//

import SwiftUI
import Kingfisher

struct DirectorContainerView: View {
    var title: String = LocalizedString.MovieDetails.directorTitle
    var name: String
    var avatar: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 4) {
                if let directorImage = UIImage(named: "director") {
                    Image(uiImage: directorImage)
                        .tint(.gray)
                }
                Text(title)
                    .font(.custom("Manrope-Medium", size: 16))
                    .foregroundStyle(.textDefault)
                Spacer()
            }
            
            DirectorItemView(name: name, avatar: avatar)
        }
        .padding(16)
        .background(Color.darkFaded)
        .cornerRadius(16)
    }
}

struct DirectorItemView: View {
    var name: String
    var avatar: String

    var body: some View {
        HStack(spacing: 8) {
            KFImage(URL(string: avatar))
                .resizable()
                .scaledToFill()
                .frame(width: 48, height: 48)
                .clipShape(Circle())
            
            Text(name)
                .font(.custom("Manrope-Medium", size: 16))
                .foregroundStyle(.textDefault)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.dark)
        .cornerRadius(8)
    }
}

