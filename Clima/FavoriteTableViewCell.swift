//
//  FavoriteTableViewCell.swift
//  Clima
//
//  Created by Глеб on 17.11.2019.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit

class FavoriteTableViewCell : UITableViewCell {
    
    static let reuseId = "cell"
    
    let cardView : UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.8)
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    let cityLabel : UILabel = {
       let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 20)
        return lbl
    }()
    
    let temperatureLabel : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 25)
        lbl.textAlignment = .right
        return lbl
    }()
    
    let weatherIcon : UIImageView = {
       let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.backgroundColor = .clear
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: FavoriteTableViewCell.reuseId)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(cardView)
        backgroundColor = .clear
        selectionStyle = .none
        cardView.topAnchor.constraint(equalTo: topAnchor, constant: 2.5).isActive = true
        cardView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
        cardView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
        cardView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2.5).isActive = true
        
        cardView.addSubview(cityLabel)
//        cityLabel.backgroundColor = .whiter
        cityLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 2).isActive = true
        cityLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 2).isActive = true
        
        cardView.addSubview(temperatureLabel)
//        temperatureLabel.backgroundColor = .white
        temperatureLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -8).isActive = true
        temperatureLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor).isActive = true
        temperatureLabel.heightAnchor.constraint(equalTo: cardView.heightAnchor, multiplier: 0.7).isActive = true
        temperatureLabel.widthAnchor.constraint(equalTo: cardView.heightAnchor, multiplier: 0.7).isActive = true
        
        cardView.addSubview(weatherIcon)
//        weatherIcon.backgroundColor = .white
        weatherIcon.trailingAnchor.constraint(equalTo: temperatureLabel.leadingAnchor, constant: -2).isActive = true
        weatherIcon.centerYAnchor.constraint(equalTo: cardView.centerYAnchor).isActive = true
        weatherIcon.heightAnchor.constraint(equalTo: cardView.heightAnchor, multiplier: 0.7).isActive = true
        weatherIcon.widthAnchor.constraint(equalTo: cardView.heightAnchor, multiplier: 0.7).isActive = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animate(isHighlighted: true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animate(isHighlighted: false)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animate(isHighlighted: false)
    }
    
    private func animate(isHighlighted: Bool, completion: ((Bool) -> Void)?=nil) {
        let animationOptions: UIView.AnimationOptions = [.allowUserInteraction]
        if isHighlighted {
            UIView.animate(withDuration: 0.2,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0,
                           options: animationOptions, animations: {
                            self.transform = .init(scaleX: 0.9, y: 0.9)
            }, completion: completion)
        } else {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0,
                           options: animationOptions, animations: {
                            self.transform = .identity
            }, completion: completion)
        }
    }
    
}
