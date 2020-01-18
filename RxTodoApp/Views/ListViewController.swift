//
//  ListViewController.swift
//  RxTodoApp
//
//  Created by 大瀧輝 on 2020/01/10.
//  Copyright © 2020 Hikaru Otaki. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD
import Firebase

class ListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var listViewModel: ListViewModel!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let authModel = AuthModel()
//        authModel.signout()
//        if let user = Auth.auth().currentUser {
//            let s = PostModel()
//            s.create(with: "first", uid: user.uid).subscribe().disposed(by: disposeBag)
//            s.create(with: "second", uid: user.uid).subscribe().disposed(by: disposeBag)
//            s.create(with: "third", uid: user.uid).subscribe().disposed(by: disposeBag)
//            s.create(with: "fouth", uid: user.uid).subscribe().disposed(by: disposeBag)
//            s.create(with: "wow", uid: user.uid).subscribe().disposed(by: disposeBag)

//        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bind()
    }
    
    func bind() {
        listViewModel = ListViewModel()
        let input = ListViewModel.Input(trigger: Observable.just(()), deleteTrigger: tableView.rx.itemDeleted.asDriver().map { $0.row })
        let output = listViewModel.transform(input: input)
                        
        output.posts.bind(to: tableView.rx.items(cellIdentifier: "cell")) {row,element,cell in
            cell.textLabel?.text = element.content
            cell.detailTextLabel?.text = element.id
        }
        .disposed(by: disposeBag)
        
//        let selecetedPost = tableView.rx.itemSelected.map({ indexPath in
//            print(indexPath.row)
//            }).subscribe().disposed(by: disposeBag)
        output.deletePost.drive().disposed(by: disposeBag)
//        output.o.subscribe().disposed(by: disposeBag)
        
        output.addTrigger.drive(addButton.rx.isEnabled).disposed(by: disposeBag)
        
        output.isLoading.drive(SVProgressHUD.rx.isAnimating).disposed(by: disposeBag)
    }
    
}
