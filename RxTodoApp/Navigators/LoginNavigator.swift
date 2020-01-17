//
//  LoginNavigator.swift
//  RxTodoApp
//
//  Created by 大瀧輝 on 2020/01/17.
//  Copyright © 2020 Hikaru Otaki. All rights reserved.
//

import Foundation
import UIKit

class LoginNavigator {
    private weak var viewController: LoginViewController?
    
    init(with viewController: LoginViewController) {
        self.viewController = viewController
    }
    
    func toList() {
        viewController?.performSegue(withIdentifier: "toList", sender: nil)
    }
    
    func toSignup() {
        viewController?.performSegue(withIdentifier: "toSignup", sender: nil)
    }
}
