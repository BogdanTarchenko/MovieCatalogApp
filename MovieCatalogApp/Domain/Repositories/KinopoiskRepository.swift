//
//  KinopoiskRepository.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 02.11.2024.
//

protocol KinopoiskRepository {
    func getKinopoiskDetails(yearFrom: Int, yearTo: Int, keyword: String) async throws -> FilmSearchByFiltersResponse
}
