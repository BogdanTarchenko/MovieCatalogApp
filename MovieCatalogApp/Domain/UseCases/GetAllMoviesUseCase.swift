//
//  GetAllMoviesUseCase.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 29.10.2024.
//

protocol GetAllMoviesUseCase {
    func execute() async throws -> [MovieElementModel]?
    func loadInitialMovies() async throws -> [MovieElementModel]
}

class GetAllMoviesUseCaseImpl: GetAllMoviesUseCase {
    private let repository: GetMoviesRepository
    
    private var currentPage = 4
    private var moviesBuffer: [MovieElementModel] = []
    private var initialMoviesBuffer: [MovieElementModel] = []
    
    init(repository: GetMoviesRepository) {
        self.repository = repository
    }
    
    static func create() -> GetAllMoviesUseCaseImpl {
        let httpClient = AlamofireHTTPClient(baseURL: .kreosoft)
        let repository = GetMoviesRepositoryImpl(httpClient: httpClient)
        return GetAllMoviesUseCaseImpl(repository: repository)
    }
    
    func execute() async throws -> [MovieElementModel]? {
        let pagedResponse = try await loadNextPage()
        currentPage += 1
        return pagedResponse.movies
    }
    
    func loadInitialMovies() async throws -> [MovieElementModel] {
        let firstPageResponse = try await repository.getMovies(page: 1)
        if let lastMovieFromFirstPage = firstPageResponse.movies?.last {
            initialMoviesBuffer.append(lastMovieFromFirstPage)
        }
        
        let secondPageResponse = try await repository.getMovies(page: 2)
        let thirdPageResponse = try await repository.getMovies(page: 3)
        
        if let moviesFromSecondPage = secondPageResponse.movies {
            initialMoviesBuffer.append(contentsOf: moviesFromSecondPage)
        }
        if let moviesFromThirdPage = thirdPageResponse.movies {
            initialMoviesBuffer.append(contentsOf: moviesFromThirdPage)
        }
        return initialMoviesBuffer
    }
    
    private func loadNextPage() async throws -> MoviesPagedListResponseModel {
        return try await repository.getMovies(page: currentPage)
    }
}
