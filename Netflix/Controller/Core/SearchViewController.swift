//
//  SearchViewController.swift
//  Netflix
//
//  Created by Zardasht on 8/18/22.
//

import UIKit

class SearchViewController: UIViewController {
    //MARK: - Properety
    private var titles: [Title] = [Title]()
    
    //discoverTable
    private let discoverTable: UITableView = {
       
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
        
    }()
    //searchViewController
    private let searchViewController: UISearchController = {
       
        var controller = UISearchController()
        controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.placeholder = "Search for a movie or TV Showes"
        controller.searchBar.searchBarStyle = .minimal
        return controller
        
    }()
    
    
    
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Top Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .white
        navigationItem.searchController = searchViewController
        view.addSubview(discoverTable)
        discoverTable.delegate = self
        discoverTable.dataSource = self
        searchViewController.searchResultsUpdater = self
        fetchDiscoverMovies()
    }
    
    //MARK: - fetchDiscoverMovies
    private func fetchDiscoverMovies() {
        NetworkServices.shared.getDiscoverMovies { [weak self] results in
            switch results {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.discoverTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    //ViewDidLayout
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTable.frame = view.bounds
    }
   

}


//MARK: - SearchViewController + Extentions


extension SearchViewController: UITableViewDelegate , UITableViewDataSource  {
        
    //NumberOfRowInSections
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    //cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        let title =  titles[indexPath.row]
        let model = TitleViewModel(titleName: title.original_name ?? title.original_title ?? "Unknown Name ", posterUrl: title.poster_path ?? "")
        cell.configure(with:model)
        
        return cell
    
    }
    
    //heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.original_name else { return }
        
        
        NetworkServices.shared.getMovie(with: titleName) { [weak self] results in
            
            switch results {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = TitlePreviewViewController()
                    vc.configure(with: TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverView: title.overview ?? ""))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
        
    }
   
}
//MARK: - Search Update + Extentions
extension SearchViewController: UISearchResultsUpdating,SearchResultsViewControllerDelegate {
    
    //Update Search Result
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let searchController = searchController.searchResultsController as? SearchResultsViewController else { return }
            
        searchController.delegate = self
            
        NetworkServices.shared.search(with: query) { results in
            DispatchQueue.main.async {
                
                switch results {
                case .success(let title):
                    searchController.titles = title
                    searchController.searchResultCollectionView.reloadData()
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    //SearchResultsViewControllerDidTabItem
    func SearchResultsViewControllerDidTabItem(_ model: TitlePreviewViewModel) {
        
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: model)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}
