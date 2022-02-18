//
//  MenuTableViewController.swift
//  OrderApp
//
//  Created by Qnarik Davtyan on 30.01.22.
//

import UIKit

@MainActor
class MenuTableViewController: UITableViewController {
    
    let category: String
    var menuItems = [MenuItem]()
    
    init?(coder: NSCoder, category: String) {
        self.category = category
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = category.capitalized
        
        Task.init {
            do {
                let menuItems =
                try await MenuController.shared.fetchMenuItem(forCategory: category)
               updateUI(with: menuItems)
            } catch {
                displayError(error, title: "Failed to Fetch Menu Items for \(self.category)")
            }
        }
    }

func updateUI(with menuItems: [MenuItem]) {
    self.menuItems = menuItems
    self.tableView.reloadData()
}

func displayError(_ error: Error, title: String) {
    guard let _ = viewIfLoaded?.window else { return }
    let alert = UIAlertController(
        title: title,
        message: error.localizedDescription,
        preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
    self.present(alert, animated: true, completion: nil)
}
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =
        tableView.dequeueReusableCell(withIdentifier: "MenuItem", for: indexPath)
        configure(cell, forItemsAt: indexPath)
        return cell
    }
    
    func configure(_ cell: UITableViewCell, forItemsAt indexPath: IndexPath) {
        let menuItem = menuItems[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = menuItem.name
        content.secondaryText =
        menuItem.price.formatted(.currency(code: "usd"))
        content.image = UIImage(systemName: "photo.on.rectangle")
        cell.contentConfiguration = content
        
        Task.init {
            if let image = try? await MenuController.shared.fetchImage(from: menuItem.imageURL) {
                
            }
        }
    }
    
    @IBSegueAction func showMenuItem(_ coder: NSCoder, sender: Any?) -> MenuItemDetailViewController? {
        
        guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell)
        else { return nil }
        
        let menuItem = menuItems[indexPath.row]
        return MenuItemDetailViewController(coder: coder, menuItem: menuItem)
    }
    
}
