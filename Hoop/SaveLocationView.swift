//
//  SaveLocationView.swift
//  sherpaApp
//
//  Created by james oeth on 12/28/16.
//  Copyright © 2016 jamesOeth. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import Firebase

class SaveLocationViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource ,UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UITextViewDelegate, UIScrollViewDelegate{
    var latitude:Double!
    var longitude:Double!
    var titleText: String!
    var descriptionText: String!
    //LIST TO HOLD ALL OF THE USERS LOCATIONS
    var listItems = [NSManagedObject]()
    //create collection view variable
    var collectionView: UICollectionView!
    //create the second collection view
    var playlistCollectionView: UICollectionView!
    //make the cell id
    let cellId = "cellId"
    //vars to hold the cell height and width
    var cellHeight = 0
    var cellWidth = 0
    //vars for the second collection view
    var cellHeight2 = 0
    var cellWidth2 = 0
    var pickedImage:UIImage!
    var pickedImages: [UIImage] = []
    var pickedCell: UICollectionViewCell?
    //playlist array
    let publicPlaylistArr: [String] = {
        var a = ["Add To Playlist:","Biking", "Cliff Jumping", "Climbing", "Dispersed Camping", "Gear Store", "Hiking", "Ice Climbing", "Resteraunts", "Site Camping", "Skiing", "Sunrise View", "Sunset View", "Trail Running"]
        return a
    }()
    var publicBoolArr:[Bool] = []
    var playlistArr = [String]()
    var boolArr = [Bool]()
    //make layout
    let layout2: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    //setup the scroll view so the view can show more than what fits
    let scrollView = UIScrollView()
    //setup the content view for the scroll view
    let containerView = UIView()
    
