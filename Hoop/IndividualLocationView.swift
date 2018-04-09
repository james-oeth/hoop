//
//  IndividualLocationView.swift
//  sherpaApp
//
//  Created by james oeth on 12/29/16.
//  Copyright © 2016 jamesOeth. All rights reserved.
//

import Foundation
import MapKit
import UIKit
import Firebase
class IndividualLocationViewController: UIViewController, UICollectionViewDelegateFlowLayout,MKMapViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UITextFieldDelegate , UIPickerViewDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource{
    //
    ///
    ////
    /////
    //////Setup All of the class variables
    /////
    ////
    ///
    //
    //make the profile image view
    var userProfile = UserProfile()
    //current image index for the slideshow
    var currentImageIndex = 0
    //collection view layout
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    //color for all of the text labels
    let buttonColor = UIColor(r: 59 , g: 89, b: 152)
    //setup the scroll view so the view can show more than what fits
    let scrollView = UIScrollView()
    //setup the content view for the scroll view
    let containerView = UIView()
    //string for the new title or description
    var newTitleDescriptionString: String = ""
    //pin to display get from previous view
    var pinToDisplay: PinAnnotation?
    //make my map view
    var mapView: MKMapView = MKMapView()
    //make the cell id
    let cellId = "cellId"
    //vars to hold the cell height and width
    var cellHeight = 0
    var cellWidth = 0
    //create collection view variable
    var collectionView: UICollectionView!
    //get the array of images
    var imageArr: [UIImageView] = []
    //make a view to hold expanded picture
    lazy var imageFullScreenView:UIImageView = {
        var v = UIImageView()
        v.contentMode = .scaleAspectFit
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.black
        v.alpha = 0
        let tap = UITapGestureRecognizer(target: self, action: #selector(IndividualLocationViewController.tappedFullScreenImage))
        v.addGestureRecognizer(tap)
        v.isUserInteractionEnabled = true
        return v
    }()
    //arry to hold all of the comments
    var comments: [Comment] = []
    
    //
    ///
    ////
    /////
    //////create all of the Views
    /////
    ////
    ///
    //
    var commentTableView: UITableView  =   UITableView()
    let mapLabel:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.boldSystemFont(ofSize: 16)
        l.textAlignment = .left
        l.text = "Map:"
        l.textColor = MyVariables.buttonColors
        l.backgroundColor = UIColor.clear
        return l
    }()
    
