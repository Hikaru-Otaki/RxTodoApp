//
//  AuthModel.swift
//  RxTodoApp
//
//  Created by 大瀧輝 on 2020/01/13.
//  Copyright © 2020 Hikaru Otaki. All rights reserved.
//

import Foundation
import Firebase
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
    
    func signUp(with email: String, and password: String) -> Observable<User> {
        return Observable.create { observer in
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                if let e = error {
                    print(e.localizedDescription)
                    observer.onError(e)
                    return
                }
                guard let user = user else { return }
                self.db.collection("users").addDocument(data: ["email": user.user.email as Any])
                observer.onNext(User(email: user.user.email))
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
                observer.onNext(User(email: user.email))
            }
            return Disposables.create()
        }
    }
    
    func signout() {
        try! Auth.auth().signOut()
    }
}
