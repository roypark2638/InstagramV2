//
//  SearchResultsViewController.swift
//  Instagram2
//
//  Created by Roy Park on 4/19/21.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func searchResultsViewController(
        _ cell: SearchResultsViewController,
        didSelectResultWith user: User)
}

class SearchResultsViewController: UIViewController {
    
    public weak var delegate: SearchResultsViewControllerDelegate?
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var users = [User]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.frame = view.bounds

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    public func update(with users: [User]) {
        self.users = users
        tableView.reloadData()
        tableView.isHidden = users.isEmpty
    }

}


// MARK: - UITableViewDataSource, UITableViewDataSource
extension SearchResultsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath
        )
        cell.textLabel?.text = users[indexPath.row].username
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.searchResultsViewController(self, didSelectResultWith: users[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
