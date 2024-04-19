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
    
    private let numberFormatter: NumberFormatter
    
    private let dateFormatter: DateFormatter
    
    init(
        navigationController: UINavigationController?,
        parent: Coordinator,
        boxOffice: BoxOfficeType,
        numberFormatter: NumberFormatter,
        dateFormatter: DateFormatter
    ) {
        self.navigationController = navigationController
        self.parent = parent
        self.boxOffice = boxOffice
        self.numberFormatter = numberFormatter
        self.dateFormatter = dateFormatter
    }
    
    deinit {
        print("DailyBoxOfficeCoordinator deinitialized")
    }
    
    func start() {
        let viewModel = DailyBoxOfficeViewModel(
            boxOffice: boxOffice,
            numberFormatter: numberFormatter,
            dateFormatter: dateFormatter
        )
        let viewController = DailyBoxOfficeViewController(viewModel: viewModel, coordinator: self)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func toMovieDetails(item: DailyBoxOfficeListCellItem) {
        let childCoordinator = MovieDetailsCoordinator(
            navigationController: navigationController,
            parent: self,
            boxOffice: boxOffice,
            imageProvider: ImageProvider(),
            imageURLSearcher: DaumImageSearcher(provider: .init()),
            movieCode: item.id,
            movieTitle: item.movieTitle
        )
        children.append(childCoordinator)
        childCoordinator.start()
    }
}
