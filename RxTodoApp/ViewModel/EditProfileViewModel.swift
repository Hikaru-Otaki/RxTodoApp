//
//  EditProfileViewModel.swift
//  RxTodoApp
//
//  Created by 大瀧輝 on 2020/01/20.
//  Copyright © 2020 Hikaru Otaki. All rights reserved.


import Foundation
import RxSwift
import RxCocoa

class EditProfileViewModel {

    struct Input {
        let saveTrigger: Driver<Void>
        let username: Driver<String>
        let profileImage: Observable<UIImage??>
        let trigger: Driver<Void>
    }

    struct Output {
        let edit: Driver<Void>
        let isLoading: Driver<Bool>
        let saveButtonEnabled: Driver<Bool>
        let userInfo: Driver<User>
    }
    
    struct State {
        let indicator = ActivityIndicator()
    }
    
    let textcount = BehaviorSubject<String>(value: "")

    private var authModel: AuthModel
    private var validator: Validator
    private var navigator: EditProfileNavigator

    init(authModel: AuthModel, validator: Validator, navigator: EditProfileNavigator) {
        self.authModel = authModel
        self.validator = validator
        self.navigator = navigator
    }

    func transform(input: EditProfileViewModel.Input) -> EditProfileViewModel.Output {
        let state = State()
        let requiredInputs = Driver.combineLatest(input.username, input.profileImage.asDriverOnErrorJustComplete())
        let edit = input.saveTrigger.withLatestFrom(requiredInputs).flatMapLatest { [unowned self] username, image in
            return self.authModel.updateUser(username: username, image: image!!).trackActivity(state.indicator).asDriverOnErrorJustComplete()
        }.do(onNext: { _ in
            self.navigator.toList()
        })
        
        let userInfo = input.trigger.flatMap { [unowned self] _ in
            return self.authModel.getUser().asDriverOnErrorJustComplete()
        }
        
        userInfo.drive(onNext: { user in
            self.textcount.onNext(user.username)
            }).disposed(by: DisposeBag())
                
        let enabled = input.username.map { username -> Bool in
            print(username)
            return self.validator.validateUserName(username: username).isEnabled
        }
        
        return Output(edit: edit, isLoading: state.indicator.asDriver(), saveButtonEnabled: enabled, userInfo: userInfo)
    }

}