    let descriptionLabel:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.boldSystemFont(ofSize: 16)
        l.textAlignment = .left
        l.text = "Description:"
        l.textColor = MyVariables.buttonColors
        l.backgroundColor = UIColor.clear
        return l
    }()
    
    let photoLabel:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.boldSystemFont(ofSize: 16)
        l.textAlignment = .left
        l.text = "Photos:"
        l.textColor = MyVariables.buttonColors
        l.backgroundColor = UIColor.clear
        return l
    }()
    
    let commentLabel:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.boldSystemFont(ofSize: 16)
        l.textAlignment = .left
        l.text = "Comments:"
        l.textColor = MyVariables.buttonColors
        l.backgroundColor = UIColor.clear
        return l
    }()
    
    lazy var addCommentButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.clear
        button.setTitle("Comment", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(MyVariables.buttonColors, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 3
        button.layer.borderColor = MyVariables.buttonColors.cgColor
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(addCommentButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    //make back view
    let blackView:UIView = UIView()
    
    var descriptionText: UITextView = {
        var textView = UITextView()
        textView.layer.cornerRadius = 5
        textView.layer.borderWidth = 3
        textView.layer.borderColor = MyVariables.buttonColors.cgColor
        textView.layer.masksToBounds = false
        textView.font = UIFont.boldSystemFont(ofSize: 14)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.allowsEditingTextAttributes = false
        return textView
    }()
    
    var imageHolderView: UIImageView = {
        var image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 5
        image.layer.masksToBounds = true
        image.image = UIImage(named: "puppies")
        return image
    }()
    
    let addToOptionsView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        v.layer.cornerRadius = 5
        v.layer.masksToBounds = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    lazy var addToPlaylistButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = MyVariables.mainColor
        button.setTitle("Add To Playlist", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(addToPlaylistButtonTapped), for: .touchUpInside)
        return button
    }()
    lazy var addPictureButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = MyVariables.mainColor
        button.setTitle("Add A Photo", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(addPictureButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var takePictureButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = MyVariables.mainColor
        button.setTitle("Take A Photo", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(takePictureButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var changeTitleButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = MyVariables.mainColor
        button.setTitle("Change Title", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(changeTitleButtonTapped), for: .touchUpInside)
        return button
    }()
    lazy var changeDescriptionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = MyVariables.mainColor
        button.setTitle("Change Description", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(changeDescriptionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var openInMapsButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = MyVariables.mainColor
        button.setTitle("Open In Maps", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(openInMapsButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var pickedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "puppies")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let changeDescriptionTitleView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        v.layer.cornerRadius = 5
        v.layer.masksToBounds = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let changeDescriptionTitleLabel:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.boldSystemFont(ofSize: 16)
        l.adjustsFontSizeToFitWidth = true
        l.textAlignment = .center
        l.backgroundColor = UIColor.white
        return l
    }()
    
    var changeDescriptionTitleTextField :UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor.white
        tf.layer.borderColor = MyVariables.mainColor.cgColor
        tf.layer.borderWidth = 2
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.layer.cornerRadius = 5
        tf.layer.masksToBounds = true
        return tf
    }()
    
    lazy var saveNewTitleOrDescriptionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.white
        button.setTitle("Save", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(MyVariables.mainColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 2
        button.layer.borderColor = MyVariables.mainColor.cgColor
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(saveNewTitleOrDescriptionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var clearNewTitleOrDescriptionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.white
        button.setTitle("Clear", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(MyVariables.secondaryColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 2
        button.layer.borderColor = MyVariables.secondaryColor.cgColor
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(clearNewTitleOrDescriptionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.setAnimationsEnabled(true)
    }
    
    override func viewDidLayoutSubviews() {
        self.scrollView.contentSize = CGSize(width: self.containerView.frame.width, height: (self.containerView.frame.height*1.5))
    }
    
    //view did load load all of the views that should be visible at runtime
    override func viewDidLoad() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.downloadTheImages()
        }
        mapView.isScrollEnabled = false
        createTheComments()
        self.scrollView.isScrollEnabled = true
        self.scrollView.isUserInteractionEnabled = true
        self.scrollView.delegate = self
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(scrollView)
        scrollView.backgroundColor = MyVariables.backgroundColor
        self.scrollView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true
        self.scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.scrollView.heightAnchor.constraint(equalToConstant: self.view.frame.height*1.5).isActive = true
        self.containerView.backgroundColor = MyVariables.backgroundColor
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.addSubview(self.containerView)
        self.containerView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
        //self.containerView.heightAnchor.constraintEqualToAnchor(self.scrollView.heightAnchor).active = true
        self.containerView.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true
        self.containerView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor).isActive = true
        self.containerView.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor).isActive = true
        self.containerView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor).isActive = true
        self.containerView.heightAnchor.constraint(equalToConstant: self.view.frame.height * 1.5).isActive = true
        
        navigationItem.title = pinToDisplay?.title
        self.containerView.addSubview(mapLabel)
        setupMapLabel()
        self.containerView.addSubview(mapView)
        setupMapView()
        self.containerView.addSubview(descriptionLabel)
        setupDescriptionLabel()
        self.containerView.addSubview(descriptionText)
        setupDescriptionTextView()
        self.containerView.addSubview(photoLabel)
        setupPhotoLabel()
        changeDescriptionTitleTextField.delegate = self
        //setup the collection view
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        cellWidth = Int(self.view.frame.width)/2 - 30
        cellHeight = Int(self.view.frame.height)/3-10
        print(cellHeight)
        print(cellWidth)
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: CGRect(x:0, y:0, width: 0, height:0), collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.layer.cornerRadius = 5
        collectionView.layer.borderColor = MyVariables.buttonColors.cgColor
        collectionView.layer.borderWidth = 3
        collectionView.layer.masksToBounds = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = UIColor.white
        self.containerView.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: photoLabel.bottomAnchor, constant: 2).isActive = true
        collectionView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 10).isActive = true
        collectionView.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -10).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: self.view.frame.height/3).isActive = true
        //continue adding shit to the view
        self.containerView.addSubview(commentLabel)
        setupCommentLabel()
        
        
        //table view is
        commentTableView.delegate      =   self
        commentTableView.dataSource    =   self
        commentTableView.layer.cornerRadius = 5
        commentTableView.layer.masksToBounds = true
        commentTableView.allowsSelection = false
        commentTableView.separatorStyle = .none
        commentTableView.layer.borderColor = MyVariables.buttonColors.cgColor
        commentTableView.layer.borderWidth = 3
        commentTableView.translatesAutoresizingMaskIntoConstraints = false
        commentTableView.register(CommentCell.self, forCellReuseIdentifier: "cell")
        self.containerView.addSubview(commentTableView)
        commentTableView.topAnchor.constraint(equalTo: commentLabel.bottomAnchor).isActive = true
        commentTableView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10).isActive = true
        commentTableView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10).isActive = true
        commentTableView.heightAnchor.constraint(equalToConstant: 230).isActive = true
        //commentTableView.bottomAnchor.constraintEqualToAnchor(containerView.bottomAnchor).active = true
        //now add the add comment button
        self.containerView.addSubview(addCommentButton)
        setupAddCommentButton()
        
        //make the bar button item
        addPlusButton()
        
    }
    
    func addPlusButton(){
        if let uid = FIRAuth.auth()?.currentUser?.uid{
            if uid == pinToDisplay?.owner{
                let plusButton = UIButton()
                plusButton.setImage(UIImage(named: "zoomWhite"), for: .normal)
                plusButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                plusButton.addTarget(self, action: #selector(IndividualLocationViewController.addButtonTapped), for: .touchUpInside)
                let rightBarButton = UIBarButtonItem()
                //.... Set Right/Left Bar Button item
                rightBarButton.customView = plusButton
                self.navigationItem.rightBarButtonItem = rightBarButton
                navigationController?.navigationBar.tintColor = UIColor.white
                navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
            }
        }
    }
    
    
    //download the images using image caching
    func downloadTheImages(){
        if let urlArr = pinToDisplay?.URLArray{
            for urls in urlArr{
                let imageView: UIImageView = {
                    let image = UIImageView()
                    image.layer.cornerRadius = 5
                    image.layer.masksToBounds = true
                    image.translatesAutoresizingMaskIntoConstraints = false
                    image.contentMode = .scaleAspectFill
                    return image
                }()
                imageView.loadImageUsingCacheWithUrlString(urls)
                imageArr.append(imageView)
            }
        }
    }
    
    //
    ///
    ////
    /////
    //////All of the button tapped methods
    /////
    ////
    ///
    //
    
    func addCommentButtonTapped(){
        print("add button tapped baby")
        let commentView = commentViewController()
        commentView.userProfile = userProfile
        commentView.pinToDisplay = pinToDisplay
        commentView.comments = comments
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(commentView, animated: true)
        }
    }
    
    func addButtonTapped(){
        if let window = UIApplication.shared.keyWindow {
            
            blackView.backgroundColor = UIColor.black
            blackView.alpha = 0.0
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            window.addSubview(blackView)
            
            window.addSubview(addToOptionsView)
            setupAddToOptionsView()
            addToOptionsView.addSubview(addToPlaylistButton)
            setupAddToPlaylistButton()
            addToOptionsView.addSubview(addPictureButton)
            setupAddPictureButton()
            addToOptionsView.addSubview(takePictureButton)
            setupTakePictureButton()
            addToOptionsView.addSubview(changeTitleButton)
            setupChangeTitleButton()
            addToOptionsView.addSubview(changeDescriptionButton)
            setupChanceDescriptionButton()
            addToOptionsView.addSubview(openInMapsButton)
            setupOpenInMapsButton()
            
            
            blackView.frame = window.frame
            UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 0.7
                self.addToOptionsView.alpha = 1.0
            }) { (completed: Bool) in
                
            }
        }
    }
    
    func takePictureButtonTapped(){
        handleDismiss()
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        DispatchQueue.main.async {
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    func addToPlaylistButtonTapped(){
        
    }
    
    func addPictureButtonTapped(){
        handleDismiss()
        let picker = UIImagePickerController()
        picker.delegate = self
        DispatchQueue.main.async {
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    func changeTitleButtonTapped(){
        handleDismissNoAmimation()
        if let window = UIApplication.shared.keyWindow {
            
            blackView.backgroundColor = UIColor.black
            blackView.alpha = 0.0
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            window.addSubview(blackView)
            window.addSubview(changeDescriptionTitleView)
            setupChangeDescriptionTitleView()
            changeDescriptionTitleView.addSubview(changeDescriptionTitleLabel)
            setupChangeDesctiptionTitleLabel()
            changeDescriptionTitleLabel.text = "New Title"
            changeDescriptionTitleLabel.textColor = MyVariables.mainColor
            changeDescriptionTitleView.addSubview(changeDescriptionTitleTextField)
            changeDescriptionTitleTextField.placeholder = pinToDisplay?.title
            setupChangeDescriptionTitleTextField()
            changeDescriptionTitleTextField.becomeFirstResponder()
            changeDescriptionTitleView.addSubview(saveNewTitleOrDescriptionButton)
            setupSaveNewTitleOrDescriptionButton()
            changeDescriptionTitleView.addSubview(clearNewTitleOrDescriptionButton)
            setupClearNewTitleOrDescriptionButton()
            
            
            
            blackView.frame = window.frame
            UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 0.7
                self.changeDescriptionTitleView.alpha = 1.0
            }) { (completed: Bool) in
                window.bringSubview(toFront: self.changeDescriptionTitleView)
            }
        }
    }
    func changeDescriptionButtonTapped(){
        handleDismissNoAmimation()
        if let window = UIApplication.shared.keyWindow {
            
            blackView.backgroundColor = UIColor.black
            blackView.alpha = 0.0
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            window.addSubview(blackView)
            
            window.addSubview(changeDescriptionTitleView)
            setupChangeDescriptionTitleView()
            changeDescriptionTitleView.addSubview(changeDescriptionTitleLabel)
            setupChangeDesctiptionTitleLabel()
            changeDescriptionTitleLabel.text = "New Description"
            changeDescriptionTitleView.addSubview(changeDescriptionTitleTextField)
            changeDescriptionTitleTextField.placeholder = descriptionText.text
            setupChangeDescriptionTitleTextField()
            changeDescriptionTitleTextField.becomeFirstResponder()
            changeDescriptionTitleView.addSubview(saveNewTitleOrDescriptionButton)
            setupSaveNewTitleOrDescriptionButton()
            changeDescriptionTitleView.addSubview(clearNewTitleOrDescriptionButton)
            setupClearNewTitleOrDescriptionButton()
            
            blackView.frame = window.frame
            UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 0.7
                self.changeDescriptionTitleView.alpha = 1.0
            }) { (completed: Bool) in
                window.bringSubview(toFront: self.changeDescriptionTitleView)
            }
        }
        
    }
    func openInMapsButtonTapped(){
        openInGoogleMaps()
        handleDismiss()
    }
    
    func saveNewTitleOrDescriptionButtonTapped(){
        if changeDescriptionTitleLabel.text == "New Title"{
            if let str = changeDescriptionTitleTextField.text{
                handleDismiss()
                newTitleDescriptionString = str
                changeDescriptionTitleTextField.resignFirstResponder()
                navigationItem.title = str
                let ref = FIRDatabase.database().reference().child("AllUserLocations").child(pinToDisplay!.id!)
                ref.updateChildValues(["title" : str])
                pinToDisplay?.title = str
            }
        }
        else {
            if let str = changeDescriptionTitleTextField.text{
                handleDismiss()
                newTitleDescriptionString = str
                changeDescriptionTitleTextField.resignFirstResponder()
                descriptionText.text = str
                let ref = FIRDatabase.database().reference().child("AllUserLocations").child(pinToDisplay!.id!)
                ref.updateChildValues(["desc" : str])
                pinToDisplay?.subtitle = str
            }
        }
    }
    
    func clearNewTitleOrDescriptionButtonTapped(){
        changeDescriptionTitleTextField.resignFirstResponder()
        handleDismiss()
    }
    
    //
    ///
    ////
    /////
    //////image picker for adding images
    /////
    ////
    ///
    //
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        
        if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            saveNewImage(selectedImage)
            let imageView: UIImageView = {
                let image = UIImageView()
                image.layer.cornerRadius = 5
                image.layer.masksToBounds = true
                image.translatesAutoresizingMaskIntoConstraints = false
                image.contentMode = .scaleAspectFill
                image.image = selectedImage
                return image
            }()
            imageArr.append(imageView)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    func handleDismiss(){
        print("handling the dismiss")
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 0
            self.addToOptionsView.alpha = 0
            self.changeDescriptionTitleView.alpha = 0
        }) { (completed: Bool) in
            self.blackView.removeFromSuperview()
            self.addToOptionsView.removeFromSuperview()
            self.changeDescriptionTitleView.removeFromSuperview()
        }
    }
    
    func handleDismissNoAmimation(){
        self.blackView.alpha = 0
        self.addToOptionsView.alpha = 0
        self.blackView.removeFromSuperview()
        self.addToOptionsView.removeFromSuperview()
    }
    
    
    
    
    //
    ///
    ////
    /////
    //////all views constraints
    /////
    ////
    ///
    //
    
    
    func setupClearNewTitleOrDescriptionButton(){
        clearNewTitleOrDescriptionButton.leftAnchor.constraint(equalTo: changeDescriptionTitleView.centerXAnchor, constant: 10).isActive = true
        clearNewTitleOrDescriptionButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        clearNewTitleOrDescriptionButton.rightAnchor.constraint(equalTo: changeDescriptionTitleView.rightAnchor, constant: -10).isActive = true
        clearNewTitleOrDescriptionButton.bottomAnchor.constraint(equalTo: changeDescriptionTitleView.bottomAnchor, constant: -20).isActive = true
    }
    
    func setupSaveNewTitleOrDescriptionButton(){
        saveNewTitleOrDescriptionButton.rightAnchor.constraint(equalTo: changeDescriptionTitleView.centerXAnchor, constant: -10).isActive = true
        saveNewTitleOrDescriptionButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        saveNewTitleOrDescriptionButton.leftAnchor.constraint(equalTo: changeDescriptionTitleView.leftAnchor, constant: 10).isActive = true
        saveNewTitleOrDescriptionButton.bottomAnchor.constraint(equalTo: changeDescriptionTitleView.bottomAnchor, constant: -20).isActive = true
    }
    
    func setupAddCommentButton(){
        addCommentButton.topAnchor.constraint(equalTo: commentTableView.bottomAnchor, constant: 5).isActive = true
        addCommentButton.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10).isActive = true
        addCommentButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        addCommentButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func setupChangeDescriptionTitleTextField(){
        changeDescriptionTitleTextField.topAnchor.constraint(equalTo: changeDescriptionTitleLabel.bottomAnchor, constant: 10).isActive = true
        changeDescriptionTitleTextField.widthAnchor.constraint(equalToConstant: view.frame.width-20).isActive = true
        changeDescriptionTitleTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        changeDescriptionTitleTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func setupChangeDesctiptionTitleLabel(){
        changeDescriptionTitleLabel.topAnchor.constraint(equalTo: changeDescriptionTitleView.topAnchor, constant: 10).isActive = true
        changeDescriptionTitleLabel.centerXAnchor.constraint(equalTo: changeDescriptionTitleView.centerXAnchor).isActive = true
        changeDescriptionTitleLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        changeDescriptionTitleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func setupCommentTableView(){
        commentTableView.topAnchor.constraint(equalTo: commentLabel.bottomAnchor).isActive = true
        commentTableView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10).isActive = true
        commentTableView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10).isActive = true
        commentTableView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    func setupAddToOptionsView(){
        addToOptionsView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        addToOptionsView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        addToOptionsView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        addToOptionsView.heightAnchor.constraint(equalToConstant: 280).isActive = true
    }
    
    func setupPhotoLabel(){
        photoLabel.topAnchor.constraint(equalTo: descriptionText.bottomAnchor).isActive = true
        photoLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        photoLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10).isActive = true
        photoLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func setupCommentLabel(){
        commentLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor).isActive = true
        commentLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10).isActive = true
        commentLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        commentLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func setupAddToPlaylistButton(){
        addToPlaylistButton.topAnchor.constraint(equalTo: addToOptionsView.topAnchor, constant: 5).isActive = true
        addToPlaylistButton.leftAnchor.constraint(equalTo: addToOptionsView.leftAnchor, constant: 5).isActive = true
        addToPlaylistButton.rightAnchor.constraint(equalTo: addToOptionsView.rightAnchor, constant: -5).isActive = true
        addToPlaylistButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupAddPictureButton(){
        addPictureButton.topAnchor.constraint(equalTo: addToPlaylistButton.bottomAnchor, constant: 5).isActive = true
        addPictureButton.leftAnchor.constraint(equalTo: addToOptionsView.leftAnchor, constant: 5).isActive = true
        addPictureButton.rightAnchor.constraint(equalTo: addToOptionsView.centerXAnchor, constant: -2.5).isActive = true
        addPictureButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupTakePictureButton(){
        takePictureButton.topAnchor.constraint(equalTo: addToPlaylistButton.bottomAnchor, constant: 5).isActive = true
        takePictureButton.leftAnchor.constraint(equalTo: addToOptionsView.centerXAnchor, constant: 2.5).isActive = true
        takePictureButton.rightAnchor.constraint(equalTo: addToOptionsView.rightAnchor, constant: -5).isActive = true
        takePictureButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupChangeTitleButton(){
        changeTitleButton.topAnchor.constraint(equalTo: addPictureButton.bottomAnchor, constant: 5).isActive = true
        changeTitleButton.leftAnchor.constraint(equalTo: addToOptionsView.leftAnchor, constant: 5).isActive = true
        changeTitleButton.rightAnchor.constraint(equalTo: addToOptionsView.rightAnchor, constant: -5).isActive = true
        changeTitleButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupChanceDescriptionButton(){
        changeDescriptionButton.topAnchor.constraint(equalTo: changeTitleButton.bottomAnchor, constant: 5).isActive = true
        changeDescriptionButton.leftAnchor.constraint(equalTo: addToOptionsView.leftAnchor, constant: 5).isActive = true
        changeDescriptionButton.rightAnchor.constraint(equalTo: addToOptionsView.rightAnchor, constant: -5).isActive = true
        changeDescriptionButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    func setupOpenInMapsButton(){
        openInMapsButton.topAnchor.constraint(equalTo: changeDescriptionButton.bottomAnchor, constant: 5).isActive = true
        openInMapsButton.leftAnchor.constraint(equalTo: addToOptionsView.leftAnchor, constant: 5).isActive = true
        openInMapsButton.rightAnchor.constraint(equalTo: addToOptionsView.rightAnchor, constant: -5).isActive = true
        openInMapsButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupImageFullScreenView(){
        imageFullScreenView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        imageFullScreenView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        imageFullScreenView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        imageFullScreenView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    func setupChangeDescriptionTitleView(){
        changeDescriptionTitleView.alpha = 0
        changeDescriptionTitleView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        changeDescriptionTitleView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80).isActive = true
        changeDescriptionTitleView.widthAnchor.constraint(equalToConstant: view.frame.width-10).isActive = true
        changeDescriptionTitleView.heightAnchor.constraint(equalToConstant: view.frame.height/3).isActive = true
    }
    
    func setupMapLabel(){
        mapLabel.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        mapLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10).isActive = true
        mapLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        mapLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    
    func setupMapView(){
        print("setting up the map view ... ")
        // Do any additional setup after loading the view, typically from a nib.
        mapView.mapType = .standard
        mapView.layer.cornerRadius = 5
        mapView.layer.borderWidth = 3
        mapView.layer.borderColor = MyVariables.buttonColors.cgColor
        mapView.layer.masksToBounds = true
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: mapLabel.bottomAnchor, constant: 2).isActive = true
        mapView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10).isActive = true
        mapView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10).isActive = true
        mapView.heightAnchor.constraint(equalToConstant: view.frame.height/4).isActive = true
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = false
        let annotation = MKPointAnnotation()
        annotation.coordinate = pinToDisplay!.coordinate
        annotation.title = pinToDisplay?.title
        annotation.subtitle = pinToDisplay?.subtitle
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegionMake(annotation.coordinate, span)
        mapView.setRegion(region, animated: true)
        
    }
    
    func setupDescriptionLabel(){
        descriptionLabel.topAnchor.constraint(equalTo: mapView.bottomAnchor).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        descriptionLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func setupDescriptionTextView(){
        descriptionText.text = pinToDisplay?.subtitle
        descriptionText.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 2).isActive = true
        descriptionText.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10).isActive = true
        descriptionText.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10).isActive = true
        //descriptionText.heightAnchor.constraintEqualToConstant(50).active = true
        descriptionText.isScrollEnabled = false
        
    }
    
    //
    ///
    ////
    /////
    //////All of the mapview methods
    /////
    ////
    ///
    //
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is PinAnnotation {
            let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myPin")
            pinAnnotationView.pinTintColor = UIColor.cyan
            pinAnnotationView.isDraggable = true
            pinAnnotationView.canShowCallout = true
            pinAnnotationView.animatesDrop = true
            
            let deleteButton = UIButton(type: .custom)
            deleteButton.frame.size.width = 44
            deleteButton.frame.size.height = 44
            deleteButton.backgroundColor = UIColor.white
            deleteButton.setImage(UIImage(named: "help"), for: .normal)
            pinAnnotationView.leftCalloutAccessoryView = deleteButton
            return pinAnnotationView
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotation = view.annotation as? PinAnnotation {
            print("tapped on the open button ...")
            let oneLocation = IndividualLocationViewController()
            oneLocation.pinToDisplay = annotation
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(oneLocation, animated: true)
            }
        }
    }
    
    //
    ///
    ////
    /////
    //////All of the collections view methods
    /////
    ////
    ///
    //
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("the count of image arr ... \(imageArr.count)")
        if imageArr.count != 0{
            return imageArr.count
        }
        else{
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath)
        if imageArr.count != 0{
            cell.backgroundColor = UIColor.gray
            //cell.backgroundView = imageArr[indexPath.item]
            let imageView = imageArr[indexPath.item]
            imageView.translatesAutoresizingMaskIntoConstraints = false
            cell.addSubview(imageView)
            imageView.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
            imageView.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
            imageView.leftAnchor.constraint(equalTo: cell.leftAnchor).isActive = true
            imageView.rightAnchor.constraint(equalTo: cell.rightAnchor).isActive = true
            //cell.layer.cornerRadius = 5
            //cell.layer.masksToBounds = false
            return cell
            
        }
        else{
            let imageView: UIImageView = {
                let image = UIImageView()
                image.layer.cornerRadius = 5
                image.image = UIImage(named: "puppies")
                image.layer.masksToBounds = true
                image.translatesAutoresizingMaskIntoConstraints = false
                image.contentMode = .scaleAspectFit
                return image
            }()
            cell.addSubview(imageView)
            imageView.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
            imageView.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
            imageView.leftAnchor.constraint(equalTo: cell.leftAnchor).isActive = true
            imageView.rightAnchor.constraint(equalTo: cell.rightAnchor).isActive = true
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentImageIndex = indexPath.item
        if imageArr.count != 0 {
            let pickedCell = collectionView.cellForItem(at: indexPath as IndexPath)
            let pickedImage = imageArr[indexPath.item]
            //if we actually picked an image
            if let actualImage = pickedImage.image{
                self.view.addSubview(imageFullScreenView)
                setupImageFullScreenView()
                self.navigationController?.isNavigationBarHidden = true
                imageFullScreenView.image = actualImage
                imageFullScreenView.fadeIn()
            }
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(IndividualLocationViewController.respondToSwipeGesture(_:)))
            swipeRight.direction = UISwipeGestureRecognizerDirection.right
            self.imageFullScreenView.addGestureRecognizer(swipeRight)
            
            let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(IndividualLocationViewController.respondToSwipeGesture(_:)))
            swipeLeft.direction = UISwipeGestureRecognizerDirection.left
            self.imageFullScreenView.addGestureRecognizer(swipeLeft)
            
            let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(IndividualLocationViewController.respondToSwipeGesture(_:)))
            swipeDown.direction = UISwipeGestureRecognizerDirection.down
            self.imageFullScreenView.addGestureRecognizer(swipeDown)
        }
        /*
         let pickedCell = collectionView.cellForItemAtIndexPath(indexPath)
         let allConstraints = collectionView.constraints
         collectionView.removeConstraints(allConstraints)
         self.navigationController?.navigationBarHidden = true
         let height = self.view.frame.height
         let width = self.view.frame.width
         print(height)
         print(width)
         layout.itemSize = CGSize(width: 667, height: 375)
         collectionView.topAnchor.constraintEqualToAnchor(view.topAnchor).active = true
         collectionView.leftAnchor.constraintEqualToAnchor(view.leftAnchor).active = true
         collectionView.rightAnchor.constraintEqualToAnchor(view.rightAnchor).active = true
         collectionView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true
         collectionView.reloadData()
         */
    }
    
    func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
                if currentImageIndex != 0{
                    UIView.transition(with: imageFullScreenView, duration: 0.5, options: UIViewAnimationOptions.transitionFlipFromLeft , animations: {
                        //...animations
                        self.imageFullScreenView.image = self.imageArr[self.currentImageIndex-1].image
                    }, completion: {_ in
                        //....transition completion
                        self.currentImageIndex -= 1
                    })
                }
            case UISwipeGestureRecognizerDirection.down:
                print("Swiped down")
                tappedFullScreenImage()
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
                if currentImageIndex+1 < imageArr.count{
                    UIView.transition(with: imageFullScreenView, duration: 0.5, options: UIViewAnimationOptions.transitionFlipFromRight , animations: {
                        //...animations
                        self.imageFullScreenView.image = self.imageArr[self.currentImageIndex+1].image
                    }, completion: {_ in
                        //....transition completion
                        self.currentImageIndex += 1
                    })
                }
            case UISwipeGestureRecognizerDirection.up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    
    func tappedFullScreenImage(){
        UIView.animate(withDuration: TimeInterval(0.5), animations: {
            self.imageFullScreenView.alpha = 0.0
            self.navigationController?.isNavigationBarHidden = false
        }) { (true) in
            self.imageFullScreenView.removeFromSuperview()
        }
    }
    
    
    func saveNewImage(_ image: UIImage){
        print("in save new image")
        print(pinToDisplay?.id)
        let ref = FIRDatabase.database().reference().child("AllUserLocations").child(pinToDisplay!.id!).child("images").childByAutoId()
        print("past reference")
        
        let imageName = UUID().uuidString
        let storageRef = FIRStorage.storage().reference().child("location_images").child("\(imageName).png")
        if let uploadData = UIImageJPEGRepresentation(image, 0.3) {
            print("in upload data reference")
            
            storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print(error.debugDescription)
                    return
                }
                if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                    let values = ["image": profileImageUrl]
                    ref.updateChildValues(values)
                }
            })
        }
        
    }
    
    
    func openInGoogleMaps(){
        let dict = [String:AnyObject]()
        let placeMark = MKPlacemark(coordinate: pinToDisplay!.coordinate, addressDictionary: dict)
        let mapItem = MKMapItem(placemark: placeMark)
        
        mapItem.name = "The way I want to go"
        
        //You could also choose: MKLaunchOptionsDirectionsModeWalking
        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
        
        mapItem.openInMaps(launchOptions: launchOptions)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("TextField should return method called")
        if let str = changeDescriptionTitleTextField.text{
            newTitleDescriptionString = str
        }
        changeDescriptionTitleTextField.resignFirstResponder();
        return true;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
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
    
    /*
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:CommentCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as! CommentCell
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
         
         let commentLabel:UILabel = {
         let l = UILabel()
         l.translatesAutoresizingMaskIntoConstraints = false
         l.font = UIFont.boldSystemFontOfSize(12)
         l.textAlignment = .Left
         l.textColor = UIColor.blackColor()
         l.backgroundColor = UIColor.clearColor()
         l.lineBreakMode = .ByWordWrapping
         l.numberOfLines = 0;
         return l
         }()
         /*
         if let name = comments[indexPath.row].name as? String{
         commentLabel.text = name
         let longString = "Lorem ipsum dolor. VeryLongWord ipsum foobar"
         let longestWord = "VeryLongWord"
         let longestWordRange = (longString as NSString).rangeOfString(longestWord)
         let attributedString = NSMutableAttributedString(string: longString, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(20)])
         attributedString.setAttributes([NSFontAttributeName : UIFont.boldSystemFontOfSize(20), NSForegroundColorAttributeName : UIColor.redColor()], range: longestWordRange)
         label.attributedText = attributedString
         }
         */
         guard let name = comments[indexPath.row].name as? String else { return cell }
         guard let comment = comments[indexPath.row].comment as? String else {return cell }
         let combo = name + " " + comment
         let nameRange = (combo as NSString).rangeOfString(name)
         let attributedString = NSMutableAttributedString(string: combo, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(20)])
         attributedString.setAttributes([NSFontAttributeName : UIFont.boldSystemFontOfSize(20), NSForegroundColorAttributeName : MyVariables.mainColor], range: nameRange)
         commentLabel.attributedText = attributedString
         
         cellView.addSubview(commentLabel)
         commentLabel.leftAnchor.constraintEqualToAnchor(cellView.leftAnchor, constant: 5).active = true
         commentLabel.topAnchor.constraintEqualToAnchor(cellView.topAnchor, constant: 5).active = true
         commentLabel.rightAnchor.constraintEqualToAnchor(cellView.rightAnchor, constant: -5).active = true
         commentLabel.bottomAnchor.constraintEqualToAnchor(cellView.bottomAnchor, constant: -5).active = true
         /*
         let commentLabel:UILabel = {
         let l = UILabel()
         l.translatesAutoresizingMaskIntoConstraints = false
         l.font = UIFont.boldSystemFontOfSize(16)
         l.textAlignment = .Left
         l.textColor = UIColor.blackColor()
         l.backgroundColor = UIColor.clearColor()
         return l
         }()
         if let com = comments[indexPath.row].comment as? String{
         commentLabel.text = com
         }
         cellView.addSubview(commentLabel)
         commentLabel.leftAnchor.constraintEqualToAnchor(cellView.leftAnchor, constant: 120).active = true
         commentLabel.rightAnchor.constraintEqualToAnchor(cellView.rightAnchor).active = true
         commentLabel.topAnchor.constraintEqualToAnchor(cellView.topAnchor).active = true
         commentLabel.bottomAnchor.constraintEqualToAnchor(cellView.bottomAnchor).active = true
         */
         */
        return cell
    }
    */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CommentCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as! CommentCell
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
         
         let commentLabel:UILabel = {
         let l = UILabel()
         l.translatesAutoresizingMaskIntoConstraints = false
         l.font = UIFont.boldSystemFontOfSize(12)
         l.textAlignment = .Left
         l.textColor = UIColor.blackColor()
         l.backgroundColor = UIColor.clearColor()
         l.lineBreakMode = .ByWordWrapping
         l.numberOfLines = 0;
         return l
         }()
         /*
         if let name = comments[indexPath.row].name as? String{
         commentLabel.text = name
         let longString = "Lorem ipsum dolor. VeryLongWord ipsum foobar"
         let longestWord = "VeryLongWord"
         let longestWordRange = (longString as NSString).rangeOfString(longestWord)
         let attributedString = NSMutableAttributedString(string: longString, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(20)])
         attributedString.setAttributes([NSFontAttributeName : UIFont.boldSystemFontOfSize(20), NSForegroundColorAttributeName : UIColor.redColor()], range: longestWordRange)
         label.attributedText = attributedString
         }
         */
         guard let name = comments[indexPath.row].name as? String else { return cell }
         guard let comment = comments[indexPath.row].comment as? String else {return cell }
         let combo = name + " " + comment
         let nameRange = (combo as NSString).rangeOfString(name)
         let attributedString = NSMutableAttributedString(string: combo, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(20)])
         attributedString.setAttributes([NSFontAttributeName : UIFont.boldSystemFontOfSize(20), NSForegroundColorAttributeName : MyVariables.mainColor], range: nameRange)
         commentLabel.attributedText = attributedString
         
         cellView.addSubview(commentLabel)
         commentLabel.leftAnchor.constraintEqualToAnchor(cellView.leftAnchor, constant: 5).active = true
         commentLabel.topAnchor.constraintEqualToAnchor(cellView.topAnchor, constant: 5).active = true
         commentLabel.rightAnchor.constraintEqualToAnchor(cellView.rightAnchor, constant: -5).active = true
         commentLabel.bottomAnchor.constraintEqualToAnchor(cellView.bottomAnchor, constant: -5).active = true
         /*
         let commentLabel:UILabel = {
         let l = UILabel()
         l.translatesAutoresizingMaskIntoConstraints = false
         l.font = UIFont.boldSystemFontOfSize(16)
         l.textAlignment = .Left
         l.textColor = UIColor.blackColor()
         l.backgroundColor = UIColor.clearColor()
         return l
         }()
         if let com = comments[indexPath.row].comment as? String{
         commentLabel.text = com
         }
         cellView.addSubview(commentLabel)
         commentLabel.leftAnchor.constraintEqualToAnchor(cellView.leftAnchor, constant: 120).active = true
         commentLabel.rightAnchor.constraintEqualToAnchor(cellView.rightAnchor).active = true
         commentLabel.topAnchor.constraintEqualToAnchor(cellView.topAnchor).active = true
         commentLabel.bottomAnchor.constraintEqualToAnchor(cellView.bottomAnchor).active = true
         */
         */
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createTheComments(){
        guard let id = pinToDisplay?.id else{ return }
        let ref = FIRDatabase.database().reference().child("AllUserLocations").child(id).child("comments")
        ref.observe(.childAdded, with: { (snapshot) in
            let commentId = snapshot.key
            let commentRef = FIRDatabase.database().reference().child("comments").child(commentId)
            commentRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let com = Comment()
                    com.setValuesForKeys(dictionary)
                    self.comments.append(com)
                    
                    //this will crash because of background thread, so lets call this on dispatch_async main thread
                    DispatchQueue.main.async {
                        self.commentTableView.reloadData()
                    }
                }
            })
        }, withCancel: nil)
    }
    /*
     func createTheComments(){
     for comment in (pinToDisplay?.comments!)!{
     //make the comments
     let ref = FIRDatabase.database().referenceFromURL("https://drop-335ed.firebaseio.com/").child("comments").child(comment)
     ref.observeEventType(.Value, withBlock: { (snapshot) in
     if let dictionary = snapshot.value as? [String: AnyObject] {
     let com = Comment()
     com.setValuesForKeysWithDictionary(dictionary)
     self.comments.append(com)
     
     //this will crash because of background thread, so lets call this on dispatch_async main thread
     dispatch_async(dispatch_get_main_queue(), {
     self.commentTableView.reloadData()
     })
     }
     
     }, withCancelBlock: nil)
     
     }
     }
     
     /*
     func watchForAddedComments(){
     let ref = FIRDatabase.database().referenceFromURL("https://drop-335ed.firebaseio.com/").child((pinToDisplay?.id)!).child("comments")
     ref.observeEventType(.ChildAdded, withBlock: { (snapshot) in
     if let dictionary = snapshot.value as? [String: AnyObject] {
     let com = Comment()
     com.setValuesForKeysWithDictionary(dictionary)
     self.comments.append(com)
     
     //this will crash because of background thread, so lets call this on dispatch_async main thread
     dispatch_async(dispatch_get_main_queue(), {
     self.commentTableView.reloadData()
     })
     }
     
     }, withCancelBlock: nil)
     }
     
     
     func createTheComments(completionClosure: (coms :[Comment]) ->()){
     var coms: [Comment] = []
     for comment in (pinToDisplay?.comments!)!{
     //make the comments
     let ref = FIRDatabase.database().referenceFromURL("https://drop-335ed.firebaseio.com/").child("comments").child(comment)
     ref.observeEventType(.Value, withBlock: { (snapshot) in
     if let dictionary = snapshot.value as? [String: AnyObject] {
     let com = Comment()
     com.setValuesForKeysWithDictionary(dictionary)
     coms.append(com)
     }
     })
     }
     completionClosure(coms: coms)
     }
     */
     */
}