    let playlistLabel:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.boldSystemFont(ofSize: 16)
        l.textAlignment = .left
        l.text = "Add To Playlists:"
        l.textColor = MyVariables.buttonColors
        l.backgroundColor = UIColor.clear
        return l
    }()
    
    let titleLabel:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.boldSystemFont(ofSize: 16)
        l.textAlignment = .left
        l.text = "Give it a Title:"
        l.textColor = MyVariables.buttonColors
        l.backgroundColor = UIColor.clear
        return l
    }()
    
    let descriptionLabel:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.boldSystemFont(ofSize: 16)
        l.textAlignment = .left
        l.text = "Now a helpful description:"
        l.textColor = MyVariables.buttonColors
        l.backgroundColor = UIColor.clear
        return l
    }()
    
    let photoLabel:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.boldSystemFont(ofSize: 16)
        l.textAlignment = .left
        l.text = "Now add pictures:"
        l.textColor = MyVariables.buttonColors
        l.backgroundColor = UIColor.clear
        return l
    }()
    
    
    var buttonHolderView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 5
        v.layer.borderWidth = 3
        v.layer.borderColor = MyVariables.secondaryColor.cgColor
        v.layer.masksToBounds = true
        return v
        
    }()
    
    var buttonHolderViewLine: UIView = {
        let v = UIView()
        v.backgroundColor = MyVariables.mainColor
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.masksToBounds = true
        return v
        
    }()
    
    var pickedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "puppies")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var addImageButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = MyVariables.buttonColors
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Take Picture", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(addImageButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var privateButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = MyVariables.mainColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Private", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(privateButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var followersButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = MyVariables.buttonColors
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Followers", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(followersButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var publicButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = MyVariables.buttonColors
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Public", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(publicButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //text field for the title
    var titleTextField :UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor.white
        tf.placeholder = " Add Title"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.layer.masksToBounds = true
        return tf
    }()
    
    //view to put the title text field in
    var titleTextFieldHolderView: UIView = {
        let v = UIView()
        v.backgroundColor = MyVariables.backgroundColor
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 5
        v.layer.borderColor = MyVariables.secondaryColor.cgColor
        v.layer.borderWidth = 3
        v.layer.masksToBounds = true
        v.alpha = 1
        return v
        
    }()
    
    
    var descriptionTextField :UITextView = {
        let tf = UITextView()
        tf.backgroundColor = UIColor.white
        //tf.placeholder = "Add Description 8====D"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.layer.cornerRadius = 5
        tf.layer.borderWidth = 3
        tf.layer.borderColor = MyVariables.secondaryColor.cgColor
        tf.font = UIFont.boldSystemFont(ofSize: 16)
        tf.layer.masksToBounds = true
        tf.text = "Add Description"
        tf.textColor = UIColor.lightGray
        return tf
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = MyVariables.mainColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = MyVariables.mainColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLayoutSubviews() {
        self.scrollView.contentSize = CGSize(width: self.containerView.frame.width, height: (self.containerView.frame.height)*1.5)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ///scroll view stuffs
        self.scrollView.isScrollEnabled = true
        self.scrollView.isUserInteractionEnabled = true
        self.scrollView.delegate = self
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(scrollView)
        scrollView.backgroundColor = UIColor.gray
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
        self.containerView.heightAnchor.constraint(equalToConstant: self.view.frame.height * 2).isActive = true
        ///scroll view stuff above
        
        
        //setup bool array
        publicBoolArr = [Bool](repeating: false, count: publicPlaylistArr.count)
        boolArr = [Bool](repeating: false, count: playlistArr.count)
        playlistArr[0] = "Add To Playlist:"
        //setup other shit
        view.backgroundColor = MyVariables.backgroundColor
        // Do any additional setup after loading the view.
        //make the title for the nav bar
        self.title = "Save Location"
        //add the playlist label
        containerView.addSubview(playlistLabel)
        setupPlaylistLabel()
        //add the subviews
        containerView.addSubview(buttonHolderView)
        setupButtonHolderView()
        buttonHolderView.addSubview(privateButton)
        setupPrivateButton()
        buttonHolderView.addSubview(followersButton)
        setupFollowersButton()
        buttonHolderView.addSubview(publicButton)
        setupPublicButton()
        buttonHolderView.addSubview(buttonHolderViewLine)
        setupButtonHolderViewLine()
        //make a second collection view
        layout2.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 5)
        cellWidth2 = Int(self.view.frame.width)/2 - 30
        cellHeight2 = 50
        print(cellHeight2)
        print(cellWidth2)
        layout2.itemSize = CGSize(width: cellWidth2, height: cellHeight2)
        layout2.scrollDirection = .horizontal
        playlistCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout2)
        playlistCollectionView.dataSource = self
        playlistCollectionView.delegate = self
        playlistCollectionView.layer.cornerRadius = 5
        playlistCollectionView.layer.masksToBounds = true
        playlistCollectionView.translatesAutoresizingMaskIntoConstraints = false
        playlistCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "PlaylistCell")
        playlistCollectionView.backgroundColor = UIColor.white
        self.buttonHolderView.addSubview(playlistCollectionView)
        playlistCollectionView.bottomAnchor.constraint(equalTo: buttonHolderView.bottomAnchor, constant: -5).isActive = true
        playlistCollectionView?.leftAnchor.constraint(equalTo: buttonHolderView.leftAnchor, constant: 10).isActive = true
        playlistCollectionView?.rightAnchor.constraint(equalTo: buttonHolderView.rightAnchor, constant: -10).isActive = true
        playlistCollectionView?.heightAnchor.constraint(equalToConstant: 60).isActive = true
        //now do the title label
        containerView.addSubview(titleLabel)
        setupTitleLabel()
        containerView.addSubview(titleTextFieldHolderView)
        titleTextFieldHolderView.addSubview(titleTextField)
        titleTextField.delegate = self
        setupTitleTextField()
        //not add the descriptionlabel
        containerView.addSubview(descriptionLabel)
        setupDescriptionLabel()
        containerView.addSubview(descriptionTextField)
        descriptionTextField.delegate = self
        setupDescriptionTextField()
        
        //add the photo label
        containerView.addSubview(photoLabel)
        setupPhotoLabel()
        //collection view sheit
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        cellWidth = Int(self.view.frame.width)/2 - 30
        cellHeight = Int(self.view.frame.height)/3-20
        print(cellHeight)
        print(cellWidth)
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.layer.cornerRadius = 5
        collectionView.layer.masksToBounds = true
        collectionView.layer.borderWidth = 3
        collectionView.layer.borderColor = MyVariables.secondaryColor.cgColor
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = UIColor.white
        self.containerView.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: photoLabel.bottomAnchor, constant: 2).isActive = true
        collectionView?.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        collectionView?.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        collectionView?.heightAnchor.constraint(equalToConstant: self.view.frame.height/3).isActive = true
        //save image button
        containerView.addSubview(addImageButton)
        setupAddImageButton()
        containerView.addSubview(saveButton)
        setupSaveButton()
        containerView.addSubview(cancelButton)
        setupCancelButton()
        descriptionText = " "
        titleText = " "
        
    }
    
    func setupPlaylistLabel(){
        playlistLabel.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        playlistLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10).isActive = true
        playlistLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        playlistLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func privateButtonTapped(){
        print("private button tapped ...")
        resetButtonColor()
        privateButton.backgroundColor = MyVariables.mainColor
        DispatchQueue.main.async {
            self.playlistCollectionView.collectionViewLayout.prepare()
            self.playlistCollectionView.reloadData()
        }
    }
    
    func followersButtonTapped(){
        print("followers button tapped ...")
        resetButtonColor()
        followersButton.backgroundColor = MyVariables.mainColor
        DispatchQueue.main.async {
            self.playlistCollectionView.reloadData()
            self.playlistCollectionView.collectionViewLayout.invalidateLayout()
            self.playlistCollectionView.collectionViewLayout.prepare()
        }
        
    }
    
    func setupButtonHolderViewLine(){
        buttonHolderViewLine.topAnchor.constraint(equalTo: followersButton.bottomAnchor, constant: 5).isActive = true
        buttonHolderViewLine.leftAnchor.constraint(equalTo: buttonHolderView.leftAnchor, constant: 50).isActive = true
        buttonHolderViewLine.rightAnchor.constraint(equalTo: buttonHolderView.rightAnchor, constant: -50 ).isActive = true
        buttonHolderViewLine.heightAnchor.constraint(equalToConstant: 2).isActive = true
    }
    
    func publicButtonTapped(){
        print("public button tapped ...")
        resetButtonColor()
        publicButton.backgroundColor = MyVariables.mainColor
        DispatchQueue.main.async {
            self.playlistCollectionView.collectionViewLayout.prepare()
            self.playlistCollectionView.reloadData()
        }
    }
    
    func saveButtonTapped(){
        print("Save button tapped ...")
        saveLocationToCoreData()
    }
    
    func resetButtonColor(){
        privateButton.backgroundColor = MyVariables.secondaryColor
        followersButton.backgroundColor = MyVariables.secondaryColor
        publicButton.backgroundColor = MyVariables.secondaryColor
        
    }
    
    func cancelButtonTapped(){
        print("Cancel button tapped ...")
        navigationController?.popViewController(animated: true)
        
    }
    
    func addImageButtonTapped(){
        print("Add image button tapped ...")
        //setup the image picker
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        present(picker, animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Image picker controller cancelled ...")
        dismiss(animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        
        
        if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            pickedImage = selectedImage
            pickedImages.append(pickedImage)
            let imageView: UIImageView = {
                let image = UIImageView()
                image.image = pickedImage
                image.translatesAutoresizingMaskIntoConstraints = false
                image.contentMode = .scaleAspectFit
                return image
            }()
            
            if let cell = pickedCell{
                cell.backgroundView = imageView
            }
            else{
                //figure out how to do this well
            }
        }
        
        dismiss(animated: true, completion: nil)

    }
    
    
    func setupPickedImageView(){
        print("setting up picked image button ...")
        pickedImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pickedImageView.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 20).isActive = true
        pickedImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        pickedImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
    }
    
    
    func setupAddImageButton(){
        print("setting up add image button ...")
        addImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addImageButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 5).isActive = true
        addImageButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addImageButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
    }
    
    
    func setupSaveButton(){
        print("setup save button ...")
        saveButton.topAnchor.constraint(equalTo: addImageButton.bottomAnchor, constant: 10).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        saveButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: -70).isActive = true
    }
    
    func setupCancelButton(){
        print("setup private button ...")
        cancelButton.topAnchor.constraint(equalTo: addImageButton.bottomAnchor, constant: 10).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        cancelButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 70).isActive = true
        
    }
    
    
    
    func setupPrivateButton(){
        print("setup private button ...")
        privateButton.leftAnchor.constraint(equalTo: buttonHolderView.leftAnchor, constant: 10).isActive = true
        privateButton.widthAnchor.constraint(equalToConstant: view.frame.width/3-20).isActive = true
        privateButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        privateButton.topAnchor.constraint(equalTo: buttonHolderView.topAnchor, constant: 10).isActive = true
    }
    
    func setupFollowersButton(){
        print("setup followers button ...")
        followersButton.centerXAnchor.constraint(equalTo: buttonHolderView.centerXAnchor).isActive = true
        followersButton.topAnchor.constraint(equalTo: buttonHolderView.topAnchor, constant: 10).isActive = true
        followersButton.widthAnchor.constraint(equalToConstant: view.frame.width/3-20).isActive = true
        followersButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func setupPublicButton(){
        print("setup public button ...")
        publicButton.rightAnchor.constraint(equalTo: buttonHolderView.rightAnchor, constant: -10).isActive = true
        publicButton.widthAnchor.constraint(equalToConstant: view.frame.width/3-20).isActive = true
        publicButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        publicButton.topAnchor.constraint(equalTo: buttonHolderView.topAnchor, constant: 10).isActive = true
    }
    
    func setupButtonHolderView(){
        print("Setting up button holder view ...")
        buttonHolderView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10).isActive = true
        buttonHolderView.topAnchor.constraint(equalTo: playlistLabel.bottomAnchor, constant: 2).isActive = true
        buttonHolderView.heightAnchor.constraint(equalToConstant: 125).isActive = true
        buttonHolderView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10).isActive = true
    }
    func setupTitleLabel(){
        titleLabel.topAnchor.constraint(equalTo: buttonHolderView.bottomAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func setupTitleTextField(){
        print("setting up title text field ...")
        titleTextFieldHolderView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        titleTextFieldHolderView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2).isActive = true
        titleTextFieldHolderView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        titleTextFieldHolderView.widthAnchor.constraint(equalToConstant: view.frame.width-20).isActive = true
        titleTextField.topAnchor.constraint(equalTo: titleTextFieldHolderView.topAnchor).isActive = true
        titleTextField.leftAnchor.constraint(equalTo: titleTextFieldHolderView.leftAnchor, constant: 5).isActive = true
        titleTextField.rightAnchor.constraint(equalTo: titleTextFieldHolderView.rightAnchor).isActive = true
        titleTextField.bottomAnchor.constraint(equalTo: titleTextFieldHolderView.bottomAnchor).isActive = true
        
    }
    
    func setupPhotoLabel(){
        photoLabel.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor).isActive = true
        photoLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10).isActive = true
        photoLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        photoLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func setupDescriptionLabel(){
        descriptionLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        descriptionLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func setupDescriptionTextField(){
        print("setting up description text field ...")
        descriptionTextField.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        descriptionTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 2).isActive = true
        descriptionTextField.heightAnchor.constraint(equalToConstant: 80).isActive = true
        descriptionTextField.widthAnchor.constraint(equalToConstant: view.frame.width-20).isActive = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("TextField did begin editing method called")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("TextField did end editing method called")
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("TextField should begin editing method called")
        return true;
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        print("TextField should clear method called")
        return true;
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("TextField should snd editing method called")
        return true;
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("While entering the characters this method gets called")
        return true;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("TextField should return method called")
        titleTextField.resignFirstResponder();
        return true;
    }
    
    func saveLocationToCoreData(){
        //1
        /*
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let entity =  NSEntityDescription.entityForName("ListEntity",
                                                        inManagedObjectContext:managedContext)
        
        let location = NSManagedObject(entity: entity!,
                                       insertIntoManagedObjectContext: managedContext)
 
        
        print("got the latitude from homeviewcontroller ...")
        print(latitude)
        print("got the longitude from homeviewcontroller ...")
        print(longitude)
        var locationString = ""
        var locationImageString = ""
        titleText = titleTextField.text
        let titleTextToSave = "|" + titleText + "|"
        descriptionText = descriptionTextField.text
        let descriptionTextToSave = "|" + descriptionText + "|"
        let strlatitude = "|"+String(latitude)+"|"
        let strlongitude = "|"+String(longitude)+"|"
        print (strlatitude)
        print (strlongitude)
        print(titleText)
        print(descriptionText)
        //3
        location.setValue(strlatitude, forKey: "latitude")
        location.setValue(strlongitude, forKey: "longitude")
        location.setValue(titleTextToSave, forKey: "title")
        location.setValue(descriptionTextToSave, forKey: "desc")
        */
        //TODO: fix the way i do all of this bullshit
        //save information to firebase as well
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            print("made it in here baby")
            //have uid so I can add info to their thingy
            //else we did it successfully
            let ref = FIRDatabase.database().reference()
            let usersLocations = ref.child("users").child(uid).child("locations")
            let locationID = ref.child("AllUserLocations").childByAutoId()
            //locationString = "|"+String(describing: locationID)+"|"
            print("Users Location ... \(locationID)")
            var values: [String: Any]!
            let id = locationID.key
            let timeNum = Date(timeIntervalSinceReferenceDate: Date.timeIntervalSinceReferenceDate)
            let time = Double(timeNum.timeIntervalSinceReferenceDate)
            descriptionText = descriptionTextField.text
            titleText = titleTextField.text
            if privateButton.backgroundColor == MyVariables.mainColor{
                values = ["latitude": Double(self.latitude), "longitude": Double(self.longitude), "title": NSString(string: self.titleText), "desc": NSString(string: self.descriptionText), "owner": uid, "privateBool": true, "id":id, "time": time]
            }
            else if publicButton.backgroundColor == MyVariables.mainColor{
                values = ["latitude": Double(self.latitude), "longitude": Double(self.longitude), "title": NSString(string: self.titleText), "desc": NSString(string: self.descriptionText), "owner": uid, "publicBool": true, "id":id, "time": time]
            }
            else if followersButton.backgroundColor == MyVariables.mainColor{
                values = ["latitude": Double(self.latitude), "longitude": Double(self.longitude), "title": NSString(string: self.titleText), "desc": NSString(string: self.descriptionText), "owner": uid, "followersBool": true, "id":id, "time": time]
            }
            locationID.updateChildValues(values, withCompletionBlock: { (err, ref) in
                //there was an error
                if err != nil{
                    print(err)
                    return
                }
                //success
                print("saved user successfully go team")
            })
            let userValues = [id: String(describing: locationID)]
            usersLocations.updateChildValues(userValues, withCompletionBlock: { (err, ref) in
                //there was an error
                if err != nil{
                    print(err)
                    return
                }
                //success
                print("saved user successfully go team")
            })
            //find which global playlists to add to this
            let globalPlaylistRef = ref.child("GlobalLocations")
            for (index, element) in publicBoolArr.enumerated(){
                if element == true{
                    let actualGlobalPlaylistRef = globalPlaylistRef.child(publicPlaylistArr[index])
                    actualGlobalPlaylistRef.updateChildValues(userValues, withCompletionBlock: { (err, ref) in
                        //there was an error
                        if err != nil{
                            print(err)
                            return
                        }
                        //success
                        print("saved user successfully go team")
                    })
                }
            }
            //find which user playlists to add to
            let userPlaylistRef = ref.child("users").child(uid).child("playlists")
            for (index, element) in boolArr.enumerated(){
                if element == true{
                    let actualUserPlaylistRef = userPlaylistRef.child(playlistArr[index]).child("locations")
                    actualUserPlaylistRef.updateChildValues(userValues, withCompletionBlock: { (err, ref) in
                        //there was an error
                        if err != nil{
                            print(err)
                            return
                        }
                        //success
                        print("saved user successfully go team")
                    })
                }
            }
            //add images
            for images in pickedImages{
                print("there are now images ...")
                let usersLocationsPictures = locationID.child("images").childByAutoId()
                let imageName = UUID().uuidString
                let storageRef = FIRStorage.storage().reference().child("location_images").child("\(imageName).png")
                if let uploadData = UIImageJPEGRepresentation(images, 0.3) {
                    storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                        if error != nil {
                            print(error)
                            return 
                        }
                        
                        if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                            //locationImageString += "|"+String(profileImageUrl)+"|"
                           // print(locationImageString)
                            let values = ["image": profileImageUrl]
                            usersLocationsPictures.updateChildValues(values)
                            //ocation.setValue(locationImageString, forKey: "imagesPaths")
                            //location.setValue(locationString, forKey: "locationPath")
                            
                            //4
                            do {
                               // try managedContext.save()
                                //5
                                //self.listItems.append(location)
                            } catch let error as NSError  {
                                print("Could not save \(error), \(error.userInfo)")
                            }
                            
                        }
                    })
                }
                
            }
        }
        else{
            //user is not logged into firebase handle it
            print("didnt get current user id")
        }
        saveToPlaylists()
        //go back to the last view controller automatically
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func saveToPlaylists(){
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView{
            return 10
        }
        else if collectionView == self.playlistCollectionView{
            if publicButton.backgroundColor == MyVariables.mainColor{
                print("made it here nig nog")
                return publicPlaylistArr.count
            }
            else{
                print("in here as well")
                return playlistArr.count
                
            }
        }
        return 10
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView{
            
        }
        else if collectionView == self.playlistCollectionView{
            print("trying to get this cell")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaylistCell", for: indexPath as IndexPath)
            cell.backgroundColor = UIColor.purple
            cell.layer.cornerRadius = 5
            cell.layer.borderColor = MyVariables.secondaryColor.cgColor
            cell.layer.borderWidth = 2
            cell.layer.masksToBounds = true
            let cellLabel:UILabel = {
                let l = UILabel()
                l.translatesAutoresizingMaskIntoConstraints = false
                l.font = UIFont.boldSystemFont(ofSize: 16)
                l.adjustsFontSizeToFitWidth = true
                l.frame = cell.frame
                l.textAlignment = .center
                l.backgroundColor = UIColor.white
                return l
            }()
            cell.backgroundView = cellLabel
            if publicButton.backgroundColor == MyVariables.mainColor{
                print("in cell label")
                cellLabel.text = publicPlaylistArr[indexPath.item]
                print(publicBoolArr)
                if publicBoolArr[indexPath.item] == true {
                    cell.backgroundView?.backgroundColor = MyVariables.mainColor
                    cellLabel.textColor = UIColor.white
                    cell.layer.borderWidth = 0
                }
                else{
                    cell.backgroundView?.backgroundColor = UIColor.white
                    
                }
            }
            else{
                cellLabel.text = playlistArr[indexPath.item]
                if boolArr[indexPath.item] {
                    cell.backgroundView?.backgroundColor = MyVariables.mainColor
                    cellLabel.textColor = UIColor.white
                    cell.layer.borderWidth = 0
                }
                else{
                    cell.backgroundView?.backgroundColor = UIColor.white
                    
                }
            }
            return cell
        }
        else{
            //in here bad
            print("never be in here")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath)
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.playlistCollectionView{
            let font = UIFont.boldSystemFont(ofSize: 16)
            let fontAttributes = [NSFontAttributeName: font] // it says name, but a UIFont works
            var myText:String?
            if publicButton.backgroundColor == MyVariables.mainColor{
                myText = publicPlaylistArr[indexPath.item]
            }
            else{
                myText = playlistArr[indexPath.item]
            }
            if let text = myText{
                var size = (text as NSString).size(attributes: fontAttributes)
                size.height = 50
                size.width += 10
                return size
            }
            
        }
        else{
            return CGSize(width: cellWidth, height: cellHeight)
        }
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView{
            print(indexPath)
            print("Add image button tapped ...")
            //setup the image picker
            pickedCell = collectionView.cellForItem(at: indexPath as IndexPath)
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.navigationBar.tintColor = UIColor.white
            picker.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
            present(picker, animated: true, completion: nil)
        }
        else{
            print("tapped on playlistCell")
            let cell = playlistCollectionView.cellForItem(at: indexPath as IndexPath)
            if indexPath.item == 0 {
                return
            }
            if cell?.backgroundView?.backgroundColor == UIColor.white{
                cell?.backgroundView?.backgroundColor = MyVariables.mainColor
                if let label = cell?.backgroundView as? UILabel{
                    label.textColor = UIColor.white
                }
                cell?.layer.borderWidth = 0
                if publicButton.backgroundColor == MyVariables.mainColor{
                    publicBoolArr[indexPath.item] = true
                }
                else{
                    boolArr[indexPath.item] = true
                }
            }
            else{
                cell?.backgroundView?.backgroundColor = UIColor.white
                if let label = cell?.backgroundView as? UILabel{
                    label.textColor = UIColor.black
                }
                cell?.layer.borderWidth = 3
                if publicButton.backgroundColor == MyVariables.mainColor{
                    publicBoolArr[indexPath.item] = false
                }
                else{
                    boolArr[indexPath.item] = false
                }
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionTextField.text == "Add Description"{
            descriptionTextField.textColor = UIColor.black
            descriptionTextField.text = ""
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if descriptionTextField.text == ""{
            descriptionTextField.text = "Add Description"
            descriptionTextField.textColor = UIColor.lightGray
        }
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        descriptionTextField.resignFirstResponder()
        descriptionText = descriptionTextField.text
        
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
         DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}
