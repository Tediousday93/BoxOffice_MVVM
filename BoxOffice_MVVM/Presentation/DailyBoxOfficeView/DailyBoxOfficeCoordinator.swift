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
    
    private let boxOffice: BoxOfficeType
    
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    init(
        navigationController: UINavigationController?,
        parent: Coordinator,
        boxOffice: BoxOfficeType
    ) {
        self.navigationController = navigationController
        self.parent = parent
        self.boxOffice = boxOffice
    }
    
    deinit {
        print("DailyBoxOfficeCoordinator deinitialized")
    }
    
    func start() {
        let viewModel = DailyBoxOfficeViewModel(boxOffice: boxOffice, numberFormatter: numberFormatter)
        let viewController = DailyBoxOfficeViewController(viewModel: viewModel, coordinator: self)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
