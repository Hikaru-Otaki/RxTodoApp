//
//  PostNavigator.swift
//  RxTodoApp
//
//  Created by 大瀧輝 on 2020/01/19.
//  Copyright © 2020 Hikaru Otaki. All rights reserved.
//

import Foundation
import UIKit

class PostNavigator {
    private weak var viewController: PostViewController?
    
    init(with viewController: PostViewController) {
        self.viewController = viewController
    }
    
    func toPost() {
        viewController?.performSegue(withIdentifier: "toPost", sender: nil)
    }

}
