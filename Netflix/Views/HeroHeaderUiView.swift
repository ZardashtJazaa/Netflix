//
//  HeroHeaderUiView.swift
//  Netflix
//
//  Created by Zardasht on 8/18/22.
//

import UIKit

class HeroHeaderUiView: UIView {
    
    
    
    //MARK: - HeroImageView
    private let heroImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "SpiderMan")
        imageView.clipsToBounds = true
        return imageView
        
    }()
    
    //MARK: - PlayButton
    private let PlayButton: UIButton = {
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - DownloadButton
    private let DownloadButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
        
    }()
    
    //MARK: - Gradiant
    private func addGradiant() {
        let gradiantLayer = CAGradientLayer()
        gradiantLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor,
        ]
        gradiantLayer.frame = bounds
        layer.addSublayer(gradiantLayer)
        
    }
    
    //MARK: - CheckForDevice
    private func checkForDevice() {
        
        let widthSizeClass = traitCollection.horizontalSizeClass
        let heightSizeClass = traitCollection.verticalSizeClass
        
        var constraints = PlayButton.constraints
        NSLayoutConstraint.deactivate(constraints)
        let widthButton = constraints.index { (constraints) in
            constraints.identifier == "widthButtons"
        }
        
        if widthSizeClass == .regular && heightSizeClass == .regular{
            print("iPad")
            //customizing Buttons
            PlayButton.layer.borderWidth = 2
            DownloadButton.layer.borderWidth = 2
            
            constraints[widthButton!] = NSLayoutConstraint.init(item: PlayButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 250)
            constraints[widthButton!].identifier = "widthButtons"
            
        } else {
            if heightSizeClass == .compact{
                print("iPhone Landscape")
                
                constraints[widthButton!] = NSLayoutConstraint.init(item: PlayButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 125)
                constraints[widthButton!].identifier = "widthButtons"
                
            } else {
                print("iPhone Portrait")
                
                constraints[widthButton!] = NSLayoutConstraint.init(item: PlayButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 125)
                constraints[widthButton!].identifier = "widthButtons"
                
                
            }
        }
     
        NSLayoutConstraint.activate(constraints)
    }
    
    
    //MARK: - PlayButtonConstraint
    private func PlayButtonConstraint() {
        
        var playButtonConstraint = [NSLayoutConstraint]()
        //playButton.leading = heroImageView.leading + 25
        playButtonConstraint += [NSLayoutConstraint.init(item: PlayButton, attribute: .leading, relatedBy: .equal, toItem: heroImageView, attribute: .leading, multiplier: 1.0, constant: 70)]
        //playButton.bottom = heroImageView.bottom -20
        playButtonConstraint += [NSLayoutConstraint.init(item: PlayButton, attribute: .bottom, relatedBy: .equal, toItem: heroImageView, attribute: .bottom, multiplier: 1.0, constant: -50)]
        //playButton.width = 125
        let widthButtons = NSLayoutConstraint.init(item: PlayButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 125)
        widthButtons.identifier = "widthButtons"
        playButtonConstraint += [widthButtons]
        NSLayoutConstraint.activate(playButtonConstraint)
        
    }
    
    //MARK: - DownloadButtonConstraint
    private func DownloadButtonConstraints() {
        var DownloadButtonConstraints = [NSLayoutConstraint]()
        
        //downloadButton.bottom = playButton.bottom
        DownloadButtonConstraints += [NSLayoutConstraint.init(item: DownloadButton, attribute: .bottom, relatedBy: .equal, toItem: PlayButton, attribute: .bottom, multiplier: 1.0, constant: 0.0)]
        //downloadButton.trailing = heroImage.trailing
        DownloadButtonConstraints += [NSLayoutConstraint.init(item: DownloadButton, attribute: .trailing, relatedBy: .equal, toItem: heroImageView, attribute: .trailing, multiplier: 1.0, constant: -60)]
        //downloadButton.width = playButton.width
        DownloadButtonConstraints += [NSLayoutConstraint.init(item: DownloadButton, attribute: .width, relatedBy: .equal, toItem: PlayButton, attribute: .width, multiplier: 1.0, constant: 0.0)]
        
        NSLayoutConstraint.activate(DownloadButtonConstraints)
    }
    
    
    //configureImage
    
    public func configure(with model: TitleViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterUrl)") else {
            return
        }
        heroImageView.sd_setImage(with: url,completed: nil)
    }
    
    //LayoutSubView
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageView.frame = bounds
        checkForDevice()
    }
    
    //Init Frame
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(heroImageView)
        addGradiant()
        addSubview(PlayButton)
        PlayButtonConstraint()
        addSubview(DownloadButton)
        DownloadButtonConstraints()
    }
    //Init Coder
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    
    
}
