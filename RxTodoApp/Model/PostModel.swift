//
//  PostRepository.swift
//  RxTodoApp
//
//  Created by 大瀧輝 on 2020/01/10.
//  Copyright © 2020 Hikaru Otaki. All rights reserved.
//

import Foundation
import RxSwift
import Firebase

class PostRepository {
    let db: Firestore
    
    var listener: ListenerRegistration?
    
    init() {
        self.db = Firestore.firestore()
        db.settings.isPersistenceEnabled = true
    }
    
    func create(with content: String) -> Observable<Void> {
        return Observable.create { [unowned self] observer in
            self.db.collection("posts").addDocument(data: [
                "user": "sA4fjga3wOeg",
                "content": content,
                "date": Date()
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
    
    func read() -> Observable<[Post]> {        
        return Observable.create { [unowned self] observer in
            self.listener = self.db.collection("posts")
                .order(by: "date")
                .addSnapshotListener(includeMetadataChanges: true) { snapshot, error in
                    guard let snap = snapshot else {
                        print("Error fetching document: \(error!)")
                        observer.onError(error!)
                        return
                    }
                    for diff in snap.documentChanges {
                        if diff.type == .added {
                            print("New data: \(diff.document.data())")
                        }
                    }
                    print("Current data: \(snap)")
                    
                    var posts: [Post] = []
                    if !snap.isEmpty {
                        for item in snap.documents {
                            posts.append(Post(id: item.documentID,
                                              user: item["user"] as! String,
                                              content: item["content"] as! String,
                                              date: item["date"] as! Date)
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
            self.db.collection("posts").document(post.id).updateData([
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
            self.db.collection("posts").document(documentID).delete() { error in
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
