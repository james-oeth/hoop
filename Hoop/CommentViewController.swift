//
//  CommentViewController.swift
//  sherpaApp
//
//  Created by james oeth on 12/29/16.
//  Copyright © 2016 jamesOeth. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class commentViewController: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource{
    var commentTableView: UITableView  =   UITableView()
    var keyboardHeight: CGFloat = 0
    var keyboardBool = false
    var userProfile = UserProfile()
    var pinToDisplay: PinAnnotation?
    //arry to hold all of the comments
    var comments: [Comment] = []
    var fontHeight:CGFloat = 0
    var holderViewHeight:CGFloat = 50
    var lines = 1
    
    //make the text view for the user comment
    var userCommentView: UITextView = {
        var textView = UITextView()
        textView.autocorrectionType = .no
        textView.layer.cornerRadius = 5
        textView.layer.masksToBounds = false
        textView.font = UIFont(name: "HelveticaNeue", size: 18)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.allowsEditingTextAttributes = false
        return textView
    }()
    //make the profileimageview
    var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        return imageView
    }()
    //make a holder view to hold the profile image the send button and writing thingy
    var holderView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.borderWidth = 1
        v.layer.borderColor = MyVariables.mainColor.cgColor
        v.layer.cornerRadius = 5
        v.layer.masksToBounds = true
        return v
        
    }()
    //make the post button
    lazy var postButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.white
        button.setTitle("Post", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(MyVariables.mainColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(postButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let testView:UITextView = {
        var textView = UITextView()
        textView.layer.cornerRadius = 5
        textView.layer.masksToBounds = false
        textView.font = UIFont (name: "HelveticaNeue", size: 18)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.allowsEditingTextAttributes = false
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //test view shit
        /*
         view.addSubview(testView)
         testView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
         testView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
         testView.leftAnchor.constraint(equalTo: view.leftAnchor, constant:  50).isActive = true
         testView.heightAnchor.constraint(equalToConstant: 40).isActive = true
         testView.delegate = self
         */
        //real stuff
        if let font = userCommentView.font{
            fontHeight = font.lineHeight
        }
        view.backgroundColor = UIColor.white
        if let url = userProfile.profileImageUrl{
            profileImageView.loadImageUsingCacheWithUrlString(url)
        }
        comments.sorted { (comment1, comment2) -> Bool in
            guard let time1 = comment1.time as? Double else {
                return false
            }
            guard let time2 = comment2.time as? Double else {
                return true
            }
            return time1 < time2
        }
        navigationItem.title = "Comments"
        NotificationCenter.default.addObserver(self, selector: #selector(commentViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        //NotificationCenter.defaultCenter.addObserver(self, selector: #selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        // Do any additional setup after loading the view, typically from a nib.
        userCommentView.delegate = self
        userCommentView.becomeFirstResponder()
        commentTableView.delegate      =   self
        commentTableView.dataSource    =   self
        commentTableView.allowsSelection = false
        commentTableView.separatorStyle = .none
        commentTableView.translatesAutoresizingMaskIntoConstraints = false
        commentTableView.register(CommentCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(holderView)
        self.view.addSubview(commentTableView)
        holderView.addSubview(userCommentView)
        holderView.addSubview(profileImageView)
        holderView.addSubview(postButton)
    }
    
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        
        if (self.isMovingFromParentViewController){
            // Your code...
            let view = parent?.view
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CommentCell = commentTableView.dequeueReusableCell(withIdentifier: "cell")! as! CommentCell
        cell.comment = comments[indexPath.item]
        
        
        /*
         let cellView: UIView = {
         let v = UIView()
         v.backgroundColor = UIColor.whiteColor()
         v.translatesAutoresizingMaskIntoConstraints = false
         v.layer.borderWidth = 1
         v.layer.borderColor = MyVariables.mainColor.CGColor
         v.layer.cornerRadius = 5
         v.layer.masksToBounds = true
         return v
         
         }()
         cell.addSubview(cellView)
         cellView.topAnchor.constraintEqualToAnchor(cell.topAnchor).active = true
         cellView.leftAnchor.constraintEqualToAnchor(cell.leftAnchor).active = true
         cellView.rightAnchor.constraintEqualToAnchor(cell.rightAnchor).active = true
         cellView.bottomAnchor.constraintEqualToAnchor(cell.bottomAnchor).active = true
         
         let profileImageView: UIImageView = {
         let imageView = UIImageView()
         imageView.translatesAutoresizingMaskIntoConstraints = false
         imageView.contentMode = .ScaleAspectFill
         imageView.layer.cornerRadius = 25
         imageView.layer.masksToBounds = true
         imageView.image = UIImage(named: "puppies")
         return imageView
         }()
         cellView.addSubview(profileImageView)
         if let s = comments[indexPath.item].photo as? String{
         profileImageView.loadImageUsingCacheWithUrlString(s)
         }
         profileImageView.leftAnchor.constraintEqualToAnchor(cellView.leftAnchor).active = true
         profileImageView.centerYAnchor.constraintEqualToAnchor(cellView.centerYAnchor).active = true
         profileImageView.widthAnchor.constraintEqualToConstant(50).active = true
         profileImageView.heightAnchor.constraintEqualToConstant(50).active = true
         
         let nameLabel:UILabel = {
         let l = UILabel()
         l.translatesAutoresizingMaskIntoConstraints = false
         l.font = UIFont.boldSystemFontOfSize(12)
         l.textAlignment = .Left
         l.textColor = UIColor.blackColor()
         l.backgroundColor = UIColor.clearColor()
         return l
         }()
         if let t = comments[indexPath.item].name as? String{
         nameLabel.text = t
         }
         cellView.addSubview(nameLabel)
         nameLabel.topAnchor.constraintEqualToAnchor(cellView.topAnchor, constant: 5).active = true
         nameLabel.leftAnchor.constraintEqualToAnchor(profileImageView.rightAnchor).active = true
         nameLabel.rightAnchor.constraintEqualToAnchor(cellView.rightAnchor).active = true
         nameLabel.heightAnchor.constraintEqualToConstant(20).active = true
         
         let commentLabel:UILabel = {
         let l = UILabel()
         l.translatesAutoresizingMaskIntoConstraints = false
         l.font = UIFont.boldSystemFontOfSize(16)
         l.textAlignment = .Left
         l.textColor = UIColor.blackColor()
         l.backgroundColor = UIColor.clearColor()
         l.lineBreakMode = .ByWordWrapping
         l.numberOfLines = 0;
         return l
         }()
         if let x = comments[indexPath.item].comment as? String{
         commentLabel.text = x
         }
         cellView.addSubview(commentLabel)
         commentLabel.leftAnchor.constraintEqualToAnchor(profileImageView.rightAnchor, constant: 5).active = true
         commentLabel.rightAnchor.constraintEqualToAnchor(cellView.rightAnchor, constant: -5).active = true
         commentLabel.bottomAnchor.constraintEqualToAnchor(cellView.bottomAnchor, constant: -5).active = true
         commentLabel.topAnchor.constraintEqualToAnchor(nameLabel.bottomAnchor).active = true
         
         let timeLabel:UILabel = {
         let l = UILabel()
         l.translatesAutoresizingMaskIntoConstraints = false
         l.font = UIFont.boldSystemFontOfSize(12)
         l.textAlignment = .Left
         l.textColor = UIColor.blackColor()
         l.backgroundColor = UIColor.clearColor()
         return l
         }()
         
         if let seconds = comments[indexPath.item].time?.doubleValue {
         let timestampDate = NSDate(timeIntervalSinceReferenceDate: seconds)
         let dateFormatter = NSDateFormatter()
         dateFormatter.dateFormat = "MMM dd YYYY"
         timeLabel.text = dateFormatter.stringFromDate(timestampDate)
         }
         cellView.addSubview(timeLabel)
         timeLabel.topAnchor.constraintEqualToAnchor(cellView.topAnchor, constant: 5).active = true
         timeLabel.rightAnchor.constraintEqualToAnchor(cellView.rightAnchor).active = true
         timeLabel.widthAnchor.constraintEqualToConstant(100).active = true
         timeLabel.heightAnchor.constraintEqualToConstant(20).active = true
         */
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let x = comments[indexPath.item].comment as? String{
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 70, height: 10000))
            label.text = x
            label.numberOfLines = 100
            label.font = UIFont(name: "Times New Roman", size: 19.0)
            label.sizeToFit()
            return label.frame.height + 40
        }
        return 60
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(notification:NSNotification) {
        print("keyboard called")
        if keyboardBool == false{
            let userInfo:NSDictionary = notification.userInfo! as NSDictionary
            let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
            setupHolderView()
            setupCommentTableView()
            keyboardBool = true
            NotificationCenter.default.removeObserver(self)
        }
    }
    //TODO: make this work baby
    /*
     func keyboardWillShow(notification: NSNotification) {
     if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
     if self.view.frame.origin.y == 0{
     self.view.frame.origin.y -= keyboardSize.height
     }
     }
     }
     */
    
    
    func textViewDidChange(_ textView: UITextView) {
        /*
         var text = textView.text
         print(text)
         var arr = text.componentsSeparatedByString("\n")
         print(arr.count)
         */
        let numLines = Int(userCommentView.contentSize.height / userCommentView.font!.lineHeight)
        if numLines > lines{
            holderViewHeight += fontHeight
            let con = holderView.constraints
            holderView.removeConstraints(con)
            setupHolderView()
            lines += 1
        }
        else if numLines < lines{
            holderViewHeight -= fontHeight
            let con = holderView.constraints
            holderView.removeConstraints(con)
            setupHolderView()
            lines -= 1
        }
    }
    
    func setupHolderView(){
        keyboardHeight *= -1
        print("keyboard height")
        print(keyboardHeight)
        holderView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: keyboardHeight).isActive = true
        holderView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        holderView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        holderView.heightAnchor.constraint(equalToConstant: holderViewHeight).isActive = true
        setupUserCommentView()
        setupProfileImageView()
        setupPostButton()
    }
    
    func setupPostButton(){
        postButton.rightAnchor.constraint(equalTo: holderView.rightAnchor).isActive = true
        postButton.centerYAnchor.constraint(equalTo: holderView.centerYAnchor).isActive = true
        postButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        postButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupUserCommentView(){
        userCommentView.topAnchor.constraint(equalTo: holderView.topAnchor, constant: 5).isActive = true
        userCommentView.bottomAnchor.constraint(equalTo: holderView.bottomAnchor, constant: -5).isActive = true
        userCommentView.leftAnchor.constraint(equalTo: holderView.leftAnchor, constant: 50).isActive = true
        userCommentView.rightAnchor.constraint(equalTo: holderView.rightAnchor, constant: -50).isActive = true
    }
    func setupProfileImageView(){
        profileImageView.leftAnchor.constraint(equalTo: holderView.leftAnchor, constant: 5).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: holderView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func setupCommentTableView(){
        commentTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        commentTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        commentTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        commentTableView.bottomAnchor.constraint(equalTo: holderView.topAnchor).isActive = true
    }
    
    func postButtonTapped(){
        //time to do some firebase shit
        let com = Comment()
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            let ref = FIRDatabase.database().reference()
            let commentReference = ref.child("comments").childByAutoId()
            if let id = pinToDisplay!.id{
                let pinReference = ref.child("AllUserLocations").child(id).child("comments")
                var values: [String: Any]!
                let commentId = commentReference.key
                /*
                 var first = ""
                 var last = ""
                 if let fname = userProfile.firstName{
                 first = fname
                 }
                 if let lname = userProfile.lastName{
                 last = lname!
                 }
                 let name = first + " " + last
                 com.name = name as AnyObject?
                 */
                let name = (userProfile.username ?? "noname")
                com.name = userProfile.username as AnyObject?
                let comment = NSString(string: userCommentView.text)
                com.comment = comment
                var photoUrl = ""
                if let p = userProfile.profileImageUrl{
                    photoUrl = p
                }
                com.photo = photoUrl as AnyObject?
                com.id = commentId as AnyObject?
                com.commenter = uid as AnyObject?
                let timea = Date(timeIntervalSinceReferenceDate: NSDate.timeIntervalSinceReferenceDate)
                let time = Double(timea.timeIntervalSinceReferenceDate)
                com.time = time as AnyObject?
                comments.append(com)
                let IndexPathOfLastRow = NSIndexPath(row: self.comments.count-1, section: 0)
                DispatchQueue.main.async {
                    self.commentTableView.insertRows(at: [IndexPathOfLastRow as IndexPath], with: UITableViewRowAnimation.left)
                }
                values = ["comment":comment , "commenter": NSString(string: uid), "id": NSString(string: commentId), "name": NSString(string: name), "photo": photoUrl as AnyObject, "time": time]
                commentReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                    //there was an error
                    if err != nil{
                        print("failed in the first one unfortunately")
                        print(err.debugDescription)
                        return
                    }
                    //success
                    print("saved comment successfully go team")
                })
                values = [commentId: commentId as AnyObject]
                pinReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                    //there was an error
                    if err != nil{
                        print(err.debugDescription)
                        return
                    }
                    //success
                    print("saved comment successfully go team")
                })
                userCommentView.text = ""
            }
            else{
                //failure
                return
            }
        }
    }
    
}
