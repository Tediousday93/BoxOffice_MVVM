//
//  AppCoordinator.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/04/11.
//

import UIKit

final class AppCoordinator: Coordinator {
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
    
    var navigationController: UINavigationController? = nil
    var parent: Coordinator? = nil
    var children: [Coordinator] = []
    let window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
        window?.makeKeyAndVisible()
    }
    
    func start() {
        configureMainUI()
    }
    
    private func configureMainUI() {
        let dailyBoxOfficeNavigationController = UINavigationController()
        dailyBoxOfficeNavigationController.tabBarItem = UITabBarItem(
            title: "일일 박스오피스",
            image: UIImage(systemName: "popcorn"),
            selectedImage: UIImage(systemName: "popcorn.fill")
        )
        let dailyBoxOfficeCoordinator = DailyBoxOfficeCoordinator(
            navigationController: dailyBoxOfficeNavigationController,
            parent: self,
            numberFormatter: numberFormatter,
            dateFormatter: dateFormatter
        )
        children.append(dailyBoxOfficeCoordinator)
        
        let tabbarController = UITabBarController()
        tabbarController.viewControllers = [dailyBoxOfficeNavigationController]
        
        window?.rootViewController = tabbarController
        
        dailyBoxOfficeCoordinator.start()
    }
}
