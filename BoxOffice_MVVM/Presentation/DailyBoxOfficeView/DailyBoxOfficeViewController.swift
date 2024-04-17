//
//  DailyBoxOfficeViewController.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/02/09.
//

import UIKit

final class DailyBoxOfficeViewController: UIViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, DailyBoxOfficeListCellItem.ID>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, DailyBoxOfficeListCellItem.ID>
    private typealias ListCellRegistration = UICollectionView.CellRegistration<DailyBoxOfficeListCell, DailyBoxOfficeListCellItem>
    
    private let collectionView: UICollectionView = {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let collectionViewLayout = UICollectionViewCompositionalLayout.list(using: configuration)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private var dataSource: DataSource?
    
    private let viewModel: DailyBoxOfficeViewModel
    
    private weak var coordinator: DailyBoxOfficeCoordinator?
    
    init(
        viewModel: DailyBoxOfficeViewModel,
        coordinator: DailyBoxOfficeCoordinator?
    ) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpSubviews()
        setUpConstraints()
        configureDataSource()
        configureNavigationBar()
        setUpBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDailyBoxOffice()
    }
    
    private func fetchDailyBoxOffice() {
        viewModel.fetchDailyBoxOffice(targetDate: "20240415")
    }

    private func setUpSubviews() {
        view.addSubview(collectionView)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func configureDataSource() {
        let cellRegistration = ListCellRegistration { cell, indexPath, item in
            cell.bind(item)
        }
        
        dataSource = .init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let item = self.viewModel.dailyBoxOfficeMovies.value.first { movie in
                movie.id == itemIdentifier
            }
            
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: item
            )
        }
    }
    
    private func configureNavigationBar() {
        let yesterday = Date(timeInterval: -Constants.secondsOfOneDay, since: .now)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.dateFormat
        
        self.title = dateFormatter.string(from: yesterday)
    }
    
    private func setUpBindings() {
        viewModel.dailyBoxOfficeMovies
            .subscribe { [weak self] items in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.applySnapshot(items: items)
                }
            }
    }
    
    private func applySnapshot(items: [DailyBoxOfficeListCellItem]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items.map { $0.id })
        dataSource?.apply(snapshot)
    }
}

extension DailyBoxOfficeViewController {
    private enum Section {
        case main
    }
    
    private enum Constants {
        static let secondsOfOneDay: TimeInterval = 3600 * 24
        static let dateFormat: String = "yyyy-MM-dd"
    }
}
