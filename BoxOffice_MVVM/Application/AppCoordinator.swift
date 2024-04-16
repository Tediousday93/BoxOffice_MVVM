//
//  AppCoordinator.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/04/11.
//

import UIKit

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController?
    
    var parent: Coordinator? = nil
    
    var children: [Coordinator] = []
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func start() {
        toDailyBoxOffice()
    }
    
    private func toDailyBoxOffice() {
        let dailyBoxOfficeCoordinator = DailyBoxOfficeCoordinator(
            navigationController: navigationController,
            parent: self
        )
        children.append(dailyBoxOfficeCoordinator)
        dailyBoxOfficeCoordinator.start()
    }
}
