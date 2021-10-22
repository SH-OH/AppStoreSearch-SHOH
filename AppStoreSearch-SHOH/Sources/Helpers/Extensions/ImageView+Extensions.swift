//
//  ImageView+Extensions.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/20.
//

import UIKit
import RxSwift

extension UIImageView {
    func setImage(with imageUrl: String?) {
        self.image = nil
        let mutatingSelf = self
        let task = ImageLoader.shared.load(imageUrl)
            .subscribe(onSuccess: { image in
                self.image = image
                mutatingSelf.imageTask = nil
            })
        
        mutatingSelf.imageTask = task
    }

    func cancel() {
        imageTask?.dispose()
        imageTask = nil
    }
    
    func setRatingImage(_ rating: CGFloat) {
        var rating = rating
        rating = rating <= 0 ? 0 : rating
        rating = rating >= 1 ? 1 : rating
        let layer = CALayer()
        let w = self.frame.size.width*rating
        let h = self.frame.size.height
        layer.backgroundColor = UIColor.systemGray.cgColor
        layer.frame = .init(x: 0, y: 0, width: w, height: h)
        self.layer.mask = layer
    }
}

private extension UIImageView {
    private var imageTask: Disposable? {
        get {
            return self.getAssociatedObject(self, key: &ImageLoader.shared.imageTaskKey)
        }
        set {
            self.setAssociatedObject(self, key: &ImageLoader.shared.imageTaskKey, value: newValue)
        }
    }
    
    private func getAssociatedObject<T>(
        _ object: UIImageView,
        key: UnsafeRawPointer
    ) -> T? {
        return objc_getAssociatedObject(object, key) as? T
    }
    
    private func setAssociatedObject<T>(
        _ object: UIImageView,
        key: UnsafeRawPointer,
        value: T?
    ) {
        objc_setAssociatedObject(object, key, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
