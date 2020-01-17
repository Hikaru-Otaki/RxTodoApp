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
        
        bind()
    }
    
    func bind() {
        let loginViewModel = LoginViewModel(with: AuthModel(), and: LoginNavigator(with: self))
        let input = LoginViewModel.Input(password: passwordTextField.rx.text.orEmpty.asObservable(), email: emailTextField.rx.text.orEmpty.asObservable(), trigger: loginButton.rx.tap.asObservable())
        
        let output = loginViewModel.transform(input: input)
        output.login.subscribe(onError: { _ in
            self.showLoginErrorAlert()
            }).disposed(by: disposeBag)
    }
    
    func showLoginErrorAlert() {
        let alert: UIAlertController = UIAlertController(title: "Login Error", message: "An error has occurred, try one more", preferredStyle:  UIAlertController.Style.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            print("OK")
        })
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }

}
