//
//  DownloadsViewController.swift
//  Netflix
//
//  Created by Zardasht on 8/18/22.
//

import UIKit

class DownloadsViewController: UIViewController {
    
    //MARK: - Properety
    private var titles: [TitleItem] =  [TitleItem]()
    
    //downloadsTableView
    private let downloadsTableView: UITableView = {
        
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
        
    }()
    
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(downloadsTableView)
        view.backgroundColor = .systemBackground
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        downloadsTableView.delegate = self
        downloadsTableView.dataSource = self
        fetchDataFromDatabseForDownload()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("Downloaded"), object: nil, queue: nil) { _ in
            self.fetchDataFromDatabseForDownload()
        }
    }
    
    //viewDidLayoutSubViews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadsTableView.frame = view.bounds
    }
    
    //fetchDataFromDatabseForDownload
    
    private func fetchDataFromDatabseForDownload() {
        DataPersistanceManager.shared.fetchingTitlesFromDatabase { [weak self ] results in
            switch results {
            case .success(let titles):
                DispatchQueue.main.async {
                    self?.titles = titles
                    self?.downloadsTableView.reloadData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    
}
//MARK: - Extenttions

extension DownloadsViewController: UITableViewDelegate , UITableViewDataSource {
    //numberOfRowInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    //cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        
        let title = titles[indexPath.row]
        cell.configure(with: TitleViewModel(titleName: title.original_name ?? title.original_title ?? "Unknow Title", posterUrl: title.poster_path ?? ""))
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        switch editingStyle {
        case .delete:
            
            DataPersistanceManager.shared.deleteTitleWith(model: titles[indexPath.row]) { [weak self] results in
                
                switch results {
                case .success():
                    print("Deleted from the database")
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self?.titles.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                
            }
        default:
            break
        }
        
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
