//
//  ReviewsBoxSUI.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 02.11.2024.
//

import SwiftUI
import Kingfisher

struct ReviewContainerView: View {
    
    var title: String = LocalizedString.MovieDetails.Reviews.reviewsTitle
    
    var avatarURL: String
    var authorName: String
    var date: String
    var mark: String
    var review: String
    
    var action: () -> Void
    var backAction: () -> Void
    var nextAction: () -> Void
    
    var isFirstReview: Bool
    var isLastReview: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 4) {
                Image(uiImage: UIImage(named: "reviews")!)
                    .tint(.gray)
                Text(title)
                    .font(.custom("Manrope-Medium", size: 16))
                    .foregroundStyle(.textDefault)
                Spacer()
            }
            
            ReviewsItemView(avatarURL: avatarURL, authorName: authorName, date: date, mark: mark, review: review)
            
            HStack(spacing: 24) {
                AddReviewButtonView(action: action)
                    .frame(maxWidth: .infinity, alignment: .leading)
                ReviewPickerView(backAction: backAction, nextAction: nextAction, isFirstReview: isFirstReview, isLastReview: isLastReview)
            }
        }
        .padding(16)
        .background(Color.darkFaded)
        .cornerRadius(16)
    }
}

struct ReviewsItemView: View {
    var avatarURL: String
    var authorName: String
    var date: String
    var mark: String
    var review: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 8) {
                KFImage(URL(string: avatarURL))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 32, height: 32)
                    .clipShape(Circle())
                VStack(alignment: .leading) {
                    Text(authorName)
                        .font(.custom("Manrope-Medium", size: 12))
                        .foregroundStyle(.textDefault)
                    Text(date)
                        .font(.custom("Manrope-Medium", size: 12))
                        .foregroundStyle(.grayFaded)
                }
                Spacer()
                MarkItemView(mark: mark)
            }
            Text(review)
                .font(.custom("Manrope-Regular", size: 14))
                .foregroundStyle(.textDefault)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.dark)
        .cornerRadius(8)
    }
}

struct MarkItemView: View {
    var star: UIImage = UIImage(named: "star_small")!
    var mark: String
    
    var body: some View {
        HStack(spacing: 2) {
            Image(uiImage: star)
                .foregroundStyle(.textDefault)
            Text(mark)
                .font(.custom("Manrope-Medium", size: 16))
                .foregroundStyle(.textDefault)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(calculateBackgroundColor(for: Int(mark) ?? 1))
        .cornerRadius(4)
    }
    
    private func calculateBackgroundColor(for mark: Int) -> Color {
        let clampedMark = min(max(mark, 1), 10)

        switch clampedMark {
        case 1...2:
            return blend(color1: .darkRed, color2: .red, ratio: CGFloat(clampedMark - 1) / 1.0)
        case 3...5:
            return blend(color1: .red, color2: .orange, ratio: CGFloat(clampedMark - 3) / 2.0)
        case 6...8:
            return blend(color1: .orange, color2: .green, ratio: CGFloat(clampedMark - 6) / 2.0)
        case 9...10:
            return blend(color1: .green, color2: .green, ratio: 0.0)
        default:
            return Color(UIColor.darkRed)
        }
    }

    private func blend(color1: UIColor, color2: UIColor, ratio: CGFloat) -> Color {
        let ratio = max(0, min(0.75, ratio))
        let red = (1 - ratio) * CGFloat(color1.cgColor.components![0]) + ratio * CGFloat(color2.cgColor.components![0])
        let green = (1 - ratio) * CGFloat(color1.cgColor.components![1]) + ratio * CGFloat(color2.cgColor.components![1])
        let blue = (1 - ratio) * CGFloat(color1.cgColor.components![2]) + ratio * CGFloat(color2.cgColor.components![2])

        return Color(red: red, green: green, blue: blue)
    }

}

struct AddReviewButtonView: View {
    var title: String = LocalizedString.MovieDetails.Reviews.addReviewTitle
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Text(title)
                .font(.custom("Manrope-Bold", size: 14))
                .foregroundStyle(.textDefault)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 223/255, green: 40/255, blue: 0/255),
                            Color(red: 255/255, green: 102/255, blue: 51/255)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(8)
        }
        .frame(maxWidth: .infinity)
    }
}

struct ReviewPickerView: View {
    var backButton: UIImage = UIImage(named: "review_back_button")!
    var nextButton: UIImage = UIImage(named: "review_next_button")!
    
    var backAction: () -> Void
    var nextAction: () -> Void
    
    var isFirstReview: Bool
    var isLastReview: Bool
    
    var body: some View {
        HStack(spacing: 4) {
            Button(action: {
                backAction()
            }) {
                Image(uiImage: backButton)
                    .renderingMode(.template)
                    .padding(8)
                    .background(isFirstReview ? Color.darkFaded : Color.dark)
                    .foregroundStyle(isFirstReview ? Color.grayFaded : Color.textDefault)
                    .cornerRadius(8)
            }
            
            Button(action: {
                nextAction()
            }) {
                Image(uiImage: nextButton)
                    .renderingMode(.template)
                    .padding(8)
                    .background(isLastReview ? Color.darkFaded : Color.dark)
                    .foregroundStyle(isLastReview ? Color.grayFaded : Color.textDefault)
                    .cornerRadius(8)
            }
        }
    }
}


