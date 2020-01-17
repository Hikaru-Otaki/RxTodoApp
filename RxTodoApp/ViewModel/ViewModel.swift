//
//  viewmodel.swift
//  RxTodoApp
//
//  Created by 大瀧輝 on 2020/01/17.
//  Copyright © 2020 Hikaru Otaki. All rights reserved.
//


import Foundation
import RxSwift
import RxCocoa

class ViewModel {
    
    struct Input {
        let trigger: Observable<Void>
    }
    
    struct Output {
        let load: Observable<String>
    }

    func transform(input: ViewModel.Input) -> ViewModel.Output {
        let load = input.trigger.flatMap { _ in
            return ViewModel.l.observeOn(MainScheduler.instance)
        }
        return Output(load: load)
    }
    
    static var l:Observable<String> {
        return Observable.just("false").delay(.seconds(3), scheduler: MainScheduler.instance)
    }

}
