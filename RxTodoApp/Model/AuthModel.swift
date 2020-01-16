//
//  AuthRepository.swift
//  RxTodoApp
//
//  Created by 大瀧輝 on 2020/01/13.
//  Copyright © 2020 Hikaru Otaki. All rights reserved.
//

import Foundation
import Firebase
import RxSwift

class AuthRepository {
    
    func signUp(with email: String, and password: String) -> Observable<User> {
        return Observable.create { observer in
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                if let e = error {
                    print(e.localizedDescription)
                    observer.onError(e)
                    return
                }
                guard let user = user?.user.email else { return }
                observer.onNext(User(email: user))
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
}
