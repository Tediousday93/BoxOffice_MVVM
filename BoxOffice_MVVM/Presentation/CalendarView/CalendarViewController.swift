//
//  CalendarViewController.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/04/22.
//

import UIKit

final class CalendarViewController: UIViewController {
    private let calendarView: UICalendarView = {
        let calendarView = UICalendarView()
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        
        return calendarView
    }()
    
    private weak var coordinator: CalendarCoordinator?
    
    init(
        coordinator: CalendarCoordinator?
    ) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSubviews()
        setUpConstraints()
        configureRootView()
    }
    
    private func setUpSubviews() {
        view.addSubview(calendarView)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            calendarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            calendarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func configureRootView() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureCalendarView() {
        calendarView.selectionBehavior = UICalendarSelectionSingleDate(delegate: self)
    }
}

extension CalendarViewController: UICalendarSelectionSingleDateDelegate {
    func dateSelection(
        _ selection: UICalendarSelectionSingleDate,
        didSelectDate dateComponents: DateComponents?
    ) {
        
    }
}
