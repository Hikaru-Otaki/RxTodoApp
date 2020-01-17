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
    }
    
    let isAnimating = BehaviorRelay<Bool>(value: false)

    private let postModel = PostModel()
    
    func transform(input: ListViewModel.Input) -> ListViewModel.Output {
        let load = input.trigger.flatMap { [unowned self] _ -> Observable<[Post]> in
            self.isAnimating.accept(true)
            return self.postModel.read().do(onNext: { _ in
                self.isAnimating.accept(false)
            }, onError: { _ in
                SVProgressHUD.dismiss()
            })
        }
        
        return Output(posts: load.asObservable())
    }

}
