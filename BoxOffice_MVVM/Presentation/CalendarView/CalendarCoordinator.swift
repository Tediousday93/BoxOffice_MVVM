//
//  CalendarCoordinator.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/04/22.
//

import UIKit

final class CalendarCoordinator: Coordinator {
    var navigationController: UINavigationController?
    
    weak var parent: Coordinator?
    
    var children: [Coordinator] = []
    
    private let dateFormatter: DateFormatter
    
    init(
        navigationController: UINavigationController?,
        parent: Coordinator,
        dateFormatter: DateFormatter
    ) {
        self.navigationController = navigationController
        self.parent = parent
        self.dateFormatter = dateFormatter
    }
    
    func start() {
        
    }
    
    func finish() {
        
    }
}
