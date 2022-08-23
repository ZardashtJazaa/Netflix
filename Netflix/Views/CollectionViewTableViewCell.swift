//
//  CollectionViewTableViewCell.swift
//  Netflix
//
//  Created by Zardasht on 8/18/22.
//

import UIKit

protocol CollectionViewTableViewCellDelegate: AnyObject {
    func CollectionViewTableViewCellDidTab(_ cell: CollectionViewTableViewCell , viewModel: TitlePreviewViewModel)
    
}


class CollectionViewTableViewCell: UITableViewCell {
    
    //MARK: - Properety
    
    weak var delegate: CollectionViewTableViewCellDelegate?
    
    private var titles: [Title] = [Title]()
    //Identifier
    static let identifier = String(describing: CollectionViewTableViewCell.self)
    
    //MARK: - CollectionsView
    private let collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        
        layout.scrollDirection = .horizontal
        lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        
        return collectionView
        
    }()
    
    //init Style
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemPink
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
    }
    
    //Configure
    public func configure(with title: [Title] ) {
        self.titles = title
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
        
    }
    
    //downloadIndexPathAt
    private func downloadTitleAt(_ indexPath:IndexPath) {
        DataPersistanceManager.shared.downloadTitleWith(titles[indexPath.row]) { results in
            switch results {
            case .success():
                NotificationCenter.default.post(name: NSNotification.Name("Downloaded"), object: nil)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    //init coder
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //LayoutSubview
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
}

//MARK: - CollectionViewCell + Extentions
extension CollectionViewTableViewCell: UICollectionViewDelegate , UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        guard let model = titles[indexPath.row].poster_path else {
            return UICollectionViewCell()
        }
        cell.configure(with: model)
        // cell.backgroundColor = .white
        
        return cell
    }
    
    //DidSelectRow
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.original_name else {
            return
        }
        
        NetworkServices.shared.getMovie(with: titleName + " trailer") { [weak self] results in
            switch results {
            case .success(let videoElement):
                
                let title = self?.titles[indexPath.row]
                guard let titleOverview = title?.overview else {
                    return
                }
                guard let strongSelf = self else {
                    return
                }
                let viewModel = TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverView: titleOverview)
                
                self?.delegate?.CollectionViewTableViewCellDidTab(strongSelf, viewModel: viewModel)
                
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        
        let config = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil) { [weak self] _ in
                
                let downloadAction = UIAction(title: "Download", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    self?.downloadTitleAt(indexPath)
                }
                return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
                
        }
        return config
    }
    
    
    
    
}
