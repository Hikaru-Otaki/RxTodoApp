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
        let username: Driver<String>
        let email: Driver<String>
        let password: Driver<String>
        let trigger: Observable<Void>
    }
    
    struct Output {
        let login: Observable<User>
        let isLoading: Driver<Bool>
        let signinButtonEnabled: Driver<Bool>
    }
    
    struct State {
        let indicator = ActivityIndicator()
    }
    
    private let authModel: AuthModel
    private let navigator: SignupNavigator
    private let validation: Validator
    
    init(authModel: AuthModel, navigator: SignupNavigator, validation: Validator) {
        self.authModel = authModel
        self.navigator = navigator
        self.validation = validation
    }
    
    func transform(input: SignupViewModel.Input) -> SignupViewModel.Output {
        let state = State()
        let requiredInputs = Driver.combineLatest(input.email, input.password)
        
        let login = input.trigger.withLatestFrom(requiredInputs)
            .flatMapLatest { (email: String, password: String) in
                return self.authModel.signUp(with: email, and: password)
                    .do(onNext: { _ in
                        self.navigator.toList()
                    }).trackActivity(state.indicator).catchErrorJustComplete()
        }
        
        let usernameValidation = input.username.map { username in
            self.validation.validateUserName(username: username)
        }.map { result in
            return result.isEnabled
        }
        
        let emailValidation = input.email.map { email in
            self.validation.validateUserName(username: email)
        }.map { result in
            return result.isEnabled
        }
        
        let passwordValidation = input.password.map { password in
            self.validation.validateUserName(username: password)
        }.map { result -> Bool in
//            print(result.isEnabled)
            return result.isEnabled
        }
        
        let result = Driver.combineLatest(usernameValidation, emailValidation, passwordValidation) {
            $0 && $1 && $2
        }
        
        return Output(login: login, isLoading: state.indicator.asDriver(), signinButtonEnabled: result)
    }
    
}
