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

func fetchCategories(completion: @escaping (Result<[String], Error>) -> Void) {
    let categoriesURL = MenuController.baseURL.appendingPathComponent("categories")
    let task = URLSession.shared.dataTask(with: categoriesURL) { (data, response, error) in
        if let data = data {
            do {
                let jsonDecoder = JSONDecoder()
                let categoriesResponse =
                try jsonDecoder.decode(CategoriesResponse.self, from: data)
                completion(.success(categoriesResponse.categories))
            } catch {
                completion(.failure(error))
            }
        } else if let error = error {
            completion(.failure(error))
        }
    }
    task.resume()
}
