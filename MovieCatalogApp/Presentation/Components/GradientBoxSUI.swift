//
//  GradientBoxSUI.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 02.11.2024.
//

import SwiftUI

struct MovieContainerView: View {
    var title: String
    var tagline: String
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 223/255, green: 40/255, blue: 0/255), Color(red: 255/255, green: 102/255, blue: 51/255)]),
                startPoint: .leading,
                endPoint: .trailing
            )
            .cornerRadius(16)

            VStack(alignment: .leading) {
                Text(title)
                    .font(.custom("Manrope-Bold", size: 36))
                    .foregroundColor(.textDefault)

                Spacer()

                Text(tagline)
                    .font(.custom("Manrope-Regular", size: 20))
                    .foregroundColor(.textDefault)
            }
            .padding()
        }
    }
}
