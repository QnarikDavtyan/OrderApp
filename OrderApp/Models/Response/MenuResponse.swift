//
//  Response.swift
//  OrderApp
//
//  Created by Qnarik Davtyan on 30.01.22.
//

import Foundation

struct MenuResponse: Codable {
    let items: [MenuItem]
}

func fetchMenuItem(
    forCategory categoryName: String,
    completion: @escaping (Result<[MenuItem], Error>) -> Void) {
    let baseMenuURL = MenuController.baseURL.appendingPathComponent("menu")
    var components = URLComponents(
        url: baseMenuURL,
        resolvingAgainstBaseURL: true)!
    components.queryItems = [
                URLQueryItem(name: "category", value: categoryName)]
    let menuURL = components.url!
        
    let task = URLSession.shared.dataTask(with: menuURL) {
        (data, response, error) in
        if let data = data {
            do {
                let jsonDecoder = JSONDecoder()
                let menuResponse =
                    try jsonDecoder.decode(MenuResponse.self, from: data)
                completion(.success(menuResponse.items))
                } catch {
                completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
}
        task.resume()
    }
