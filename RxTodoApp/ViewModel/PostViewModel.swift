//
//  PostViewModel.swift
//  RxTodoApp
//
//  Created by 大瀧輝 on 2020/01/18.
//  Copyright © 2020 Hikaru Otaki. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PostViewModel: ViewModelType {
    
    struct Input {
        let postTrigger: Driver<Void>
        let content: Driver<String>
    }
    
    struct Output {
        let post: Driver<Void>
        let postButtonEnabled: Driver<Bool>
        let isLoading: Driver<Bool>
    }
    
    struct State {
        let indicator = ActivityIndicator()
    }
    
    private var postModel: PostModel
    private var navigator: PostNavigator
    private var validation: Validator
    
    init(postModel: PostModel, navigator: PostNavigator, validator: Validator) {
        self.postModel = postModel
        self.navigator = navigator
        self.validation = validator
    }
    
    func transform(input: PostViewModel.Input) -> PostViewModel.Output {
        let state = State()
        let post = input.postTrigger.withLatestFrom(input.content).flatMapLatest { content -> Driver<Void> in
            return self.postModel.create(with: content).trackActivity(state.indicator).asDriver(onErrorJustReturn: ())
                .do(onNext: { _ in
                    self.navigator.toPost()
                })
        }
        
        let result = input.content.map { content in
            self.validation.validateContent(content: content).isEnabled
        }
        
        return Output(post: post, postButtonEnabled: result, isLoading: state.indicator.asDriver())
    }
    
}

