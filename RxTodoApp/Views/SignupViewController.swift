//
//  SignupViewController.swift
//  RxTodoApp
//
//  Created by 大瀧輝 on 2020/01/17.
//  Copyright © 2020 Hikaru Otaki. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class SignupViewController: UIViewController {
    
    @IBOutlet weak var emailTextFIeld: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    
    var signupViewModel: SignupViewModel!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeViewModel()
        bind()
    }
    
    func initializeViewModel() {
        self.signupViewModel = SignupViewModel(authModel: AuthModel(), navigator: SignupNavigator(with: self))
    }
    
    func bind() {
        let input = SignupViewModel.Input(email: emailTextFIeld.rx.text.orEmpty.asObservable(), password: passwordTextField.rx.text.orEmpty.asObservable(), trigger: signupButton.rx.tap.asObservable())
        
        let output = signupViewModel.transform(input: input)
        
        output.login.subscribe(onError: { _ in
            self.showLoginErrorAlert()
        }).disposed(by: disposeBag)
        
        output.isLoading.drive(SVProgressHUD.rx.isAnimating).disposed(by: disposeBag)
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
