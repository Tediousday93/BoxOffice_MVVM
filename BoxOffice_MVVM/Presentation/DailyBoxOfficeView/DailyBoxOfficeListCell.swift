//
//  DailyBoxOfficeListCell.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/04/15.
//

import UIKit

final class DailyBoxOfficeListCell: UICollectionViewListCell {
    private let rankLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        
        return label
    }()
    
    private let rankStateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        
        return label
    }()
    
    private let rankStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 0
        
        return label
    }()
    
    private let audienceCountLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .callout)
        
        return label
    }()
    
    private let bodyStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        
        return stackView
    }()
    
    private let outterStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setSubviews()
        setConstraints()
        setAccessoryView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        rankLabel.text = nil
        rankStateLabel.text = nil
        titleLabel.text = nil
        audienceCountLabel.text = nil
    }
    
    private func setSubviews() {
        [rankLabel, rankStateLabel].forEach {
            rankStackView.addArrangedSubview($0)
        }
        
        [titleLabel, audienceCountLabel].forEach {
            bodyStackView.addArrangedSubview($0)
        }
        
        [rankStackView, bodyStackView].forEach {
            outterStackView.addArrangedSubview($0)
        }
        
        contentView.addSubview(outterStackView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            rankStackView.widthAnchor.constraint(equalTo: outterStackView.widthAnchor, multiplier: 0.15),
            
            outterStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            outterStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            outterStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            outterStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }
    
    private func setAccessoryView() {
        self.accessories = [.disclosureIndicator()]
    }
}
