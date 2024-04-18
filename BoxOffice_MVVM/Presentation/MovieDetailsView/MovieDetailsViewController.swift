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
    
    private let directorView: SingleMovieInfoView = .init(frame: .zero)
    private let productionYearView: SingleMovieInfoView = .init(frame: .zero)
    private let openDateView: SingleMovieInfoView = .init(frame: .zero)
    private let runningTimeView: SingleMovieInfoView = .init(frame: .zero)
    private let watchGradeView: SingleMovieInfoView = .init(frame: .zero)
    private let nationView: SingleMovieInfoView = .init(frame: .zero)
    private let genreView: SingleMovieInfoView = .init(frame: .zero)
    private let actorView: SingleMovieInfoView = .init(frame: .zero)
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSubviews()
        setUpConstraints()
        configureRootView()
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
}
