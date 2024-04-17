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
    
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
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
            boxOffice: boxOffice,
            numberFormatter: numberFormatter,
            dateFormatter: dateFormatter
        )
        children.append(dailyBoxOfficeCoordinator)
        dailyBoxOfficeCoordinator.start()
    }
}
