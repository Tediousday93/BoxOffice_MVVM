//
//  DailyBoxOfficeIconCell.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/04/23.
//

import UIKit

final class DailyBoxOfficeIconCell: UICollectionViewCell, Reusable {
    private let rankLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.setContentHuggingPriority(.required, for: .vertical)
        
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        return label
    }()
    
    private let rankDifferenceLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.setContentHuggingPriority(.required, for: .vertical)
        
        return label
    }()
    
    private let audienceCountLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .callout)
        label.setContentHuggingPriority(.required, for: .vertical)
        label.minimumScaleFactor = 0.3
        
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
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
        configureContentView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        [rankLabel, titleLabel, rankDifferenceLabel, audienceCountLabel]
            .forEach { $0.text = nil }
    }
    
    private func setUpSubviews() {
        [rankLabel, titleLabel, rankDifferenceLabel, audienceCountLabel]
            .forEach { stackView.addArrangedSubview($0) }
        
        contentView.addSubview(stackView)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
        ])
    }
    
    private func configureContentView() {
        contentView.layer.cornerRadius = 4
        contentView.layer.borderColor = UIColor.systemGray.cgColor
        contentView.layer.borderWidth = 2
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
