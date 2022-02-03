//
//  MenuController.swift
//  OrderApp
//
//  Created by Qnarik Davtyan on 31.01.22.
//

import Foundation
import CoreText

class MenuController {
     static let baseURL = URL(string: "http://localhost:8080/")!
}

enum MenuControllerError: Error, LocalizedError {
    case categoriesNotFound
    case menuItemsNotFound
    case orderRequestFailed
}
