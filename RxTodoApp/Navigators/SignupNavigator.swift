//
//  SignupNavigator.swift
//  RxTodoApp
//
//  Created by 大瀧輝 on 2020/01/17.
//  Copyright © 2020 Hikaru Otaki. All rights reserved.
//

import Foundation
import UIKit

class SignupNavigator {
    
    private weak var viewController: UIViewController?
    
    init(with viewController: SignupViewController) {
        self.viewController = viewController
    }
    
    func toList() {
        viewController?.performSegue(withIdentifier: "toList", sender: nil)
    }
    
}
