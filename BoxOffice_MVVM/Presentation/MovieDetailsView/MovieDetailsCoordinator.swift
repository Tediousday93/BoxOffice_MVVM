//
//  MovieDetailsCoordinator.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/04/18.
//

import UIKit

final class MovieDetailsCoordinator: Coordinator {
    var navigationController: UINavigationController?
    
    weak var parent: Coordinator?
    
    var children: [Coordinator] = []
    
    private let dateFormattter: DateFormatter
    
    private let movieCode: String
    private let movieTitle: String
    
    init(
        navigationController: UINavigationController?,
        parent: Coordinator,
        dateFormattter: DateFormatter,
        movieCode: String,
        movieTitle: String
    ) {
        self.navigationController = navigationController
        self.parent = parent
        self.dateFormattter = dateFormattter
        self.movieCode = movieCode
        self.movieTitle = movieTitle
    }
    
    deinit {
        print("MovieDetailsCoordinator deinitialized")
    }
    
    func start() {
        let viewModel = MovieDetailsViewModel(
            movieCode: movieCode,
            movieTitle: movieTitle,
            boxOffice: BoxOffice(dailyBoxOfficeProvider: .init(), movieDetailsProvider: .init()),
            imageURLSearcher: DaumImageSearcher(provider: .init()),
            dateFormatter: dateFormattter
        )
        let viewController = MovieDetailsViewController(
            coordinator: self,
            imageProvider: ImageProvider(),
            viewModel: viewModel
        )
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func finish() {
        parent?.removeFinishedChild(self)
    }
}
