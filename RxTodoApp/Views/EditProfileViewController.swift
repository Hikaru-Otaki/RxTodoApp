//
//  EditProfileViewController.swift
//  RxTodoApp
//
//  Created by 大瀧輝 on 2020/01/20.
//  Copyright © 2020 Hikaru Otaki. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD
import FirebaseStorage
import FirebaseUI

class EditProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var editUsernameTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeUI()
        buid()
    }
    
    func initializeUI() {
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 75
    }
    
    func buid() {
        let editProfileViewModel = EditProfileViewModel(authModel: AuthModel(), validator: Validator(), navigator: EditProfileNavigator(with: self))
        let input = EditProfileViewModel.Input(saveTrigger: saveButton.rx.tap.asDriver(), username: editUsernameTextField.rx.text.orEmpty.asDriver(), profileImage: profileImageView.rx.observe(Optional<UIImage>.self, "image"), trigger: Driver.just(()))
        let output = editProfileViewModel.transform(input: input)
        output.edit.drive().disposed(by: disposeBag)
        output.isLoading.drive(SVProgressHUD.rx.isAnimating).disposed(by: disposeBag)
//        output.saveButtonEnabled.dri
//
        output.userInfo.drive(onNext: { user in
            let placeholderImage = UIImage(named: "image")
            let imageReference = Storage.storage().reference().child(user.profileImage ?? "")
            self.profileImageView.sd_setImage(with: imageReference, placeholderImage: placeholderImage)
            self.editUsernameTextField.text = user.username
        }).disposed(by: disposeBag)
    }
    
    @IBAction func pickImage(_ sender: Any) {
        pickImageAlertAction()
    }

    func pickImageAlertAction() {
        let actionController = UIAlertController(title: "画像の選択", message: "選択してください", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "カメラ", style: .default) { action in

            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let picker = UIImagePickerController()

                picker.sourceType = .camera
                picker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
                self.present(picker, animated: true)
            } else {
                print("この機種ではカメラが使用できません")
            }
        }
        let albumAction = UIAlertAction(title: "フォトライブラリ", style: .default) { action in

            let picker = UIImagePickerController()
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {

                picker.sourceType = .photoLibrary
                picker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
                self.present(picker, animated: true)
            } else {
                print("この機種ではフォトライブラリが使用できません")
            }
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { action in
            actionController.dismiss(animated: true)
        }
        actionController.addAction(cameraAction)
        actionController.addAction(albumAction)
        actionController.addAction(cancelAction)
        self.present(actionController, animated: true)
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        let profileImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.profileImageView.image = profileImage

        picker.dismiss(animated: true)
    }
}
