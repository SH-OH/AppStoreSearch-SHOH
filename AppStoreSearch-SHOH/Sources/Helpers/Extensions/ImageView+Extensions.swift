//
//  ImageView+Extensions.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/20.
//

import UIKit

extension UIImageView {
    func setImage(with imageUrl: String) {
        self.image = nil
        let mutatingSelf = self
        let task = ImageLoader.shared.load(imageUrl, completion: { result in
            switch result {
                case let .success(image):
                    self.image = image
                    mutatingSelf.imageTask = nil
                case .failure(_):
                    return
            }
        })
        mutatingSelf.imageTask = task
    }

    func cancel() {
        imageTask?.cancel()
    }
}

private extension UIImageView {
    private var imageTask: URLSessionDataTask? {
        get {
            return self.getAssociatedObject(self, key: &ImageLoader.shared.imageTaskKey)
        }
        set {
            self.setAssociatedObject(self, key: &ImageLoader.shared.imageTaskKey, value: newValue)
        }
    }
    
    private func getAssociatedObject<T: URLSessionDataTask>(
        _ object: UIImageView,
        key: UnsafeRawPointer
    ) -> T? {
        return objc_getAssociatedObject(object, key) as? T
    }
    
    private func setAssociatedObject<T: URLSessionDataTask>(
        _ object: UIImageView,
        key: UnsafeRawPointer,
        value: T?
    ) {
        objc_setAssociatedObject(object, key, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
