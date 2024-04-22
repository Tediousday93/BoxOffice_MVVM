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
        setUpSubviews()
        setUpConstraints()
        configureRootView()
        configureCollectionView()
        setUpBindings()
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
    
    private func configureRootView() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        configureRefreshControl()
        configureDataSource()
    }
    
    private func configureRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(updateCurrentDate), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    @objc
    private func updateCurrentDate() {
        if let date = self.navigationItem.title {
            viewModel.setCurrentDate(date)
        }
    }
    
    private func configureDataSource() {
        let cellRegistration = ListCellRegistration { cell, indexPath, item in
            cell.bind(item)
        }
        
        dataSource = .init(collectionView: collectionView) { [weak self] collectionView, indexPath, itemIdentifier in
            guard let self = self else { return nil }
            
            let item = self.viewModel.dailyBoxOfficeItems.value?.first { movie in
                movie.id == itemIdentifier
            }
            
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: item
            )
        }
    }
    
    private func setUpBindings() {
        viewModel.dailyBoxOfficeItems
            .subscribe { [weak self] items in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.applySnapshot(items: items)
                }
            }
        
        viewModel.currentDate
            .subscribe { [weak self] date in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.navigationItem.title = date
                }
            }
    }
    
    private func applySnapshot(items: [DailyBoxOfficeListCellItem]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items.map { $0.id })
        dataSource?.apply(snapshot)
        collectionView.refreshControl?.endRefreshing()
    }
}

extension DailyBoxOfficeViewController: UICollectionViewDelegate {
    private enum Section {
        case main
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        defer { collectionView.deselectItem(at: indexPath, animated: true) }
        guard let items = viewModel.dailyBoxOfficeItems.value else { return }
        
        let item = items[indexPath.row]
        coordinator?.toMovieDetails(movieCode: item.id, movieTitle: item.movieTitle)
    }
}
