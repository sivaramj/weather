//
//  SearchTableViewController.swift
//  WeatherApp
//
//  Created by Jebamani, Sivaram [GCB-OT NE] on 12/26/17.
//  Copyright © 2017 Jebamani, Sivaram. All rights reserved.
//

import UIKit
import CoreData
class SearchTableViewController: UITableViewController {
    
    weak var delegate: SearchDelegate?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var errorLabel: UILabel!
    
    var searchText: String?
    
    lazy var fetchedhResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: CitiesList.self))
        fetchRequest.predicate = NSPredicate(format: "cityName CONTAINS[C] %@", "")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: constant.cityName, ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchBar.barTintColor = UIColor.black
        searchController.searchBar.backgroundColor = UIColor.black
        self.tableView.backgroundColor = UIColor.black
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = UIColor.white
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.placeholder = constant.searchPlaceHolder
        tableView.separatorStyle = .none
        self.noResultFound()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchController.isActive = true
        searchController.searchBar.becomeFirstResponder()
        self.performFetch()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.fetchedhResultController.sections?[section].numberOfObjects ?? 0
    }
    
    /// Query cityName and display the result
    func filterList(searchText: String) {
        self.searchText = searchText
        let searchPredicate = NSPredicate(format: "cityName CONTAINS[C] %@", searchText)
        self.fetchedhResultController.fetchRequest.predicate = searchPredicate
        self.performFetch()
        self.errorLabel.isHidden = (self.fetchedhResultController.sections?[0].numberOfObjects != 0)
        self.tableView.reloadData()
    }
    
    func performFetch() {
        do {
            try self.fetchedhResultController.performFetch()
        } catch let error  {
            print("ERROR: \(error)")
        }
    }
    
    /// Adding a label to show the user saying "No Cities found!"
    func noResultFound() {
        self.errorLabel = UILabel(frame: CGRect(x: 0, y: 60, width: self.tableView.frame.size.width, height: 100))
        errorLabel.text = constant.noCities
        errorLabel.textAlignment = .center
        errorLabel.textColor = UIColor.white
        self.tableView.addSubview(errorLabel)
        self.errorLabel.isHidden = true
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: constant.cellReuseIdentifier)
        
        // Configure the cell...
        let dict = self.fetchedhResultController.object(at: indexPath) as? CitiesList
        if let city = dict?.cityName, let text = self.searchText {
            cell.textLabel?.textColor = UIColor.darkGray
            cell.textLabel?.attributedText = self.getAttributedText(city: city, searchText: text)
        } else {
            cell.textLabel?.text = dict?.cityName
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = self.fetchedhResultController.object(at: indexPath) as? CitiesList
        if let city = dict?.cityName {
            self.delegate?.updateWeatherUI(searchCity: city)
            searchController.isActive = false
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    /// Highlights the user inputed text Bold on the searched list
    func getAttributedText(city: String, searchText: String) -> NSAttributedString {
        let range:NSRange = (city as NSString).range(of: searchText)
        let attText = NSMutableAttributedString(string: city)
        attText.addAttributes([NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16),
                               NSAttributedStringKey.foregroundColor: UIColor.black], range: range)
        return attText
    }
    
}


extension SearchTableViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
        self.dismiss(animated: true, completion: nil)
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filterList(searchText: searchBar.text!)
    }
}


