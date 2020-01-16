//
//  ViewModelType.swift
//  RxTodoApp
//
//  Created by 大瀧輝 on 2020/01/16.
//  Copyright © 2020 Hikaru Otaki. All rights reserved.
//

import Foundation

protocol ViewModelType {
    
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
