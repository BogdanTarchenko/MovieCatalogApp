//
//  GradientToggleStyleSUI.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 02.11.2024.
//

import SwiftUI

struct GradientToggleStyle: ToggleStyle {
    var gradient: LinearGradient
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            Rectangle()
                .fill(configuration.isOn ? gradient : LinearGradient(gradient: Gradient(colors: [Color.darkFaded]), startPoint: .leading, endPoint: .trailing))
                .frame(width: 52, height: 32)
                .overlay(
                    Circle()
                        .fill(Color.textDefault)
                        .padding(3)
                        .offset(x: configuration.isOn ? 10 : -10)
                        .animation(.easeInOut(duration: 0.2), value: configuration.isOn)
                )
                .cornerRadius(16)
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
    }
}

