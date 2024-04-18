//
//  MovieDetailsCoordinator.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/04/18.
//

import UIKit

final class MovieDetailsCoordinator: Coordinator {
    var navigationController: UINavigationController?
    
    var parent: Coordinator?
    
    var children: [Coordinator] = []
    
    private let boxOffice: BoxOfficeType
    
    private let imageProvider: ImageProviderType
    
    private let imageURLSearcher: ImageURLSearchable
    
    init(
        navigationController: UINavigationController?,
        parent: Coordinator,
        boxOffice: BoxOfficeType,
        imageProvider: ImageProviderType,
        imageURLSearcher: ImageURLSearchable
    ) {
        self.navigationController = navigationController
        self.parent = parent
        self.boxOffice = boxOffice
        self.imageProvider = imageProvider
        self.imageURLSearcher = imageURLSearcher
    }
    
    func start() {
        
    }
}
