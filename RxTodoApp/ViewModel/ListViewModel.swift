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
import Firebase

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
//        let user: Observable<FirebaseAuth.User>
    }
    
    private let postModel = PostModel()
    private let authModel = AuthModel()
    
    func transform(input: ListViewModel.Input) -> ListViewModel.Output {
        let state = State()
        let load = input.trigger.flatMap { [unowned self] _ in
            return self.authModel.checkLogin()
        }.flatMap { [unowned self] user in
            return self.postModel.read(uid: user.uid).trackActivity(state.indicator)
        }
//        let load = input.trigger.flatMap { [unowned self] _ -> Observable<[Post]> in
//            return self.postModel.read(uid: ).trackActivity(state.indicator)
//        }
        
        
        let currentUser = self.authModel.checkLogin().map { _ in true }.asDriver(onErrorJustReturn: false )
        
        return Output(posts: load.asObservable(), addTrigger: currentUser, isLoading: state.indicator.asDriver())
    }

}
