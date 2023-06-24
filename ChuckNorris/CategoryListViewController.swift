//
//  CategoryListViewController.swift
//  ChuckNorris
//
//  Created by Александр Филатов on 24.06.2023.
//

import UIKit

class CategoryListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

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
        
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.title = "Category List"

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
    
    func deleteDublacateFromArray () -> [String] {
        
        let baseCategoryArray = delegate.networkManager.quotes.map({$0.category})
        let resultCategoryArray = baseCategoryArray.uniqued()
        return resultCategoryArray
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return deleteDublacateFromArray().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        var configuration = UIListContentConfiguration.cell()
        configuration.text = deleteDublacateFromArray()[indexPath.row]
        cell.contentConfiguration = configuration
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let filteredQuotes = delegate.networkManager.quotes.filter({$0.category == deleteDublacateFromArray()[indexPath.row]})
        let quoteInCategoryController = QuoteInCategoryViewController(quotesArray: filteredQuotes)
        present(quoteInCategoryController, animated: true)
    }
}

//расширение для удаления повторяющихся элементов из массива, спасибо stackoverflow)
extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
