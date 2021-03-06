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
        let isLoading: Driver<Bool>
    }
    
    struct State {
        let isLoading = ActivityIndicator()
    }
    
    private let authModel: AuthModel
    private let navigator: LoginNavigator

    init(with authModel: AuthModel, and navigator: LoginNavigator) {
        self.authModel = authModel
        self.navigator = navigator
    }
    
    func transform(input: LoginViewModel.Input) -> LoginViewModel.Output {
        let state = State()
        let requiredInputs = Observable.combineLatest(input.email, input.password)
        let login = input.trigger.withLatestFrom(requiredInputs)
            .flatMapLatest { email, password in
                return self.authModel.login(with: email, password: password)
                    .trackActivity(state.isLoading)
                    .do(onNext: { _ in
                    self.navigator.toList()
                    }).catchErrorJustComplete()
        }
        return Output(login: login, isLoading: state.isLoading.asDriver())
    }

}
