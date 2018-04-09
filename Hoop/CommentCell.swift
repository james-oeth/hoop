//
//  CommentCell.swift
//  sherpaApp
//
//  Created by james oeth on 12/29/16.
//  Copyright © 2016 jamesOeth. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class CommentCell: UITableViewCell {
    
    var comment: Comment? {
        didSet {
            setupCommentValues()
        }
    }
    
    func setupCommentValues(){
        if let url = comment!.photo as? String{
            DispatchQueue.global(qos: .userInitiated).async {
                self.profileImageView.loadImageUsingCacheWithUrlString(url)
            }
        }
        
        if let t = comment!.name as? String{
            nameLabel.text = t
        }
        nameLabel.text = (comment?.name as? String ?? "titties")
        print("Name label text")
        print(nameLabel.text ?? "Noname")
        
        if let x = comment!.comment as? String{
            commentLabel.text = x
        }
        
        if let seconds = comment!.time?.doubleValue {
            let timestampDate = Date(timeIntervalSinceReferenceDate: seconds)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd YYYY"
            timeLabel.text = dateFormatter.string(from: timestampDate as Date)
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }
    
    let timeLabel:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.boldSystemFont(ofSize: 12)
        l.textAlignment = .left
        l.textColor = UIColor.black
        l.backgroundColor = UIColor.clear
        return l
    }()
    
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
        l.font = UIFont.boldSystemFont(ofSize: 12)
        l.textAlignment = .left
        l.textColor = UIColor.black
        l.backgroundColor = UIColor.clear
        l.text = "tits"
        return l
    }()
    
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "puppies")
        return imageView
    }()
    
    let commentLabel:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.boldSystemFont(ofSize: 16)
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
        profileImageView.leftAnchor.constraint(equalTo: cellView.leftAnchor,constant: 5).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        cellView.addSubview(timeLabel)
        timeLabel.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 5).isActive = true
        timeLabel.rightAnchor.constraint(equalTo: cellView.rightAnchor).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        cellView.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 5).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: timeLabel.leftAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        cellView.addSubview(commentLabel)
        commentLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 5).isActive = true
        commentLabel.rightAnchor.constraint(equalTo: cellView.rightAnchor, constant: -5).isActive = true
        commentLabel.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -5).isActive = true
        commentLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        cellView.addSubview(seperatorView)
        seperatorView.bottomAnchor.constraint(equalTo: cellView.bottomAnchor).isActive = true
        seperatorView.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 50).isActive = true
        seperatorView.rightAnchor.constraint(equalTo: cellView.rightAnchor).isActive = true
        seperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
