//
//  MovieSearchCoordinator.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 5/20/24.
//

import UIKit

final class MovieSearchCoordinator: Coordinator {
    var navigationController: UINavigationController?
    
    weak var parent: Coordinator?
    
    var children: [Coordinator] = []
    
    init(
        navigationController: UINavigationController?,
        parent: Coordinator?
    ) {
        self.navigationController = navigationController
        self.parent = parent
    }
    
    func start() {
        let viewController = MovieSearchViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}
