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
    private typealias IconCellRegistration = UICollectionView.CellRegistration<DailyBoxOfficeIconCell, DailyBoxOfficeCellItem>
    
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
        let modeChangeButton = UIBarButtonItem(title: Constant.modeChangeButtonTitle,
                                               style: .plain,
                                               target: self,
                                               action: #selector(modeChangeButtonAction))
        let dateChoiceButton = UIBarButtonItem(title: Constant.dateChoiceButtonTitle,
                                               style: .plain,
                                               target: self,
                                               action: #selector(dateChoiceButtonAction))
        self.navigationItem.leftBarButtonItem = modeChangeButton
        self.navigationItem.rightBarButtonItem = dateChoiceButton
    }
    
    @objc
    private func dateChoiceButtonAction() {
        coordinator?.toCalendar(currentDate: viewModel.currentDate)
    }
    
    @objc
    private func modeChangeButtonAction() {
        guard let currentMode = viewModel.collectionViewMode.value else { return }
        
        let actionTitle = currentMode.toggle().buttonTitle
        
        AlertBuilder(alertStyle: .actionSheet, presentingViewController: self)
            .setTitle(Constant.actionSheetTitle)
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
        if let date = viewModel.currentDate.value {
            viewModel.setCurrentDate(date)
        }
    }
    
    private func configureDataSource() {
        let listCellRegistration = ListCellRegistration { cell, indexPath, item in
            cell.bind(item)
        }
        
        let iconCellRegistration = IconCellRegistration { cell, indexPath, item in
            cell.bind(item)
        }
        
        dataSource = .init(collectionView: collectionView) { [viewModel] collectionView, indexPath, item in
            switch viewModel.collectionViewMode.value {
            case .list:
                return collectionView.dequeueConfiguredReusableCell(
                    using: listCellRegistration,
                    for: indexPath,
                    item: item
                )
            case .icon:
                return collectionView.dequeueConfiguredReusableCell(
                    using: iconCellRegistration,
                    for: indexPath,
                    item: item
                )
            default:
                fatalError("DailyBoxOfficeView - collection view can not dequeue cell(mode is nil)")
            }
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
                guard self.viewModel.dailyBoxOfficeItems.value != nil else { return }
                
                DispatchQueue.main.async {
                    self.setCollectionViewLayout(mode: mode)
                    self.collectionView.reloadData()
                    self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0),
                                                     at: .top,
                                                     animated: false)
                }
            }
    }
    
    private func applySnapshot(items: [DailyBoxOfficeCellItem]) {
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
                                               heightDimension: .fractionalHeight(0.25))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        group.interItemSpacing = .flexible(8)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 24
        section.contentInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
        
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
        static let modeChangeButtonTitle = "화면모드"
        static let actionSheetTitle = "화면 모드 변경"
        static let cancelButtonTitle = "취소"
    }
}
