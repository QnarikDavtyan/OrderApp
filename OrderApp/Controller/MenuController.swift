//
//  MenuController.swift
//  OrderApp
//
//  Created by Qnarik Davtyan on 31.01.22.
//

import Foundation
import CoreText

class MenuController {
    static let shared = MenuController()
    let baseURL = URL(string:"http://localhost:8080/")!
    static let orderUpdateNotification = Notification.Name("MenuController.orderUpdated")
    var order = Order() { didSet {
        NotificationCenter.default.post(
            name: MenuController.orderUpdateNotification,
            object: nil
        ) }
    }

enum MenuControllerError: Error, LocalizedError {
    case categoriesNotFound
    case menuItemsNotFound
    case orderRequestFailed
}


func fetchCategories() async throws -> [String] {
    let categoriesURL = baseURL.appendingPathComponent("categories")
    let (data, response) = try await URLSession.shared.data(from:categoriesURL)
    
    guard let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode == 200
    else { throw MenuControllerError.categoriesNotFound }
    
    let decoder = JSONDecoder()
    let categoriesResponse = try decoder.decode(
        CategoriesResponse.self, from: data)
    return categoriesResponse.categories
}
    
    func fetchMenuItem(
        forCategory categoryName: String) async throws -> [MenuItem] {
        let initialMenuURL = baseURL.appendingPathComponent("menu")
        guard var components = URLComponents(
            url: initialMenuURL, resolvingAgainstBaseURL: true)
            else { fatalError() }
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
    
    typealias MinutesToPrepare = Int

    func submitOrder(forMenuIDs menuIDs: [Int]) async throws -> MinutesToPrepare {
        let orderURL = baseURL.appendingPathComponent("order")
        var request = URLRequest(url: orderURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let menuIdDict = ["menuIDs": menuIDs]
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(menuIdDict)
        request.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200
        else { throw MenuControllerError.orderRequestFailed }
        
        let decoder = JSONDecoder()
        let orderResponse = try decoder.decode(
            OrderResponse.self, from: data)
        
        return orderResponse.prepTime
    }
}
