//
//  Coordinator.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/04/11.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController? { get set }
    var parent: Coordinator? { get set }
    var children: [Coordinator] { get set }
    
    func start()
}

extension Coordinator {
    func removeFinishedChild(_ child: Coordinator) {
        for (index, coordinator) in children.enumerated() {
            if coordinator === child {
                children.remove(at: index)
                break
            }
        }
    }
}
