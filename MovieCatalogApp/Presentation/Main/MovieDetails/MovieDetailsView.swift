//
//  MovieDetailsView.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 31.10.2024.
//

import SwiftUI
import Kingfisher

struct MovieDetailsView: View {
    
    @StateObject var viewModel: MovieDetailsViewModel
    @State private var isLoading = false
    @State private var title: String = SC.empty
    @State private var posterURL: String = SC.empty
    @State private var tagline: String = SC.empty
    @State private var description: String = SC.empty
    @State private var country: String = SC.empty
    @State private var age: String = SC.empty
    @State private var time: String = SC.empty
    @State private var year: String = SC.empty
    @State private var directorName: String = SC.empty
    @State private var genres: [String] = [SC.empty]
    @State private var isTitleVisible: Bool = false
    @State private var budget: String = SC.empty
    @State private var earnings: String = SC.empty
    @State private var averageRating: String = SC.empty
    @State private var ratingKinopoisk: String = SC.empty
    @State private var ratingImdb: String = SC.empty
    @State private var kinopoiskId: Int = 0
    @State private var directorURL: String = SC.empty
    
    @State private var currentReviewIndex: Int = 0
    @State private var showCustomAlert = false
    @State private var isEditingReview = false
    
    private let dataController = DataController.shared
    
