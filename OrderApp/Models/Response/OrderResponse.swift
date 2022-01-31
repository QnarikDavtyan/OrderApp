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

func submitOrder(forMenuIDs menuIDs: [Int], completion: @escaping (Result<MinutesToPrepare, Error>) -> Void) {
    let orderURL = MenuController.baseURL.appendingPathComponent("order")
    var request = URLRequest(url: orderURL)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let data = ["menuIDs": menuIDs]
    let jsonEncoder = JSONEncoder()
    let jsonData = try? jsonEncoder.encode(data)
    request.httpBody = jsonData
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let data = data {
            do {
                let jsonDecoder = JSONDecoder()
                let orderResponse =
                try jsonDecoder.decode(OrderResponse.self, from: data)
                completion(.success(orderResponse.prepTime))
            } catch {
                completion(.failure(error))
            }
        } else if let error = error {
            completion(.failure(error))
        }
    }
    task.resume()
}
