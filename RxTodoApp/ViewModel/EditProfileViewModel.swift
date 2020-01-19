//
//  EditProfileViewModel.swift
//  RxTodoApp
//
//  Created by 大瀧輝 on 2020/01/20.
//  Copyright © 2020 Hikaru Otaki. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class EditProfileViewModel: ViewModelType {
        
    struct Input {
        let saveTrigger: Driver<Bool>
        let username: Driver<String>
        let profileImage: Driver<UIImage>
    }
    
    struct Output {
        let edit: Driver<Void>
        let isLoading: Driver<Bool>
        let saveButtonEnabled: Driver<Bool>
    }
    
    private var authModel: AuthModel
    private var validator: Validator
    
    init(authModel: AuthModel, validator: Validator) {
        self.authModel = authModel
        self.validator = validator
    }
    
    func transform(input: EditProfileViewModel.Input) -> EditProfileViewModel.Output {
        
        let requiredInputs = Driver.combineLatest(input.username, input.profileImage)
        let edit = input.saveTrigger.withLatestFrom(requiredInputs).flatMapLatest { (username, image) in
            <#code#>
        }
    }
    
}
