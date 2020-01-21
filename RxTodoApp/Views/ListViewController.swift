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
    @IBOutlet weak var editProfileButton: UIBarButtonItem!
    @IBOutlet weak var navItem: UINavigationItem!
    
    var listViewModel: ListViewModel!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTableView()
        navigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bind()
        navigationBar()
    }
    
    func navigationBar() {
        navItem.title = "fff"
    }
    
    func initializeTableView() {
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil),forCellReuseIdentifier:"cell")
        tableView
        .rx.setDelegate(self)
        .disposed(by: disposeBag)
    }
    
    func bind() {
        listViewModel = ListViewModel()
        let input = ListViewModel.Input(trigger: Observable.just(()), deleteTrigger: tableView.rx.itemDeleted.asDriver().map { $0.row })
        let output = listViewModel.transform(input: input)
        
        output.posts.bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: CustomTableViewCell.self)) { row, element, cell in
            cell.setcell(content: element.content, date: element.date)
        }.disposed(by: disposeBag)
        
        output.load.drive().disposed(by: disposeBag)
        output.deletePost.drive().disposed(by: disposeBag)
        output.addTrigger.drive(onNext: { [unowned self] isEnabled in
            self.addButton.isEnabled = isEnabled
            self.editProfileButton.isEnabled = isEnabled
            }).disposed(by: disposeBag)
        output.isLoading.drive(SVProgressHUD.rx.isAnimating).disposed(by: disposeBag)
        output.userState.bind { [unowned self] user in
            self.navItem.title = "\(user.username)'s Todo"
        }.disposed(by: disposeBag)
        output.test.subscribe().disposed(by: disposeBag)
    }
    
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 106
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal,
                                            title:  "Edit",
                                            handler: { (action: UIContextualAction, view: UIView, success :(Bool) -> Void) in
                                                success(true)
        })
        editAction.image = UIImage(named: "edit")
        editAction.backgroundColor = .yellow
        
        return UISwipeActionsConfiguration(actions: [editAction])
    }
}
