//
//  DailyBoxOfficeViewController.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/02/09.
//

import UIKit

final class DailyBoxOfficeViewController: UIViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, DailyBoxOfficeCellItem>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, DailyBoxOfficeCellItem>
    private typealias ListCellRegistration = UICollectionView.CellRegistration<DailyBoxOfficeListCell, DailyBoxOfficeCellItem>
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: DailyBoxOfficeViewController.collectionViewListLayout
        )
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
        configureNavigationBar()
        configureToolbar()
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
    
    private func configureNavigationBar() {
        let dateChoiceButton = UIBarButtonItem(title: Constant.dateChoiceButtonTitle,
                                               style: .plain,
                                               target: self,
                                               action: #selector(dateChoiceButtonAction))
        navigationItem.rightBarButtonItem = dateChoiceButton
    }
    
    @objc
    private func dateChoiceButtonAction() {
        coordinator?.toCalendar(currentDate: viewModel.currentDate)
    }
    
    private func configureToolbar() {
        let modeChangeButton = UIBarButtonItem(title: Constant.modeChangeButtonTitle,
                                               style: .plain,
                                               target: self,
                                               action: #selector(modeChangeButtonAction))
        let spacer = UIBarButtonItem(systemItem: .flexibleSpace)
        
        self.toolbarItems = [spacer, modeChangeButton, spacer]
        navigationController?.isToolbarHidden = false
    }
    
    @objc
    private func modeChangeButtonAction() {
        guard let currentMode = viewModel.collectionViewMode.value else { return }
        
        let actionTitle = currentMode.toggle().buttonTitle
        
        AlertBuilder(alertStyle: .actionSheet, presentingViewController: self)
            .setTitle(Constant.modeChangeButtonTitle)
            .addAction(title: actionTitle,
                       style: .default,
                       handler: viewModel.changeCollectionViewMode)
            .addAction(title: Constant.cancelButtonTitle,
                       style: .cancel,
                       handler: nil)
            .show()
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
        refreshControl.addTarget(self, action: #selector(refreshControlAction), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    @objc
    private func refreshControlAction() {
        if let date = self.navigationItem.title {
            viewModel.setCurrentDate(date)
        }
    }
    
    private func configureDataSource() {
        let cellRegistration = ListCellRegistration { cell, indexPath, item in
            cell.bind(item)
        }
        
        dataSource = .init(collectionView: collectionView) { collectionView, indexPath, item in
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
        
        viewModel.collectionViewMode
            .subscribe { [weak self] mode in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.setCollectionViewLayout(mode: mode)
                }
            }
    }
    
    private func applySnapshot(items: [DailyBoxOfficeListCellItem]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        dataSource?.apply(snapshot)
        collectionView.refreshControl?.endRefreshing()
    }
    
    private func setCollectionViewLayout(mode: DailyBoxOfficeViewModel.CollectionViewMode) {
        switch mode {
        case .icon:
            collectionView.setCollectionViewLayout(
                DailyBoxOfficeViewController.collectionViewIconLayout,
                animated: true
            )
        case .list:
            collectionView.setCollectionViewLayout(
                DailyBoxOfficeViewController.collectionViewListLayout,
                animated: true
            )
        }
    }
}

extension DailyBoxOfficeViewController: UICollectionViewDelegate {
    static let collectionViewListLayout: UICollectionViewLayout = {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }()
    
    static let collectionViewIconLayout: UICollectionViewLayout = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.48),
                                              heightDimension: .fractionalWidth(0.48))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                     subitems: [item])
        group.interItemSpacing = .flexible(8)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 12, leading: 12, bottom: 12, trailing: 12)
        
        return UICollectionViewCompositionalLayout(section: section)
    }()
    
    private enum Section {
        case main
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        defer { collectionView.deselectItem(at: indexPath, animated: true) }
        guard let items = viewModel.dailyBoxOfficeItems.value else { return }
        
        let item = items[indexPath.row]
        coordinator?.toMovieDetails(movieCode: item.movieCode, movieTitle: item.movieTitle)
    }
}

extension DailyBoxOfficeViewController {
    private enum Constant {
        static let dateChoiceButtonTitle = "날짜선택"
        static let modeChangeButtonTitle = "화면 모드 변경"
        static let cancelButtonTitle = "취소"
    }
}
