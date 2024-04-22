//
//  MovieDetailsViewController.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/04/18.
//

import UIKit

final class MovieDetailsViewController: UIViewController {
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let posterView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let directorView: SingleMovieInfoView = {
        let infoView = SingleMovieInfoView(frame: .zero)
        infoView.titleLabel.text = Constants.directorViewTitle
        
        return infoView
    }()
    
    private let productionYearView: SingleMovieInfoView = {
        let infoView = SingleMovieInfoView(frame: .zero)
        infoView.titleLabel.text = Constants.productionYearViewTitle
        
        return infoView
    }()
    
    private let openDateView: SingleMovieInfoView = {
        let infoView = SingleMovieInfoView(frame: .zero)
        infoView.titleLabel.text = Constants.openDateViewTitle
        
        return infoView
    }()
    
    private let runningTimeView: SingleMovieInfoView = {
        let infoView = SingleMovieInfoView(frame: .zero)
        infoView.titleLabel.text = Constants.runningTimeViewTitle
        
        return infoView
    }()
    
    private let watchGradeView: SingleMovieInfoView = {
        let infoView = SingleMovieInfoView(frame: .zero)
        infoView.titleLabel.text = Constants.watchGradeViewTitle
        
        return infoView
    }()
    
    private let nationView: SingleMovieInfoView = {
        let infoView = SingleMovieInfoView(frame: .zero)
        infoView.titleLabel.text = Constants.nationViewTitle
        
        return infoView
    }()
    
    private let genreView: SingleMovieInfoView = {
        let infoView = SingleMovieInfoView(frame: .zero)
        infoView.titleLabel.text = Constants.genreViewTitle
        
        return infoView
    }()
    
    private let actorView: SingleMovieInfoView = {
        let infoView = SingleMovieInfoView(frame: .zero)
        infoView.titleLabel.text = Constants.actorViewTitle
        
        return infoView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private weak var coordinator: MovieDetailsCoordinator?
    
    private let imageProvider: ImageProviderType
    
    private let viewModel: MovieDetailsViewModel
    
    init(
        coordinator: MovieDetailsCoordinator,
        imageProvider: ImageProviderType,
        viewModel: MovieDetailsViewModel
    ) {
        self.coordinator = coordinator
        self.imageProvider = imageProvider
        self.viewModel = viewModel
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
        setUpBindings()
    }
    
    private func setUpSubviews() {
        [
            directorView, productionYearView, openDateView,
            runningTimeView, watchGradeView, nationView,
            genreView, actorView
        ].forEach { stackView.addArrangedSubview($0) }
        
        [posterView, stackView].forEach { contentView.addSubview($0) }
        
        scrollView.addSubview(contentView)
        
        view.addSubview(scrollView)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            posterView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            posterView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            posterView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.6),
            
            stackView.topAnchor.constraint(equalTo: posterView.bottomAnchor, constant: 4),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
    }
    
    private func configureRootView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setUpBindings() {
        viewModel.movieTitle.subscribe { [weak self] title in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.navigationItem.title = title
            }
        }
        
        viewModel.movieInfo.subscribe { [weak self] movieInfo in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.directorView.bodyLabel.text = movieInfo.directors
                    .map { $0.personName }
                    .joined(separator: ", ")
                self.productionYearView.bodyLabel.text = movieInfo.productionYear
                self.openDateView.bodyLabel.text = movieInfo.openDate
                self.runningTimeView.bodyLabel.text = movieInfo.runningTime
                self.watchGradeView.bodyLabel.text = movieInfo.audits.first?.watchGradeName
                self.nationView.bodyLabel.text = movieInfo.nations.first?.nationName
                self.genreView.bodyLabel.text = movieInfo.genres
                    .map { $0.genreName }
                    .joined(separator: ", ")
                self.actorView.bodyLabel.text = movieInfo.actors
                    .map { $0.personName }
                    .joined(separator: ", ")
            }
        }
        
        viewModel.posterURL.subscribe { [weak self] url in
            guard let self = self else { return }
            
            self.imageProvider.fetchImage(from: url) { result in
                switch result {
                case let .success(posterImage):
                    DispatchQueue.main.async {
                        self.posterView.image = posterImage
                        self.posterView.layoutIfNeeded()
                    }
                case let .failure(error):
                    print(error)
                }
            }
        }
    }
}

extension MovieDetailsViewController {
    private enum Constants {
        static let directorViewTitle = "감독"
        static let productionYearViewTitle = "제작년도"
        static let openDateViewTitle = "개봉일"
        static let runningTimeViewTitle = "상영시간"
        static let watchGradeViewTitle = "관람등급"
        static let nationViewTitle = "제작국가"
        static let genreViewTitle = "장르"
        static let actorViewTitle = "배우"
    }
}
