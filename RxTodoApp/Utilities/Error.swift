//
//  Error.swift
//  RxTodoApp
//
//  Created by 大瀧輝 on 2020/01/18.
//  Copyright © 2020 Hikaru Otaki. All rights reserved.
//

import Foundation

enum Exception: Error {
    case network
    case auth
    case server
    case generic(message: String)
    case unknown
}

enum ValidationResult {
    case ok(message: String)
    case empty(message: String)
    case validating
    case failed(message: String)

    var description: String {
        switch self {
        case let .ok(message) : return message
        case let .empty(message) : return message
        case .validating : return ""
        case let .failed(message) : return message
        }
    }

    var isValid: Bool {
        switch self {
        case .ok:
            return true
        default:
            return false
        }
    }
}
