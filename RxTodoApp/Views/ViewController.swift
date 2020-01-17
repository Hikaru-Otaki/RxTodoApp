//
//  ViewController.swift
//  RxTodoApp
//
//  Created by 大瀧輝 on 2020/01/17.
//  Copyright © 2020 Hikaru Otaki. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class ViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let viewModel = ViewModel()
        
        let output = viewModel.transform(input: ViewModel.Input(trigger: button.rx.tap.asObservable()))
//        output.isLoading.bind(to: SVProgressHUD.rx.isAnimating)
                
        output.load.subscribe().disposed(by: bag)
        
//        viewModel.indicator
//            .bind(to: SVProgressHUD.rx.isAnimating)
//            .disposed(by: bag)
//
//        viewModel.action
//            .subscribe()
//            .disposed(by: bag)
//
//        viewModel.indicator.subscribe(onNext: { bool in
//            print(bool)
//            }).disposed(by: bag)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
