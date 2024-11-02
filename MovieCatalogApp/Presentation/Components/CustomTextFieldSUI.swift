//
//  CustomTextFieldSUI.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 03.11.2024.
//

import SwiftUI

struct CustomTextFieldView: View {
    @Binding var text: String
    var placeholder: String

    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.grayFaded)
            }
            TextField(SC.empty, text: $text)
                .foregroundColor(.textDefault)
        }
        .padding(16)
        .background(Color.darkFaded)
        .cornerRadius(8)
    }
}

