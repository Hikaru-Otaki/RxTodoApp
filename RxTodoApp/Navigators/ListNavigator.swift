//
//  ListNavigator.swift
//  RxTodoApp
//
//  Created by 大瀧輝 on 2020/01/17.
//  Copyright © 2020 Hikaru Otaki. All rights reserved.
//

import Foundation
import UIKit

class ListNavigator {
    private weak var viewController: ListViewController?
    
    init(with viewController: ListViewController) {
        self.viewController = viewController
    }
    
    func toPost(with selectedPost: Post? = nil) {
        viewController?.performSegue(withIdentifier: "toPost", sender: selectedPost)
    }
}
