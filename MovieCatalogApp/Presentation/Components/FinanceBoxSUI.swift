//
//  FinanceBoxSUI.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 02.11.2024.
//

import SwiftUI

struct FinanceContainerView: View {
    var title: String = LocalizedString.MovieDetails.Finance.financeTitle
    var itemTitles: [String] = [LocalizedString.MovieDetails.Finance.budget, LocalizedString.MovieDetails.Finance.earnings]
    var itemInformations: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 4) {
                Image(uiImage: UIImage(named: "director")!)
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
            }
        }
        .padding(16)
        .background(Color.darkFaded)
        .cornerRadius(16)
    }
}

struct FinanceItemView: View {
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
