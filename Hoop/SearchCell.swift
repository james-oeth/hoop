//
//  SearchCell.swift
//  sherpaApp
//
//  Created by james oeth on 12/29/16.
//  Copyright © 2016 jamesOeth. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SearchCell: UITableViewCell {
    
    var annotation: PinAnnotation? {
        didSet {
            setupSearchValues()
        }
    }
    
    func setupSearchValues(){
        if let imageUrlArray = annotation?.URLArray{
            if let s = imageUrlArray[0] as? String{
                profileImageView.loadImageUsingCacheWithUrlString(s)
                profileImageView.contentMode = .scaleAspectFill
            }
        }
        else{
            profileImageView.image = UIImage(named: "puppies")
            profileImageView.contentMode = .scaleAspectFit
        }
        if let t = annotation?.title{
            nameLabel.text = t
        }
        if let des = annotation?.subtitle{
            descriptionLabel.text = des
        }
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }
    
    let cellView:UIView = {
        let v = UIView()
        v.backgroundColor = MyVariables.backgroundColor
        v.layer.masksToBounds = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    let nameLabel:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.boldSystemFont(ofSize: 16)
        l.textAlignment = .left
        l.textColor = UIColor.black
        l.backgroundColor = UIColor.clear
        return l
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 3
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "puppies")
        return imageView
    }()
    
    let descriptionLabel:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.boldSystemFont(ofSize: 14)
        l.textAlignment = .left
        l.textColor = UIColor.black
        l.backgroundColor = UIColor.clear
        l.lineBreakMode = .byWordWrapping
        l.numberOfLines = 0;
        return l
    }()
    
    
    let seperatorView:UIView = {
        let v = UIView()
        v.backgroundColor = MyVariables.mainColor
        v.layer.masksToBounds = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCellSelectionStyle.none
        addSubview(cellView)
        cellView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        cellView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        cellView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        cellView.addSubview(profileImageView)
        profileImageView.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 3).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        profileImageView.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 3).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -6).isActive = true
        cellView.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 5).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 5).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: cellView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        cellView.addSubview(descriptionLabel)
        descriptionLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 5).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: cellView.rightAnchor, constant: -5).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -5).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        cellView.addSubview(seperatorView)
        seperatorView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: -20).isActive = true
        seperatorView.rightAnchor.constraint(equalTo: cellView.rightAnchor).isActive = true
        seperatorView.bottomAnchor.constraint(equalTo: cellView.bottomAnchor).isActive = true
        seperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
