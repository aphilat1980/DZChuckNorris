//
//  QuoteListViewController.swift
//  ChuckNorris
//
//  Created by Александр Филатов on 24.06.2023.
//

import UIKit

class QuoteListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var delegate:RandomQuoteLoadViewController
    
    init(delegate: RandomQuoteLoadViewController) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
       
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Quotes List"
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .systemGray4
        view.addSubview(tableView)
        setupConstraints()
        
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor)
        ])
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (delegate.networkManager.quotes.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        var configuration = UIListContentConfiguration.cell()
        configuration.text = delegate.networkManager.quotes[indexPath.row].jokeText
        configuration.secondaryText = "Category: \(delegate.networkManager.quotes[indexPath.row].category), Download time: \(delegate.networkManager.quotes[indexPath.row].downloadDate)"
        cell.contentConfiguration = configuration
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        delegate.networkManager.deleteQuote(index: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    


}
