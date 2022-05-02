//
//  Reactive+UIViewController.swift
//  PhotoPicker
//
//  Created by 김동현 on 2022/05/02.
//

import UIKit
import RxSwift
import RxCocoa

extension UIViewController {
    func showAlert(title : String, message: String? = nil) -> Observable<CGFloat> {
        return Observable.create { [weak self] observer in
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let firstGradeAction = UIAlertAction(title: "1x", style: .default) { _ in
                observer.onNext(1.0)
                observer.onCompleted()
            }
            let secondGradeAction = UIAlertAction(title: "2x", style: .default) { _ in
                observer.onNext(2.0)
                observer.onCompleted()
            }
            let thirdGradeAction = UIAlertAction(title: "3x", style: .default) { _ in
                observer.onNext(3.0)
                observer.onCompleted()
            }
            alertController.addAction(firstGradeAction)
            alertController.addAction(secondGradeAction)
            alertController.addAction(thirdGradeAction)
            
            self?.present(alertController, animated: true, completion: nil)
            
            return Disposables.create {
                alertController.dismiss(animated: true, completion: nil)
            }
        }
    }
}
