//
//  GetAllMoviesUseCase.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 29.10.2024.
//

protocol GetAllMoviesUseCase {
    func execute() async throws -> MovieElementModel?
}

class GetAllMoviesUseCaseImpl: GetAllMoviesUseCase {
    private let repository: GetMoviesRepository
    
    private var currentPage = 4
    private var moviesBuffer: [MovieElementModel] = []
    
    init(repository: GetMoviesRepository) {
        self.repository = repository
        Task {
            await loadInitialMovies()
        }
    }
    
    static func create() -> GetAllMoviesUseCaseImpl {
        let httpClient = AlamofireHTTPClient(baseURL: .kreosoft)
        let repository = GetMoviesRepositoryImpl(httpClient: httpClient)
        return GetAllMoviesUseCaseImpl(repository: repository)
    }
    
    func execute() async throws -> MovieElementModel? {
        if moviesBuffer.isEmpty {
            let pagedResponse = try await loadNextPage()
            moviesBuffer = pagedResponse.movies ?? []
            currentPage += 1
        }
        return moviesBuffer.popLast()
    }
    
    private func loadInitialMovies() async {
        do {
            let firstPageResponse = try await repository.getMovies(page: 1)
            if let lastMovieFromFirstPage = firstPageResponse.movies?.last {
                moviesBuffer.append(lastMovieFromFirstPage)
            }
            
            let secondPageResponse = try await repository.getMovies(page: 2)
            let thirdPageResponse = try await repository.getMovies(page: 3)
            
            if let moviesFromSecondPage = secondPageResponse.movies {
                moviesBuffer.append(contentsOf: moviesFromSecondPage)
            }
            if let moviesFromThirdPage = thirdPageResponse.movies {
                moviesBuffer.append(contentsOf: moviesFromThirdPage)
            }
        } catch {
            print("Ошибка при загрузке начальных фильмов: \(error)")
        }
    }

    private func loadNextPage() async throws -> MoviesPagedListResponseModel {
        return try await repository.getMovies(page: currentPage)
    }
}
