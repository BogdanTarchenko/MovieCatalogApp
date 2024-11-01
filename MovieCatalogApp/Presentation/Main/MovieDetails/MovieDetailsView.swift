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
                    GrayBoxView(title: description)
                    RatingContainerView(rating: ["9.9","7.1","7.3"])
                    InformationContainerView(itemInformations: [country, age, time, year])
                    DirectorContainerView(name: directorName, avatar: UIImage())
                    GenresContainerView(genres: genres)
                    FinanceContainerView(itemInformations: [budget, earnings])
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
    
    func formatBudget(budget: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = SC.space
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0

        let formattedNumber = formatter.string(from: NSNumber(value: budget)) ?? "0"
        return "$ \(formattedNumber)"
    }
}
