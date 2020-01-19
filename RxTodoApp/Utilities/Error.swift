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
    case failed(message: String)
    

    var description: String {
        switch self {
        case let .ok(message) : return message
        case let .empty(message) : return message
        case let .failed(message) : return message
        }
    }

    var isEnabled: Bool {
        switch self {
        case .ok:
            return true
        default:
            return false
        }
    }
}

class Validator {
    let maxContentCount = 10
    let minContentCount = 1
    
    func validateContent(content: String) -> ValidationResult {
        if content.count < minContentCount {
            return .empty(message: "empty")
        }
        
        if content.count > maxContentCount {
            return .failed(message: "too much")
        }
        return .ok(message: "ok")
    }
    
    func validateUserName(username: String) -> ValidationResult {
        if username.count <= minContentCount {
            return .empty(message: "empty")
        }
        
        if  username.count >= maxContentCount {
            return .failed(message: "too much")
        }
        return .ok(message: "ok")
    }
    
}

