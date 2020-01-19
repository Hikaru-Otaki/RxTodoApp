//
//  EditProfileViewController.swift
//  RxTodoApp
//
//  Created by 大瀧輝 on 2020/01/20.
//  Copyright © 2020 Hikaru Otaki. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var efitUsernameTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeUI()
    }
    
    func initializeUI() {
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 75
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
