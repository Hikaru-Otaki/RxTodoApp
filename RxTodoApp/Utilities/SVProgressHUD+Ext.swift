//
//  SVProgressHUD+Ext.swift
//  RxTodoApp
//
//  Created by 大瀧輝 on 2020/01/17.
//  Copyright © 2020 Hikaru Otaki. All rights reserved.
//

import SVProgressHUD
import RxSwift
import RxCocoa

extension Reactive where Base: SVProgressHUD {

   public static var isAnimating: Binder<Bool> {
      return Binder(UIApplication.shared) {progressHUD, isVisible in
         if isVisible {
            print("show")
            SVProgressHUD.setDefaultStyle(.custom)
            SVProgressHUD.setDefaultMaskType(.custom)
            SVProgressHUD.setForegroundColor(UIColor.red)           //Ring Color
            SVProgressHUD.setBackgroundColor(UIColor.yellow)        //HUD Color
            SVProgressHUD.setBackgroundLayerColor(UIColor.green) 
            SVProgressHUD.show()
         } else {
            print("dismiss")
            SVProgressHUD.dismiss()
         }
      }
   }

}
