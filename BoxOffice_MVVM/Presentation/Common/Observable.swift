//
//  Observable.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/04/15.
//

import Foundation

final class Observable<T> {
    var value: T {
        didSet { self.listener?(value) }
    }
    
    var listener: ((T) -> Void)?
    
    init(_ value: T) {
        self.value = value
    }
    
    func subscribe(listener: @escaping (T) -> Void) {
        listener(value)
        self.listener = listener
    }
}
