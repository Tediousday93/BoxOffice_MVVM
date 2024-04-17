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
    
    private let boxOffice: BoxOffice = .init(dailyBoxOfficeProvider: .init(), movieDetailsProvider: .init())
    
    private let imageProvider: ImageProvider = .init()
    
    private let imageURLSearcher: DaumImageSearcher = .init(provider: .init())
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func start() {
        toDailyBoxOffice()
    }
    
    private func toDailyBoxOffice() {
        let dailyBoxOfficeCoordinator = DailyBoxOfficeCoordinator(
            navigationController: navigationController,
            parent: self,
            boxOffice: boxOffice
        )
        children.append(dailyBoxOfficeCoordinator)
        dailyBoxOfficeCoordinator.start()
    }
}
