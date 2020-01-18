//
//  PostViewController.swift
//  RxTodoApp
//
//  Created by 大瀧輝 on 2020/01/18.
//  Copyright © 2020 Hikaru Otaki. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class PostViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var postButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func bind() {
        let postViewModel = PostViewModel(postModel: PostModel())
        let input = PostViewModel.Input(postTrigger: postButton.rx.tap.asDriver(), content: textField.rx.text.orEmpty.asDriver())
        
        let output = postViewModel.transform(input: input)
        
        output.isLoading.drive(SVProgressHUD.rx.isAnimating).disposed(by: disposeBag)
        output.post.drive().disposed(by: disposeBag)
        output.postButtonEnabled.drive(postButton.rx.isEnabled).disposed(by: disposeBag)
    }

}