    var hasSubmittedReview: Bool {
        viewModel.movieDetails?.reviews.contains { $0.author.userId == viewModel.currentUserId } ?? false
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color(.background)
                .ignoresSafeArea()
            
            KFImage(URL(string: posterURL))
                .resizable()
                .scaledToFill()
                .frame(height: 464)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 32, style: .circular))
                .ignoresSafeArea(edges: .top)
            
            ScrollView {
                GeometryReader { geometry in
                    Color.clear
                        .preference(key: ScrollOffsetKey.self, value: geometry.frame(in: .global).minY)
                }
                .frame(height: 0)
                
                VStack(spacing: 16) {
                    Spacer(minLength: 260)
                    
                    MovieContainerView(title: title, tagline: tagline)
                        .background(GeometryReader { geo in
                            Color.clear
                                .preference(key: MovieContainerVisibilityKey.self, value: geo.frame(in: .global).maxY)
                        })
                    FriendLikesView(friends: viewModel.friendsData, reviews: viewModel.movieDetails?.reviews ?? [])
                    GrayBoxView(title: description)
                    RatingContainerView(rating: [averageRating, ratingKinopoisk , ratingImdb])
                    InformationContainerView(itemInformations: [country, age, time, year])
                    DirectorContainerView(name: directorName, avatar: directorURL)
                    GenresContainerView(genres: genres, currentUserId: viewModel.currentUserId)
                    FinanceContainerView(itemInformations: [budget, earnings])
                    
                    if !(viewModel.movieDetails?.reviews.isEmpty ?? true) {
                        let currentReview = viewModel.movieDetails?.reviews[currentReviewIndex]
                        let currentReviewId = currentReview?.id ?? SC.empty
                        
                        let avatarURL = currentReview?.isAnonymous == true && currentReview?.author.userId != viewModel.currentUserId
                        ? Constants.defaultAvatarLink
                        : currentReview?.author.avatar ?? Constants.defaultAvatarLink
                        
                        let authorName = currentReview?.isAnonymous == true && currentReview?.author.userId != viewModel.currentUserId
                        ? Constants.anonymusUser
                        : currentReview?.author.nickName ?? Constants.anonymusUser
                        
                        ReviewContainerView(
                            avatarURL: avatarURL,
                            authorName: authorName,
                            date: formatDate(currentReview?.createDateTime),
                            mark: "\(currentReview?.rating ?? 1)",
                            review: currentReview?.reviewText ?? SC.empty,
                            isOwnReview: currentReview?.author.userId == viewModel.currentUserId,
                            hasSubmittedReview: hasSubmittedReview,
                            action: {
                                showCustomAlert = true
                                isEditingReview = false
                            },
                            avatarAction: {
                                if currentReview?.isAnonymous == false {
                                    let friend = Friend(context: dataController.context)
                                    friend.userId = currentReview?.author.userId
                                    friend.name = currentReview?.author.nickName
                                    friend.avatarLink = currentReview?.author.avatar
                                    dataController.addFriend(for: viewModel.currentUserId, friend: friend)
                                    
                                    if !viewModel.friendsData.contains(where: { $0.userId == friend.userId }) {
                                        viewModel.friendsData.append(friend)
                                    }
                                }
                            },
                            deleteAction: {
                                Task {
                                    currentReviewIndex -= 1
                                    try await viewModel.deleteReview(reviewID: currentReviewId)
                                    let updatedDetails = try await viewModel.fetchMovieDetails(movieID: viewModel.movieID)
                                    viewModel.movieDetails = updatedDetails
                                }
                            },
                            editAction: {
                                showCustomAlert = true
                                isEditingReview = true
                            },
                            backAction: {
                                if currentReviewIndex > 0 {
                                    currentReviewIndex -= 1
                                }
                            },
                            nextAction: {
                                if currentReviewIndex < (viewModel.movieDetails?.reviews.count ?? 0) - 1 {
                                    currentReviewIndex += 1
                                }
                            },
                            isFirstReview: currentReviewIndex == 0,
                            isLastReview: currentReviewIndex == (viewModel.movieDetails?.reviews.count ?? 0) - 1
                        )
                        
                    } else {
                        Text(LocalizedString.MovieDetails.Reviews.emptyReviews)
                            .font(.custom("Manrope-Regular", size: 14))
                            .foregroundColor(.gray)
                    }
                    
                }
                .padding([.leading, .trailing], 24)
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .padding(.top, 32)
            .onPreferenceChange(MovieContainerVisibilityKey.self) { maxY in
                isTitleVisible = maxY < 128
            }
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Button(action: {
                            viewModel.dismissView()
                        }) {
                            Image(uiImage: UIImage(named: "back_button") ?? UIImage())
                        }
                        if isTitleVisible {
                            Text(title)
                                .font(.custom("Manrope-Bold", size: 24))
                                .foregroundColor(.textDefault)
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .frame(maxWidth: 250)
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        if viewModel.isFavorite {
                            viewModel.deleteMovieFromFavorites()
                        } else {
                            viewModel.addMovieToFavorites()
                        }
                        viewModel.isFavorite.toggle()
                    }) {
                        if viewModel.isFavorite {
                            Image(uiImage: UIImage(named: "like_button") ?? UIImage())
                        } else {
                            Image(uiImage: UIImage(named: "dislike_button") ?? UIImage())
                        }
                    }
                }
            }
            
            if isLoading {
                LoaderSwiftUI()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            if showCustomAlert {
                ZStack {
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                        .onTapGesture {
                            showCustomAlert = false
                        }
                    
                    let currentReview = viewModel.movieDetails?.reviews[currentReviewIndex]
                    let currentReviewId = currentReview?.id ?? SC.empty
                    ReviewAlertView(
                        isPresented: $showCustomAlert,
                        action: { rating, reviewText, isAnonymous in
                            Task {
                                if isEditingReview {
                                    let reviewUpdate = ReviewRequest(reviewText: reviewText, rating: rating, isAnonymous: isAnonymous)
                                    try await viewModel.editReview(reviewID: currentReviewId, request: reviewUpdate)
                                } else {
                                    try await viewModel.addReview(request: ReviewRequest(reviewText: reviewText, rating: rating, isAnonymous: isAnonymous))
                                }
                                let updatedDetails = try await viewModel.fetchMovieDetails(movieID: viewModel.movieID)
                                viewModel.movieDetails = updatedDetails
                                currentReviewIndex = (viewModel.movieDetails?.reviews.count ?? 0) - 1
                            }
                        },
                        existingRating: isEditingReview ? currentReview?.rating : nil,
                        existingReviewText: isEditingReview ? currentReview?.reviewText : nil,
                        existingIsAnonymous: isEditingReview ? currentReview?.isAnonymous : nil
                    )
                    .padding(.horizontal, 24)
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .onAppear {
            bindToViewModel()
            viewModel.onDidLoad()
        }
    }
}

// MARK: - ScrollOffset
struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}

