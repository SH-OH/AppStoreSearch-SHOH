//
//  ObservableType+Extensions.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/23.
//

import RxSwift
import RxCocoa

extension ObservableType {
    func asDriverOnNever() -> Driver<Element> {
        return asDriver(onErrorDriveWith: .never())
    }
}
