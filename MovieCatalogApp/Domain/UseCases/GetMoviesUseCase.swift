//
//  GetMoviesUseCase.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 20.10.2024.
//

protocol GetMoviesUseCase {
    func execute() async throws -> MovieElementModel?
}

class GetMoviesUseCaseImpl: GetMoviesUseCase {
    private let repository: GetMoviesRepository
    
    private var currentPage = 1
    private var moviesBuffer: [MovieElementModel] = []
    
    init(repository: GetMoviesRepository) {
        self.repository = repository
    }
    
    static func create() -> GetMoviesUseCaseImpl {
        let httpClient = AlamofireHTTPClient(baseURL: .kreosoft)
        let repository = GetMoviesRepositoryImpl(httpClient: httpClient)
        return GetMoviesUseCaseImpl(repository: repository)
    }
    
    func execute() async throws -> MovieElementModel? {
        if moviesBuffer.isEmpty {
            let pagedResponse = try await loadNextPage()
            moviesBuffer = pagedResponse.movies?.shuffled() ?? []
            currentPage += 1
        }
        return moviesBuffer.popLast()
    }
    
    private func loadNextPage() async throws -> MoviesPagedListResponseModel {
        return try await repository.getMovies(page: currentPage)
    }
}
