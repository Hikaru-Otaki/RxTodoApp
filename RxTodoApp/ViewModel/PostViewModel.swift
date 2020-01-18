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
    
    init(postModel: PostModel) {
        self.postModel = postModel
    }
    
    let validation = Validator()

    func transform(input: PostViewModel.Input) -> PostViewModel.Output {
        let state = State()
        let post = input.postTrigger.withLatestFrom(input.content).flatMapLatest { content -> Driver<Void> in
            return self.postModel.create(with: content).trackActivity(state.indicator).asDriver(onErrorJustReturn: ())
        }
        
        let result = input.content.map { content in
            self.validation.validateContent(content: content).isValid
        }
                
        return Output(post: post, postButtonEnabled: result, isLoading: state.indicator.asDriver())
    }
    
}

class Validator {
    let maxContentCount = 9
    let minContentCount = 1
    
    func validateContent(content: String) -> ValidationResult {
        if content.count < minContentCount {
            return .failed(message: "message")
        }
        
        if content.count > maxContentCount {
            return .failed(message: "messege")
        }
        return .ok(message: "ok")
    }
}
