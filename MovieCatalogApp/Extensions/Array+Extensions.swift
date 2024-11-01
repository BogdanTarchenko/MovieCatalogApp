//
//  Array+Extensions.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 02.11.2024.
//

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        var chunks: [[Element]] = []
        for index in stride(from: 0, to: count, by: size) {
            let chunk = Array(self[index..<Swift.min(index + size, count)])
            chunks.append(chunk)
        }
        return chunks
    }
}
