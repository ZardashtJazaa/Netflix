//
//  TitleCollectionViewCell.swift
//  Netflix
//
//  Created by Zardasht on 8/18/22.
//

import UIKit
import SDWebImage

class TitleCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: TitleCollectionViewCell.self)
    
    
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
        
    }()
    
    
    //MARK: - Configure
    public func configure(with model:String ) {
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model)") else {
            return
        }
        posterImageView.sd_setImage(with: url,completed: nil)
        
    }
    
    
    
    //LayoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
    }
    
    //Init Frame
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
    }
    
    //Init Coder
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError()
    }
    
    
    
}
