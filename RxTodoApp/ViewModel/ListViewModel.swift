//
//  PostViewModel.swift
//  RxTodoApp
//
//  Created by 大瀧輝 on 2020/01/16.
//  Copyright © 2020 Hikaru Otaki. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SVProgressHUD

class ListViewModel: ViewModelType {
   
    struct Input {
        let trigger: Observable<Void>
    }
    
    struct Output {
        let posts: Observable<[Post]>
        let addTrigger: Driver<Bool>
    }
    
    var isAnimating = BehaviorRelay<Bool>(value: false)

    private let postModel = PostModel()
    private let authModel = AuthModel()
    
    func transform(input: ListViewModel.Input) -> ListViewModel.Output {
        let load = input.trigger.flatMap { [unowned self] _ -> Observable<[Post]> in
            self.isAnimating.accept(true)
            return self.postModel.read().do(onNext: { _ in
                self.isAnimating.accept(false)
            }, onError: { _ in
                self.isAnimating.accept(false)
            })
        }
        
        
        let currentUser = self.authModel.checkLogin().map { _ in true }.asDriver(onErrorJustReturn: false )
        
        return Output(posts: load.asObservable(), addTrigger: currentUser)
    }

}
