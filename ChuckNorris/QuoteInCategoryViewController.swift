//
//  QuoteInCategoryViewController.swift
//  ChuckNorris
//
//  Created by Александр Филатов on 24.06.2023.
//

import UIKit

class QuoteInCategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var quotes: [RealmQuoteObject]
    
    init(quotesArray: [RealmQuoteObject]) {
        self.quotes = quotesArray
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Quotes In Selected Category"
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
        return quotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        var configuration = UIListContentConfiguration.cell()
        configuration.text = quotes[indexPath.row].jokeText
        cell.contentConfiguration = configuration
        return cell
        
    }

}
    
    

  


