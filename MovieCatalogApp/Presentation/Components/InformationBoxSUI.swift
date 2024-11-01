//
//  InformationBoxSUI.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 02.11.2024.
//

import SwiftUI

struct InformationContainerView: View {
    var title: String = LocalizedString.MovieDetails.Information.informationTitle
    var itemTitles: [String] = [LocalizedString.MovieDetails.Information.countryTitle, LocalizedString.MovieDetails.Information.ageTitle, LocalizedString.MovieDetails.Information.timeTitle, LocalizedString.MovieDetails.Information.yearTitle]
    var itemInformations: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 4) {
                Image(uiImage: UIImage(named: "information")!)
                    .tint(.gray)
                Text(title)
                    .font(.custom("Manrope-Medium", size: 16))
                    .foregroundStyle(.textDefault)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    InformationItemView(title: itemTitles[0], information: itemInformations[0])
                    InformationItemView(title: itemTitles[1], information: itemInformations[1])
                }
                
                HStack(spacing: 8) {
                    InformationItemView(title: itemTitles[2], information: itemInformations[2])
                    InformationItemView(title: itemTitles[3], information: itemInformations[3])
                }
            }
        }
        .padding(16)
        .background(Color.darkFaded)
        .cornerRadius(16)
    }
}

struct InformationItemView: View {
    var title: String
    var information: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.custom("Manrope-Regular", size: 14))
                .foregroundStyle(.gray)
            Text(information)
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
