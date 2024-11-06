//
//  Notification+Extensions.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 06.11.2024.
//

import Foundation

extension Notification.Name {
    static let unauthorizedErrorOccurred = Notification.Name("unauthorizedErrorOccurred")
    static let didLoadMovies = Notification.Name("didLoadMovies")
}
