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
        let deleteTrigger: Driver<Int>
    }
    
    struct Output {
        let posts: Observable<[Post]>
        let addTrigger: Driver<Bool>
        let isLoading: Driver<Bool>
        let deletePost: Driver<Void>
//        let o: Observable<Void>
    }
    
    struct State {
        let indicator = ActivityIndicator()
        var _array = BehaviorRelay<[Post]>(value: [])
    }
        
    private let postModel = PostModel()
    private let authModel = AuthModel()
    
    
    func transform(input: ListViewModel.Input) -> ListViewModel.Output {
        let state = State()
        let load = input.trigger.flatMap { [unowned self] _ in
            return self.authModel.checkLogin()
        }.flatMap { [unowned self] _ in
            return self.postModel.read().trackActivity(state.indicator)
        }.map { posts -> [Post]in
            state._array.accept(posts)
            print(state._array)
            return posts
        }
                
//        _ = load.map { (posts) in
//            self._array.accept(posts)
//        }
                
        let currentUser = self.authModel.checkLogin().map { _ in true }.asDriver(onErrorJustReturn: false )
        
        let delete = input.deleteTrigger.flatMapLatest { index in
            return self.postModel.delete(state._array.value[index].id).trackActivity(state.indicator).asDriver(onErrorJustReturn: ())
        }
        
//        let a = input.deleteTrigger.map { index -> Void in
//            print(state._array.value[index].id)
//        }
                
        return Output(posts: load, addTrigger: currentUser, isLoading: state.indicator.asDriver(), deletePost: delete)
    }

}
