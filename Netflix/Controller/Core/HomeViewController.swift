//
//  HomeViewController.swift
//  Netflix
//
//  Created by Zardasht on 8/18/22.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK: - Properety
    
    //SectionTitle
    private let sectionTitle: [String] = ["Trending Movies", "Trending TV" , "Popular" , "UpComing Movies" , "Top Rated"]
    private var randomTrendingMovie: Title?
    private var headerView: HeroHeaderUiView?
    
    //MARK: - HomeFeedTable
    private let HomeFeedTable: UITableView = {
        let table  = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier:CollectionViewTableViewCell.identifier)
        table.showsVerticalScrollIndicator = false
        return table
    }()
    
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(HomeFeedTable)
        HomeFeedTable.delegate = self
        HomeFeedTable.dataSource = self
        configureNavbar()
        
        headerView = HeroHeaderUiView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        HomeFeedTable.tableHeaderView = headerView
        configureHeroHeaderView()
     }
    
    //MARK: - ConfigureHeaderView
    private func configureHeroHeaderView() {
        NetworkServices.shared.getTrendingMovies { [weak self] results in
            
            switch  results {
            case .success(let titles):
                let selectedTitle = titles.randomElement()
                self?.randomTrendingMovie = selectedTitle
                self?.headerView?.configure(with: TitleViewModel(titleName: selectedTitle?.original_title ?? "", posterUrl: selectedTitle?.poster_path ?? ""))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    //MARK: - TrendingMoviews
    private func TrendingMoviews() {
        NetworkServices.shared.getTrendingMovies { results in
            
            switch results {
            case .success(let movies):
                print(movies)
            
            case .failure(let error):
                print(error.localizedDescription)
            }
            
            
        }
    }
    
   
    
    //MARK: - viewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        HomeFeedTable.frame = view.bounds
    }
    
    
    //MARK: - ConfigureNavbar
    private func configureNavbar(){
        var netflixLogo = UIImage(named: Constance.NetflixLogo)
        netflixLogo = netflixLogo?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem  = UIBarButtonItem(image: netflixLogo, style: .done, target: self, action: nil)
        
        navigationItem.rightBarButtonItems  = [
            
            UIBarButtonItem(image: UIImage(systemName: Constance.personImage), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: Constance.playImage), style: .done, target: self, action: nil)
        
        ]
        navigationController?.navigationBar.tintColor = .white
    }
    
}//HomeViewController



//MARK: - HomeFeedTableView Extentions
extension HomeViewController: UITableViewDelegate , UITableViewDataSource {
    
    //NumberOfSections
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    
    //numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    //cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
             return UITableViewCell()
        }
        cell.delegate = self
        //MARK: - Switching For API call
        switch indexPath.section {
            
        case HomeSections.TrendingMovie.rawValue:
            NetworkServices.shared.getTrendingMovies { results  in
                switch results {
                case.success(let title):
                    cell.configure(with: title)
                case .failure(let error):
                    print(error.localizedDescription)
                    
                }
            }
        case HomeSections.TrendingTV.rawValue:
            NetworkServices.shared.getTrendingTvs { results in
                switch results {
                case.success(let title):
                    cell.configure(with: title)
                case .failure(let error):
                    print(error.localizedDescription)
                    
                }
            }
            
        case HomeSections.Popular.rawValue:
            NetworkServices.shared.getPopularMovies { results in
                switch results {
                case.success(let title):
                    cell.configure(with: title)
                case .failure(let error):
                    print(error.localizedDescription)
                    
                }
            }
        case HomeSections.UpcomingMovie.rawValue:
            NetworkServices.shared.getUpComingMovies { results in
                switch results {
                case.success(let title):
                    cell.configure(with: title)
                case .failure(let error):
                    print(error.localizedDescription)
                    
                }
            }
        case HomeSections.TopRated.rawValue:
            NetworkServices.shared.getTopRated { results in
                switch results {
                case.success(let title):
                    cell.configure(with: title)
                case .failure(let error):
                    print(error.localizedDescription)
                    
                }
            
            }
        default:
            //Basic Cell
            return UITableViewCell()
        }
        
        
        
        return cell
    }
    
    //titleForHeaderInSection
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sectionTitle[section]
    }
    
    //willDisplayHeaderView
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {  return }
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.capitalized
        
    }
    
    
    //heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    //heightForHeaderInSection
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    //didScroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let defaultOffset = view.safeAreaInsets.top
        //        print("defaultOffset \(defaultOffset)")
        //        print("before calculations: \(scrollView.contentOffset.y)")
        let offset = scrollView.contentOffset.y + defaultOffset
        //        print("after calculation \(offset)")
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
        
    }
    
}


//MARK: - Extentions

extension HomeViewController: CollectionViewTableViewCellDelegate {
    
    func CollectionViewTableViewCellDidTab(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel) {
        
        DispatchQueue.main.async { [weak self] in
            
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
       
    }
    
    
}
