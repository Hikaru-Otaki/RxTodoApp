//
//  EditProfileNavigator.swift
//  RxTodoApp
//
//  Created by 大瀧輝 on 2020/01/21.
//  Copyright © 2020 Hikaru Otaki. All rights reserved.
//

import Foundation
import UIKit

class EditProfileNavigator {
    private weak var viewController: EditProfileViewController?
    
    init(with viewController: EditProfileViewController) {
        self.viewController = viewController
    }
    
    func toList() {
        viewController?.dismiss(animated: true, completion: nil)
    }

}