// MARK: - MovieContainerVisibility
struct MovieContainerVisibilityKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}

// MARK: - Binding
extension MovieDetailsView {
    private func bindToViewModel() {
        viewModel.onDidLoadMovieDetails = { movieDetails in
            title = movieDetails.name
            posterURL = movieDetails.poster
            tagline = movieDetails.tagline
            description = movieDetails.description
            country = movieDetails.country
            age = ("\(movieDetails.ageLimit)+")
            time = formatMovieDuration(minutes: movieDetails.time)
            year = "\(movieDetails.year)"
            directorName = movieDetails.director
            genres = movieDetails.genres.map { $0.name }
            budget = formatBudget(budget: movieDetails.budget)
            earnings = formatBudget(budget: movieDetails.fees)
            averageRating = calculateAverageRating(from: movieDetails.reviews)
        }
        
        viewModel.onDidLoadKinopoiskDetails = { kinopoiskDetails in
            kinopoiskId = kinopoiskDetails.kinopoiskId
            ratingKinopoisk = "\(kinopoiskDetails.ratingKinoposik)"
            ratingImdb = "\(kinopoiskDetails.ratingImdb)"
        }
        
        viewModel.onDidLoadPersonDetails = { personDetails in
            directorURL = personDetails.posterURL
        }
        
        viewModel.onDidStartLoad = {
            isLoading = true
        }
        
        viewModel.onDidFinishLoad = {
            isLoading = false
        }
    }
}

// MARK: - Map
extension MovieDetailsView {
    private func formatMovieDuration(minutes: Int) -> String {
        let hours = minutes / 60
        let remainingMinutes = minutes % 60
        return "\(hours) ч \(remainingMinutes) мин"
    }
    
    private func formatBudget(budget: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = SC.space
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        
        let formattedNumber = formatter.string(from: NSNumber(value: budget)) ?? "0"
        return "$ \(formattedNumber)"
    }
    
    private func calculateAverageRating(from reviews: [ReviewDetails]) -> String {
        guard !reviews.isEmpty else { return "0.0" }
        let totalRating = reviews.reduce(0) { $0 + $1.rating }
        let average = Double(totalRating) / Double(reviews.count)
        return String(format: "%.1f", average)
    }
    
    private func formatDate(_ dateString: String?) -> String {
        guard let dateString = dateString else { return SC.empty }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "d MMMM yyyy"
            dateFormatter.locale = Locale(identifier: "ru")
            return dateFormatter.string(from: date)
        }
        return SC.empty
    }
}

extension MovieDetailsView {
    enum Constants {
        static var defaultAvatarLink: String = "https://s3-alpha-sig.figma.com/img/a92b/ba97/a13937d71ea4ab29b068a92fd325aa74?Expires=1731283200&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=NChlGzcfGZDhcEKxSkCuF2s07eic2KBzFrFDqDNR-cLTSRdLnoGdp3lgKFZJ70jgBCxUWz6J7LE~nBKRbeBagiPAx6PEpRfiaTPv5B5YMnrjkP3m9OshStQuDb7LJyufIqH1swKkFOywX7Wo3uEwUtueMagv6J~UzRAPWoxqvgJaRbi2uET-TmmLY4bCcB8tqfvPaCrjKm0ajPGWlpP7TzTfEuZbulvT2MgKpg5taY4z-iXg6Mrww8Xge05ioMU5V4raAnRNpOgFyRGbq3ZZkT1LsKjQ4HLyLWxycmaukA1zWwLcm7OfsDlOx~OB3Uwkl04nTnIxe8NfaOEwQSb1FQ__"
        
        static var anonymusUser: String = LocalizedString.MovieDetails.Reviews.anonymusUser
    }
}
