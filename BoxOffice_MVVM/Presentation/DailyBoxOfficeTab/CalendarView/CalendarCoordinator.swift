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
    
    private let currentDate: Observable<String>
    
    private let dateFormatter: DateFormatter
    
    init(
        navigationController: UINavigationController?,
        parent: Coordinator,
        currentDate: Observable<String>,
        dateFormatter: DateFormatter
    ) {
        self.navigationController = navigationController
        self.parent = parent
        self.currentDate = currentDate
        self.dateFormatter = dateFormatter
    }
    
    deinit {
        #if DEBUG
        print("CalendarCoordinator deinitialized")
        #endif
    }
    
    func start() {
        let viewModel = CalendarViewModel(currentDate: currentDate, dateFormatter: dateFormatter)
        let viewController = CalendarViewController(viewModel: viewModel, coordinator: self)
        viewController.modalPresentationStyle = .formSheet
        navigationController?.present(viewController, animated: true)
    }
    
    func dismiss() {
        navigationController?.dismiss(animated: true)
        finish()
    }
    
    func finish() {
        parent?.removeFinishedChild(self)
    }
}
