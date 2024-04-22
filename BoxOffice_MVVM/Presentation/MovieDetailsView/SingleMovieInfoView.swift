//
//  SingleMovieInfoView.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/04/18.
//

import UIKit

final class SingleMovieInfoView: UIView {
    let titleLabel: UILabel = {
        let label = UILabel()
        if let titleDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body).withSymbolicTraits(.traitBold) {
            label.font = UIFont(descriptor: titleDescriptor, size: 0.0)
        }
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubviews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpSubviews() {
        [titleLabel, bodyLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        
        addSubview(stackView)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            titleLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.15)
        ])
    }
}
