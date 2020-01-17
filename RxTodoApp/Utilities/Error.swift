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
