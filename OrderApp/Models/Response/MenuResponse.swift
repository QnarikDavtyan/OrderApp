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
    forCategory categoryName: String) async throws -> [MenuItem] {
    let initialMenuURL = MenuController.baseURL.appendingPathComponent("menu")
    var components = URLComponents(
        url: initialMenuURL,
        resolvingAgainstBaseURL: true)!
    components.queryItems = [
                URLQueryItem(name: "category", value: categoryName)]
    let menuURL = components.url!
        
        let (data, response) = try await URLSession.shared.data(from: menuURL)
        
        guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200
        else { throw MenuControllerError.menuItemsNotFound }
        
        let decoder = JSONDecoder()
        let menuResponse = try decoder.decode(
            MenuResponse.self, from: data)
        
        return menuResponse.items
    }
