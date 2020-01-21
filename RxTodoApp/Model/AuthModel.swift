//
//  AuthModel.swift
//  RxTodoApp
//
//  Created by 大瀧輝 on 2020/01/13.
//  Copyright © 2020 Hikaru Otaki. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import RxSwift

class AuthModel {
    
    let db: Firestore
    
    init() {
        self.db = Firestore.firestore()
    }
    
    func checkLogin() -> Observable<FirebaseAuth.User> {
        return Observable.create { observer -> Disposable in
            if let user = Auth.auth().currentUser {
                print(user.email as Any)
                observer.onNext(user)
            } else {
                observer.onCompleted()
        }
            return Disposables.create()
        }
    }
    
    func getUser() -> Observable<User> {
        guard let userUid = Auth.auth().currentUser?.uid else { return Observable.empty() }
        return Observable.create { observer -> Disposable in
            self.db.collection("users").document(userUid).getDocument { snapshot, error in
                if error != nil {
                    print(error as Any)
                    observer.onError(Exception.auth)
                } else {
                    if let doc = snapshot?.data() {
                        observer.onNext(User(username: (doc["username"] as! String) , email: doc["email"] as! String, id: doc["uid"] as! String, profileImage: doc["profileImage"] as! String))
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    func signUp(username: String, email: String, password: String) -> Observable<User> {
        return Observable.create { observer in
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                if let e = error {
                    print(e.localizedDescription)
                    observer.onError(e)
                    return
                } 
                guard let user = user else { return }
                self.db.collection("users").document(user.user.uid).setData([
                    "username" : username,
                    "email": email,
                    "uid"  : user.user.uid
                ])
                observer.onNext(User(username: username, email: email, id: user.user.uid))
            }
            return Disposables.create()
        }
    }
    
    func login(with email: String, password: String) -> Observable<User> {
        return Observable.create { observer in
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if let error = error {
                    observer.onError(error)
                    return
                }
                
                guard let user = user?.user else {
                    observer.onError(error!)
                    return
                }
                observer.onNext(User(username: user.displayName!, email: email, id: user.uid))
            }
            return Disposables.create()
        }
    }
    
    func updateUser(username: String, image: UIImage?) -> Observable<Void> {
        guard let user = Auth.auth().currentUser else { return Observable.empty() }
        return Observable.create { observer -> Disposable in
            if let image = image {
            self.uploadStorage(image: image) { result in
                switch result {
                case .failure(let error):
                    observer.onError(error)
                    return
                case .success(let path):
                    self.db.collection("users").document(user.uid).updateData([
                        "username"    : username,
                        "profileImage": path
                    ]) { (error) in
                        if error != nil {
                            print(error as Any)
                            observer.onError(Exception.server)
                            return
                        }
                        observer.onNext(())
                        observer.onCompleted()
                    }
                }
            }
            
            } else {
                self.db.collection("users").document(user.uid).updateData([
                    "username"    : username
                ]) { (error) in
                    if error != nil {
                        print(error as Any)
                        observer.onError(Exception.server)
                        return
                    }
                    observer.onNext(())
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
        
    }
    
    func uploadStorage(image: UIImage, completion: @escaping (Result<String, Exception>) -> Void) {
        let path = self.profileStoragePath()
        let storageRef = Storage.storage().reference().child(path)
        guard let data = image.jpegData(compressionQuality: 0.25) else {
            print("UIImage convert to jpeg error ")
            return
        }
        
        storageRef.putData(data, metadata: nil) { metadata, error in
            if metadata == nil {
                print("metadata nil")
                completion(.failure(Exception.server))
                return
            } else if error != nil {
                print(error as Any)
                completion(.failure(Exception.unknown))
                return
            }
            completion(.success(path))
        }

    }
    
    func profileStoragePath() -> String {
        let timeInterval = Date().timeIntervalSince1970
        let datetime = Date(timeIntervalSince1970: timeInterval)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        let stringDatetime = formatter.string(from: datetime)
        let path: String = "images/profile/\(stringDatetime)-\(arc4random_uniform(1000000)).jpg"
        return path
    }
    
    func signout() {
        try! Auth.auth().signOut()
    }
}
