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
        let isLoading: Driver<Bool>
    }
    
    struct State {
        let indicator = ActivityIndicator()
    }
    
    private let postModel = PostModel()
    private let authModel = AuthModel()
    
    func transform(input: ListViewModel.Input) -> ListViewModel.Output {
        let state = State()
        let load = input.trigger.flatMap { [unowned self] _ -> Observable<[Post]> in
            return self.postModel.read().trackActivity(state.indicator)
        }
        
        
        let currentUser = self.authModel.checkLogin().map { _ in true }.asDriver(onErrorJustReturn: false )
        
        return Output(posts: load.asObservable(), addTrigger: currentUser, isLoading: state.indicator.asDriver())
    }

}
