//
//  OrderResponse.swift
//  OrderApp
//
//  Created by Qnarik Davtyan on 30.01.22.
//

import Foundation

struct OrderResponse: Codable {
    let prepTime: Int
    
    enum CodingKeys: String, CodingKey {
        case prepTime = "preparation_time"
    }
}
typealias MinutesToPrepare = Int

func submitOrder(forMenuIDs menuIDs: [Int]) async throws -> MinutesToPrepare {
    let orderURL = MenuController.baseURL.appendingPathComponent("order")
    var request = URLRequest(url: orderURL)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let menuIdDict = ["menuIDs": menuIDs]
    let jsonEncoder = JSONEncoder()
    let jsonData = try? jsonEncoder.encode(menuIdDict)
    request.httpBody = jsonData
    
    let (data, response) = try await URLSession.shared.data(
        for: request)
    
    guard let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode == 200
    else { throw MenuControllerError.orderRequestFailed }
    
    let decoder = JSONDecoder()
    let orderResponse = try decoder.decode(
        OrderResponse.self, from: data)
    
    return orderResponse.prepTime
}
