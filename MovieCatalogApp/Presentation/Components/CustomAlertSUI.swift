//
//  CustomAlertSUI.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 02.11.2024.
//

import SwiftUI

struct ReviewAlertView: View {
    @Binding var isPresented: Bool
    @State private var rating: Int = 5
    @State private var reviewText: String = SC.empty
    @State private var isAnonymous: Bool = true
    @State var action: () -> Void

    private let gradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 223/255, green: 40/255, blue: 0/255),
            Color(red: 255/255, green: 102/255, blue: 51/255)
        ]),
        startPoint: .leading,
        endPoint: .trailing
    )

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text(LocalizedString.MovieDetails.Reviews.addReviewTitle)
                .font(.custom("Manrope-Bold", size: 20))
                .foregroundColor(.textDefault)
            
            HStack {
                Text(LocalizedString.MovieDetails.Reviews.mark)
                    .font(.custom("Manrope-Regular", size: 14))
                    .foregroundColor(.gray)
                
                Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(gradient)
                        .frame(maxWidth: 36, maxHeight: 24)

                    Text("\(rating)")
                        .font(.custom("Manrope-Medium", size: 14))
                        .foregroundColor(.textDefault)
                        .padding(.horizontal, 8)
                }
            }

            
            Slider(value: Binding(get: {
                Double(self.rating)
            }, set: { newValue in
                self.rating = Int(newValue)
            }), in: 0...10, step: 1)

            CustomTextFieldView(text: $reviewText, placeholder: LocalizedString.MovieDetails.Reviews.reviewPlaceholder)

            Toggle(isOn: $isAnonymous) {
                Text(LocalizedString.MovieDetails.Reviews.anonymusReview)
                    .font(.custom("Manrope-Regular", size: 14))
                    .foregroundColor(.gray)
            }
            .toggleStyle(GradientToggleStyle(gradient: gradient))

            HStack {
                Spacer()
                Button(action: {
                    action()
                    isPresented = false
                }) {
                    Text(LocalizedString.MovieDetails.Reviews.sendButtonTitle)
                        .font(.custom("Manrope-Bold", size: 14))
                        .foregroundColor(.textDefault)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 10)
                        .background(gradient)
                        .cornerRadius(8)
                }
            }
        }
        .padding(24)
        .background(Color.dark)
        .cornerRadius(28)
    }
}
