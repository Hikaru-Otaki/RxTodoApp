//
//  LoginViewController.swift
//  RxTodoApp
//
//  Created by 大瀧輝 on 2020/01/13.
//  Copyright © 2020 Hikaru Otaki. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var authModel: AuthModel!
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let source = Observable.combineLatest(emailTextField.rx.text.asObservable(), passwordTextField.rx.text.asObservable())
//        source.skip(1).subscribe(onNext: { text1, text2 in
//            print(text1 as Any)
//            print(text2 as Any)
//            }).disposed(by: disposeBag)
        let button = loginButton.rx.tap.asObservable()
        let a = emailTextField.rx.text.orEmpty.asObservable()
        let b = passwordTextField.rx.text.orEmpty.asObservable()
        let combine = Observable.combineLatest(a, b)
//        let c = button.withLatestFrom(combine)
//            .subscribe(onNext: { text in
//            print(text)
//            }).disposed(by: disposeBag)
//
        let c = button.withLatestFrom(combine).flatMap { (text1, text2) -> Observable<User> in
            return self.authModel.login(with: text1, password: text2)
        }
  
//        source1.skip(1).subscribe(onNext: { text1, text2 in
//            print(text1 as Any)
//            print(text2 as Any)
//            }).disposed(by: disposeBag)
//
        
//        let source1 = Observable.just("aaa").withLatestFrom(Observable.just(3))
//
//        source1.subscribe(onNext: { int in
//            print(int)
//            }).disposed(by: disposeBag)
//        self.loginButton.rx.tap.asDriver().drive(onNext: { [unowned self] _ in
//            guard let email = self.emailTextField.text, let password = self.passwordTextField.text else { return }
//
//            self.authModel.login(with: email, password: password).subscribe { user in
//                print(user.element as Any)
//            }.disposed(by: self.disposeBag)
//            }).disposed(by: disposeBag)
    }


}
