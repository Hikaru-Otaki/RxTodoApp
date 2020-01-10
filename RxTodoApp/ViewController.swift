//
//  ViewController.swift
//  RxTodoApp
//
//  Created by 大瀧輝 on 2020/01/10.
//  Copyright © 2020 Hikaru Otaki. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    var postRepository: PostRepository!
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        postRepository = PostRepository()
        postRepository.create(with: "First!").subscribe(onNext: { _ in
            print("Done")
            }).disposed(by: disposeBag)
        postRepository.create(with: "Second!").subscribe(onNext: { _ in
            print("Done2")
            }).disposed(by: disposeBag)
        postRepository.create(with: "Third!").subscribe(onNext: { _ in
            print("Done3")
            }).disposed(by: disposeBag)
        
    }


}

