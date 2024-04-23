//
//  DailyBoxOfficeListCell.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/04/15.
//

import UIKit

final class DailyBoxOfficeListCell: UICollectionViewListCell, Reusable {
    private let rankLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .largeTitle)
        
        return label
    }()
    
    private let rankDifferenceLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        
        return label
    }()
    
    private let rankStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        
        return label
    }()
    
    private let audienceCountLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        
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
        setUpSubviews()
        setUpConstraints()
        configureAccessoryView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        [rankLabel, rankDifferenceLabel, titleLabel, audienceCountLabel]
            .forEach { $0.text = nil }
    }
    
    private func setUpSubviews() {
        [rankLabel, rankDifferenceLabel].forEach {
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
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            rankStackView.widthAnchor.constraint(equalTo: outterStackView.widthAnchor, multiplier: 0.15),
            
            outterStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            outterStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            outterStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            outterStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }
    
    private func configureAccessoryView() {
        self.accessories = [.disclosureIndicator()]
    }
    
    func bind(_ item: DailyBoxOfficeCellItem) {
        rankLabel.text = item.rank
        titleLabel.text = item.movieTitle
        audienceCountLabel.text = item.audienceCount
        
        switch item.rankOldAndNew {
        case .new:
            rankDifferenceLabel.textColor = .systemRed
            rankDifferenceLabel.text = item.rankDifference
        case .old:
            rankDifferenceLabel.textColor = .black
            
            let prefix = item.rankDifference.prefix(1)
            if prefix == "⏷" {
                rankDifferenceLabel.attributedText = addPrefixColorAttribute(to: item.rankDifference, color: .systemBlue)
            } else if prefix == "⏶" {
                rankDifferenceLabel.attributedText = addPrefixColorAttribute(to: item.rankDifference, color: .systemRed)
            } else {
                rankDifferenceLabel.text = item.rankDifference
            }
        }
    }
    
    private func addPrefixColorAttribute(to text: String, color: UIColor) -> NSMutableAttributedString {
        let mutableText = NSMutableAttributedString(string: text)
        let prefix = String(text.prefix(1))
        let range = NSString(string: text).range(of: prefix)
        
        mutableText.addAttribute(.foregroundColor, value: color, range: range)
        
        return mutableText
    }
}
