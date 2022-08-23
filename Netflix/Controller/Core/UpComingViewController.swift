//
//  UpComingViewController.swift
//  Netflix
//
//  Created by Zardasht on 8/18/22.
//

import UIKit

class UpComingViewController: UIViewController {

    //MARK: - Properety
    private var titles: [Title] = [Title]()
    
    
    //MARK: - TableView
    private let upcomingTableView: UITableView = {
       
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        
        return table
        
    }()
    
    
    //MARK: - viewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        upcomingTableView.frame = view.bounds
        
    }
    
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .white
        view.addSubview(upcomingTableView)
        upcomingTableView.delegate = self
        upcomingTableView.dataSource = self
        fetchUpComingMoviews()
        
    }
    
    //MARK: - fetchUpComingMoviews
    private func fetchUpComingMoviews() {
        NetworkServices.shared.getUpComingMovies { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.upcomingTableView.reloadData()
                }
                
            case .failure(let error):
                
                print(error.localizedDescription)
            }
        }
    }

}



//MARK: - UpcomingTableViewCell
extension UpComingViewController: UITableViewDataSource , UITableViewDelegate {
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        5
//    }
//
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        let title = titles[indexPath.row]
        
        cell.configure(with: TitleViewModel(titleName: (title.original_title ?? title.original_name) ?? "Unknow Image URL", posterUrl: title.poster_path ?? ""))
       
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.original_name else {
            return
        }
        
        NetworkServices.shared.getMovie(with: titleName) { [ weak self] results in
            
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
