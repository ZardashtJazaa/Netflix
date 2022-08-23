//
//  TitleTableViewCell.swift
//  Netflix
//
//  Created by Zardasht on 8/19/22.
//

import UIKit

class TitleTableViewCell: UITableViewCell {
    
    //MARK: - Properety
    static let identifier = String(describing: TitleCollectionViewCell.self)
    
    //playTitleButton
    private let playTitleButton: UIButton = {
       
        let button = UIButton()
        let image = UIImage(systemName: "play.circle",withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
        
    }()
    
    
    //titleLabel
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    
    //titlePosterUiImageView
    private let titlePosterUiImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        return imageView
        
    }()
    
    //MARK: - applyConstrains
    private func applyConstrains() {
        
        var titlePosterUiImageViewConstraints = [NSLayoutConstraint]()
        //titlePosterUiImageView.leading = contentView.leading
        titlePosterUiImageViewConstraints += [NSLayoutConstraint.init(item: titlePosterUiImageView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1.0, constant: 0.0)]
        //titlePosterUiImageView.top = contentView.top + 15
        titlePosterUiImageViewConstraints += [NSLayoutConstraint.init(item: titlePosterUiImageView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1.0, constant: 10)]
        //titlePosterUiImageView.bottom = contentView.bottom - 20
        titlePosterUiImageViewConstraints += [NSLayoutConstraint.init(item: titlePosterUiImageView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1.0, constant: -15)]
        //titlePosterUiImageView.width = 100
        titlePosterUiImageViewConstraints += [NSLayoutConstraint.init(item: titlePosterUiImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100)]
        
        
        var titleLabelConstraints = [NSLayoutConstraint]()
        //titleLabel.leading = titlePosterImageView.trailing + 20
        titleLabelConstraints += [NSLayoutConstraint.init(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: titlePosterUiImageView, attribute: .trailing, multiplier: 1.0, constant: 20)]
        //titleLabel.centerY = contentView.centerY
        titleLabelConstraints += [NSLayoutConstraint.init(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0.0)]
        
        
        var playTitleButtonConstarints = [NSLayoutConstraint]()
        //playTitleButton.trailing = contentView.trailing + 20
        playTitleButtonConstarints += [NSLayoutConstraint.init(item: playTitleButton, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1.0, constant: -20)]
        //playTitleButton.centerY = contentView.centerY
        playTitleButtonConstarints += [NSLayoutConstraint.init(item: playTitleButton, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0.0)]
        
        NSLayoutConstraint.activate(titlePosterUiImageViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(playTitleButtonConstarints)
        
    }
    
    //MARK: - Configurations
    public func configure(with model:TitleViewModel ) {
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterUrl)") else {
            return
        }
        titlePosterUiImageView.sd_setImage(with: url,completed: nil)
        titleLabel.text = model.titleName
    }
    
    
    //Init UitableViewCell
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titlePosterUiImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(playTitleButton)
        applyConstrains()
        
        
    }
    //Init Coder
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError()
    }
    
    

}
