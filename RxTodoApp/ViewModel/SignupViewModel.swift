//
//  SignupViewModel.swift
//  RxTodoApp
//
//  Created by 大瀧輝 on 2020/01/17.
//  Copyright © 2020 Hikaru Otaki. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SignupViewModel: ViewModelType {
    
    struct Input {
        let email: Observable<String>
        let password: Observable<String>
        let trigger: Observable<Void>
    }
    
    struct Output {
        let login: Observable<User>
    }
    
    private let authModel: AuthModel
    private let navigator: SignupNavigator
    
    init(authModel: AuthModel, navigator: SignupNavigator) {
        self.authModel = authModel
        self.navigator = navigator
    }
    
    func transform(input: SignupViewModel.Input) -> SignupViewModel.Output {
        let requiredInputs = Observable.combineLatest(input.email, input.password)
        let login = input.trigger.withLatestFrom(requiredInputs)
            .flatMapLatest { (email: String, password: String) in
                return self.authModel.signUp(with: email, and: password)
                    .do(onNext: { _ in
                        self.navigator.toList()
                    })
        }
        return Output(login: login)
    }
    
}
