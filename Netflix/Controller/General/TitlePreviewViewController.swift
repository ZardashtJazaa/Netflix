//
//  TitlePreviewViewController.swift
//  Netflix
//
//  Created by Zardasht on 8/20/22.
//

import UIKit
import WebKit

class TitlePreviewViewController: UIViewController {
    
    //webView
    private let webView: WKWebView = {
       
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
        
        
    }()
    
    //downloadButton
    private let downloadButton: UIButton = {
       
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.setTitle("Download", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.mask?.clipsToBounds = true
        return button
        
    }()
    
    //overViewLabel
    private let overViewLabel: UILabel = {
       
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        label.text = "This is the best movie i have ever seen in my life and this is number one around the world trust me."
        label.textColor = .white
        return label
    }()
    
    //titleLabel
    private let titleLabel: UILabel = {
       
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = "harry Poter"
        label.textColor = .white
        return label
    }()
    
    
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(webView)
        view.addSubview(titleLabel)
        view.addSubview(overViewLabel)
        view.addSubview(downloadButton)
        
        configurationsConstraints()
        
        
    }
    
    //MARK: - Configure trailerVideo
    func configure(with model:TitlePreviewViewModel) {
        
        titleLabel.text = model.title
        overViewLabel.text = model.titleOverView
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeView.id.videoId)") else {
            return
        }
        
        webView.load(URLRequest(url: url))
        
    }
    
    
    //MARK: - Configurations
    private func configurationsConstraints() {
        
        //WebViewConstraints
        var webViewConstraints = [NSLayoutConstraint]()
        
        //webView.top = view.top  + 50
        webViewConstraints += [NSLayoutConstraint.init(item: webView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 50.0)]
//        webView.leading = view.leading
        webViewConstraints += [NSLayoutConstraint.init(item: webView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0.0)]
        //webView.trailing = view.trailing
        webViewConstraints += [NSLayoutConstraint.init(item: webView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0.0)]
        //webView.height = 250
        webViewConstraints += [NSLayoutConstraint.init(item: webView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 300)]
        
        //titleLabelConstraints
        var titleLabelConstraints = [NSLayoutConstraint]()
        
        //titleLabel.top = webView.bottom + 20
        titleLabelConstraints += [NSLayoutConstraint.init(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: webView, attribute: .bottom, multiplier: 1.0, constant: 20)]
        //titleLabel.leading = view.leading + 20
        titleLabelConstraints += [NSLayoutConstraint.init(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 20)]
        
        //overViewLabelConstraints
        var overViewLabelConstraints = [NSLayoutConstraint]()
        
        //overViewLabel.top = webView.bottom + 20
        overViewLabelConstraints += [NSLayoutConstraint.init(item: overViewLabel, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1.0, constant: 20)]
        //overViewLabel.leading = view.leading + 20
        overViewLabelConstraints += [NSLayoutConstraint.init(item: overViewLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 20)]
        //overViewLabel.trailing = view.trailing
        overViewLabelConstraints += [NSLayoutConstraint.init(item: overViewLabel, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0.0)]
        //downloadButtonConstraints
        var downloadButtonConstraints = [NSLayoutConstraint]()
//
//        //downloadButton.centerX = view.centerX
        downloadButtonConstraints += [NSLayoutConstraint.init(item: downloadButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0)]
//        downloadButton.top = overViewLabel.bottom + 25
        downloadButtonConstraints += [NSLayoutConstraint.init(item: downloadButton, attribute: .top, relatedBy: .equal, toItem: overViewLabel, attribute: .bottom, multiplier: 1.0, constant: 25)]
        //downloadButton.width = 100
        downloadButtonConstraints += [NSLayoutConstraint.init(item: downloadButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 140)]
        //downloadButton.height = 40
        downloadButtonConstraints += [NSLayoutConstraint.init(item: downloadButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40)]
        
        NSLayoutConstraint.activate(webViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(overViewLabelConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
    }


}
