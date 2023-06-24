import UIKit
import RealmSwift

class RandomQuoteLoadViewController: UIViewController {

    
    let networkManager = NetworkManager()
    
    private lazy var button: UIButton = {
        let button = UIButton ()
        button.backgroundColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.setTitle("Load random quote", for: .normal)
        button.addTarget(self, action: #selector(didTapButton), for:.touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.addSubview(button)
        setupConstraints()
        view.backgroundColor = .systemGray4
        
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: safeAreaGuide.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: safeAreaGuide.centerYAnchor),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func didTapButton() {
        
        networkManager.downloadQuote {result in
            
            if result {
                DispatchQueue.main.async {
                    
                    let alert = UIAlertController (title: "Quote Download and Adding to Realm Success", message: "Check Quotes List to see Quotes", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .cancel)
                    alert.addAction(action)
                    self.present(alert, animated: true)
                    
                    }
            } else {
                DispatchQueue.main.async {
                    
                    let alert = UIAlertController (title: "Quote Adding to Realm Error", message: "Your Realm already has this quote, try Again", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .cancel)
                    alert.addAction(action)
                    self.present(alert, animated: true)
                }
            }
            
        }
    }

}
