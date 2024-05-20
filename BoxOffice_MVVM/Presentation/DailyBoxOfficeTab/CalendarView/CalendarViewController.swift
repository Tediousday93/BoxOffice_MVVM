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
        calendarView.calendar = .init(identifier: .gregorian)
        calendarView.locale = .init(identifier: "ko_KR")
        
        return calendarView
    }()
    
    private let viewModel: CalendarViewModel
    
    private weak var coordinator: CalendarCoordinator?
    
    init(
        viewModel: CalendarViewModel,
        coordinator: CalendarCoordinator?
    ) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        coordinator?.finish()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSubviews()
        setUpConstraints()
        configureRootView()
        configureCalendarView()
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
        guard let currentDateComponents = viewModel.currentDateComponents,
              let availableDateRange = viewModel.availableDateRange
        else { return }
        
        calendarView.setVisibleDateComponents(currentDateComponents, animated: true)
        calendarView.availableDateRange = availableDateRange
        
        let selectionBehavior = UICalendarSelectionSingleDate(delegate: self)
        selectionBehavior.selectedDate = currentDateComponents
        calendarView.selectionBehavior = selectionBehavior
    }
}

extension CalendarViewController: UICalendarSelectionSingleDateDelegate {
    func dateSelection(
        _ selection: UICalendarSelectionSingleDate,
        didSelectDate dateComponents: DateComponents?
    ) {
        if let selectedDate = dateComponents?.date {
            viewModel.setCurrentDate(selectedDate)
            coordinator?.dismiss()
        }
    }
}
