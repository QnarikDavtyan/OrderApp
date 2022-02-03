//
//  CategoriesResponse.swift
//  OrderApp
//
//  Created by Qnarik Davtyan on 30.01.22.
//

import Foundation


struct CategoriesResponse: Codable {
    let categories: [String]
}

func fetchCategories() async throws -> [String] {
    let categoriesURL = MenuController.baseURL.appendingPathComponent("categories")
    let (data, response) = try await URLSession.shared.data(from: categoriesURL)
    
    guard let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode == 200
    else { throw MenuControllerError.categoriesNotFound }
    
    let decoder = JSONDecoder()
    let categoriesResponse = try decoder.decode(
        CategoriesResponse.self, from: data)
    
    return categoriesResponse.categories
}
