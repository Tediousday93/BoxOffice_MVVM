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
    
    private let numberFormatter: NumberFormatter
    
    private let dateFormatter: DateFormatter
    
    init(
        navigationController: UINavigationController?,
        parent: Coordinator,
        numberFormatter: NumberFormatter,
        dateFormatter: DateFormatter
    ) {
        self.navigationController = navigationController
        self.parent = parent
        self.numberFormatter = numberFormatter
        self.dateFormatter = dateFormatter
    }
    
    deinit {
        #if DEBUG
        print("DailyBoxOfficeCoordinator deinitialized")
        #endif
    }
    
    func start() {
        let boxOffice = BoxOffice(dailyBoxOfficeProvider: .init(), movieDetailsProvider: .init())
        let viewModel = DailyBoxOfficeViewModel(
            boxOffice: boxOffice,
            numberFormatter: numberFormatter,
            dateFormatter: dateFormatter
        )
        let viewController = DailyBoxOfficeViewController(viewModel: viewModel, coordinator: self)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func toMovieDetails(movieCode: String, movieTitle: String) {
        let childCoordinator = MovieDetailsCoordinator(
            navigationController: navigationController,
            parent: self,
            dateFormattter: dateFormatter,
            movieCode: movieCode,
            movieTitle: movieTitle
        )
        children.append(childCoordinator)
        childCoordinator.start()
    }
    
    func toCalendar(currentDate: Observable<String>) {
        let childCoordinator = CalendarCoordinator(
            navigationController: navigationController,
            parent: self,
            currentDate: currentDate,
            dateFormatter: dateFormatter
        )
        children.append(childCoordinator)
        childCoordinator.start()
    }
}
