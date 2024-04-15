//
//  DailyBoxOfficeCoordinator.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/04/11.
//

import UIKit

final class DailyBoxOfficeCoordinator: Coordinator {
    var navigationController: UINavigationController?
    
    weak var parent: Coordinator?
    
    var children: [Coordinator] = []
    
    init(
        navigationController: UINavigationController?,
        parent: Coordinator
    ) {
        self.navigationController = navigationController
        self.parent = parent
    }
    
    func start() {
        let viewController = DailyBoxOfficeViewController()
        viewController.coordinator = self
        navigationController?.pushViewController(viewController, animated: true)
    }
}
