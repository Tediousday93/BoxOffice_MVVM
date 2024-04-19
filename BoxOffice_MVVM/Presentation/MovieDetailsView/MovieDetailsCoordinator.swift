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
    
    private let boxOffice: MovieDetailsProvidable
    
    private let imageProvider: ImageProviderType
    
    private let imageURLSearcher: ImageURLSearchable
    
    private let movieCode: String
    private let movieTitle: String
    
    init(
        navigationController: UINavigationController?,
        parent: Coordinator,
        boxOffice: MovieDetailsProvidable,
        imageProvider: ImageProviderType,
        imageURLSearcher: ImageURLSearchable,
        movieCode: String,
        movieTitle: String
    ) {
        self.navigationController = navigationController
        self.parent = parent
        self.boxOffice = boxOffice
        self.imageProvider = imageProvider
        self.imageURLSearcher = imageURLSearcher
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
            boxOffice: boxOffice,
            imageURLSearcher: imageURLSearcher
        )
        let viewController = MovieDetailsViewController(
            coordinator: self,
            imageProvider: imageProvider,
            viewModel: viewModel
        )
        navigationController?.pushViewController(viewController, animated: true)
    }
}
