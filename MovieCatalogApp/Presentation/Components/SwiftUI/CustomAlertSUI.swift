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
    @State var action: (Int, String, Bool) -> Void
    
    var existingRating: Int?
    var existingReviewText: String?
    var existingIsAnonymous: Bool?
    
    @State private var showAlert: Bool = false
    
    private let gradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 223/255, green: 40/255, blue: 0/255),
            Color(red: 255/255, green: 102/255, blue: 51/255)
        ]),
        startPoint: .leading,
        endPoint: .trailing
    )
    
    init(isPresented: Binding<Bool>, action: @escaping (Int, String, Bool) -> Void, existingRating: Int? = nil, existingReviewText: String? = nil, existingIsAnonymous: Bool? = nil) {
        self._isPresented = isPresented
        self.action = action
        self.existingRating = existingRating
        self.existingReviewText = existingReviewText
        self.existingIsAnonymous = existingIsAnonymous
        
        _rating = State(initialValue: existingRating ?? 5)
        _reviewText = State(initialValue: existingReviewText ?? SC.empty)
        _isAnonymous = State(initialValue: existingIsAnonymous ?? true)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text(existingRating != nil ? LocalizedString.MovieDetails.Reviews.editReviewTitle : LocalizedString.MovieDetails.Reviews.addReviewTitle)
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
                    if reviewText.isEmpty {
                        showAlert = true
                    } else {
                        action(rating, reviewText, isAnonymous)
                        isPresented = false
                    }
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
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(LocalizedString.Alert.error),
                message: Text(LocalizedString.Alert.emptyReview),
                dismissButton: .default(Text(LocalizedString.Alert.OK))
            )
        }
    }
}

