//
//  MovieSearchViewController.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 5/20/24.
//

import UIKit

final class MovieSearchViewController: UIViewController {
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.font = .systemFont(ofSize: 16, weight: .bold)
        textField.placeholder = Constant.searchTextFieldPlaceholder
        
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.clearButtonMode = .whileEditing
        
        textField.leftViewMode = .always
        let leftView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        leftView.tintColor = .placeholderText
        textField.leftView = leftView
        
        return textField
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSubviews()
        setUpConstraints()
        configureNavigationBar()
        configureRootView()
    }
    
    private func setUpSubviews() {
        view.addSubview(searchTextField)
        view.addSubview(tableView)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            searchTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            searchTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            searchTextField.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.075),
            
            tableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func configureNavigationBar() {
        self.navigationItem.title = "영화 검색"
    }
    
    private func configureRootView() {
        view.backgroundColor = .systemBackground
    }
    
}

extension MovieSearchViewController {
    private enum Constant {
        static let searchTextFieldPlaceholder = "영화 제목을 입력하세요"
    }
}
