//
//  Observable.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/04/15.
//

import Foundation

final class Observable<T> {
    private typealias Listener = (T) -> Void
    
    private var observers: [Listener]
    
    var value: T? {
        didSet {
            if value != nil { notifyObservers() }
        }
    }
    
    init(_ value: T? = nil) {
        self.value = value
        self.observers = []
    }
    
    func subscribe(listener: @escaping (T) -> Void) {
        observers.append(listener)
        if let value = value { listener(value) }
    }
    
    private func notifyObservers() {
        observers.forEach { listener in
            if let value = value { listener(value) }
        }
    }
}
