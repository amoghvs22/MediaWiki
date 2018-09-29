//
//  ViewController.swift
//  MediaWiki
//
//  Created by Mac Mini on 29/09/18.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {
    

    let imageCache = NSCache<NSString, UIImage>()
    var wikiArray = [WikiDetails]()
    
    var shouldShowSearchResults = true
    
    var searchController: UISearchController!
    
    @IBOutlet var tblSearchResults: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblSearchResults.delegate = self
        tblSearchResults.dataSource = self
        
        configureSearchController()
    }
    
    //MARK:- API calls
    func fetchResults(searchText: String) {
        guard let url = URL(string: QueryAPICallPart1 + searchText + QueryAPICallPart2) else { return }
        print(url.absoluteString)
        let task = URLSession.shared.dataTask(with: url) { (data, res, error) in
            if error == nil {
                guard let wikiResults =  self.dataToDictionary(data) as NSDictionary?,
                    let resultsArray = WikiDetails.initializeArray(wikiResults) else {
                        DispatchQueue.main.async {
                            self.wikiArray.removeAll()
                            self.tblSearchResults.reloadData()
                        }
                        return
                }
                self.wikiArray = resultsArray
                DispatchQueue.main.async {
                    self.tblSearchResults.reloadData()
                }
            }
        }
        task.resume()
        
    }
    
    //MARK:- SearchBar functions
    func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = SearchHereText
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        tblSearchResults.tableHeaderView = searchController.searchBar
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        tblSearchResults.reloadData()
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        tblSearchResults.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        tblSearchResults.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        shouldShowSearchResults = false
        let formattedString = searchBar.text?.replacingOccurrences(of: " ", with: "+")
        fetchResults(searchText: formattedString!)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        shouldShowSearchResults = true
        if searchController.searchBar.text != "" {
            let formattedString = searchController.searchBar.text?.replacingOccurrences(of: " ", with: "+")
            fetchResults(searchText: formattedString!)
        }
    }
    
    //MARK:- Tableview functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wikiArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! WikiResultCell
        if shouldShowSearchResults {
            if indexPath.row >= wikiArray.count {
                return cell
            }
            cell.title.text = wikiArray[indexPath.row].title
            cell.imageview.image = UIImage(named: "placeholder")
            
            guard let imageURL = URL(string: wikiArray[indexPath.row].imgSource) else { return cell }
            print(imageURL)
            self.fetchImageInBackGround(imageURL, cell: cell)
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row >= wikiArray.count {
            return
        }
        
        
        guard let viewController = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "WikiResultInfoVC") as? WikiResultInfoVC else { return }
        viewController.urlString = wikiArray[indexPath.row].title
        
        DispatchQueue.main.async(execute: {
            self.navigationController?.pushViewController(viewController, animated: true)
        })
    }
    
    //MARK:- UTIL functions
    func dataToDictionary(_ data:Data?) -> [AnyHashable : Any]?{
        
        if data == nil{
            return nil
        }
        
        do
        {
            return try JSONSerialization.jsonObject(with: data!, options:[JSONSerialization.ReadingOptions.mutableContainers,JSONSerialization.ReadingOptions.mutableLeaves]) as? [AnyHashable : Any]
            
        }catch{
            return nil
        }
        
    }
    
    func fetchImageInBackGround(_ imageURL:URL, cell: WikiResultCell) {
        let task = URLSession.shared.dataTask(with: imageURL) { (data, res, error) in
            if error == nil {
                if let cachedImage = self.imageCache.object(forKey: res!.url!.absoluteString as NSString) {
                    DispatchQueue.main.async {
                        cell.imageview.image = cachedImage
                        return
                    }
                }
                
                DispatchQueue.main.async {
                    let imageToCache = UIImage(data: data!)!
                    self.imageCache.setObject(imageToCache, forKey: res!.url!.absoluteString as NSString)
                    cell.imageview.image = imageToCache
                }
            }
        }
        task.resume()
    }
}
