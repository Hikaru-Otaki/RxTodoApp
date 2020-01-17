//
//  LoginViewModel.swift
//  RxTodoApp
//
//  Created by 大瀧輝 on 2020/01/17.
//  Copyright © 2020 Hikaru Otaki. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel: ViewModelType {

    struct Input {
        let password: Observable<String>
        let email: Observable<String>
        let trigger: Observable<Void>
    }

    struct Output {
        let login: Observable<User>
    }
    
    private let authModel: AuthModel
    private let navigator: LoginNavigator

    init(with authModel: AuthModel, and navigator: LoginNavigator) {
        self.authModel = authModel
        self.navigator = navigator
    }

//    func transform(input: LoginViewModel.Input) -> LoginViewModel.Output {
//        let requiredInputs = Observable.combineLatest(input.email, input.password)
//        let login = input.trigger.withLatestFrom(requiredInputs)
//            .flatMapLatest { [unowned self] (email: String, password: String) in
//                return self.authModel.login(with: email, and: password)
//        }
//        return Output(login: login)
//    }
    
    func transform(input: LoginViewModel.Input) -> LoginViewModel.Output {
        let requiredInputs = Observable.combineLatest(input.email, input.password)
        let login = input.trigger.withLatestFrom(requiredInputs)
            .flatMapLatest { email, password in
                return self.authModel.login(with: email, password: password).do(onNext: { _ in
                    self.navigator.toList()
                },onError: { error in
                    print(error)
                })
        }
        return Output(login: login)
    }

}
