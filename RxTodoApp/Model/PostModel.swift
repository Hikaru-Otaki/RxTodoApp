//
//  PostModel.swift
//  RxTodoApp
//
//  Created by 大瀧輝 on 2020/01/10.
//  Copyright © 2020 Hikaru Otaki. All rights reserved.
//

import Foundation
import Firebase
import RxSwift

class PostModel {
    
    let db: Firestore
    var listener: ListenerRegistration?
    var userUid: String?
    
    init() {
        self.db = Firestore.firestore()
        db.settings.isPersistenceEnabled = true
        self.userUid = Auth.auth().currentUser?.uid
    }
    
    func create(with content: String) -> Observable<Void> {
        return Observable.create { [unowned self] observer in
            self.db.collection("users").document(self.userUid!).collection("posts").addDocument(data: [
                "user": self.userUid as Any,
                "content": content,
                "date": Date(),
            ]) { error in
                if let e = error {
                    observer.onError(e)
                    return
                }
                observer.onNext(())
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func read() -> Observable<[Post]> {
        return Observable.create { [unowned self] observer in
                self.listener = self.db.collection("users").document(self.userUid!).collection("posts")
                    .order(by: "date")
                    .addSnapshotListener() { snapshot, error in
                        guard let snap = snapshot else {
                            print("Error fetching document: \(error!)")
                            observer.onError(error!)
                            return
                        }
                        for diff in snap.documentChanges {
                            if diff.type == .added {
                                print("New data: \(diff.document.data())")
                            }
                            
                            if diff.type == .removed {
                                print("Removed data: \(diff.document.data())")
                            }
                            
                            if diff.type == .modified {
                                print("Modified data: \(diff.document.data())")
                            }
                        }
                        print("Current data: \(snap)")
                        
                        var posts: [Post] = []
                        if !snap.isEmpty {
                            for item in snap.documents {
                                let timeStamp: Timestamp = item["date"] as! Timestamp
                                let date: Date = timeStamp.dateValue()
                                posts.append(Post(id: item.documentID,
                                                  user: item["user"] as! String,
                                                  content: item["content"] as! String,
                                                  date: date)
                                )
                            }
                        }
                        observer.onNext(posts)
            }
            return Disposables.create()
        }
    }

    func update(_ post: Post) -> Observable<Void> {
        return Observable.create { [unowned self] observer in
            self.db.collection("users").document(self.userUid!).collection("posts").document(post.id).updateData([
                "content": post.content,
                "date": post.date
                ]) { error in
                if let e = error {
                    observer.onError(e)
                    return
                }
                observer.onNext(())
            }
            return Disposables.create()
        }
    }
    
    func delete(_ documentID: String) -> Observable<Void> {
        return Observable.create { [unowned self] observer in
            self.db.collection("users").document(self.userUid!).collection("posts").document(documentID).delete() { error in
                if let e = error {
                    observer.onError(e)
                    return
                }
                observer.onNext(())
            }
            return Disposables.create()
        }
    }
}
