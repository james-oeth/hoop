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
   // var playlistCollectionView: UICollectionView!
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
    //make layout
    let layout2: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    //setup the scroll view so the view can show more than what fits
    let scrollView = UIScrollView()
    //setup the content view for the scroll view
    let containerView = UIView()
    
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
    
    var pickedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bball")
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
        //setup other shit
        view.backgroundColor = MyVariables.backgroundColor
        // Do any additional setup after loading the view.
        //make the title for the nav bar
        self.title = "Save Location"
        //add the playlist label
        //add the subviews
        //make a second collection view
        layout2.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 5)
        cellWidth2 = Int(self.view.frame.width)/2 - 30
        cellHeight2 = 50
        print(cellHeight2)
        print(cellWidth2)
        layout2.itemSize = CGSize(width: cellWidth2, height: cellHeight2)
        layout2.scrollDirection = .horizontal
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
    
    func saveButtonTapped(){
        print("Save button tapped ...")
        saveLocationToCoreData()
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
        picker.sourceType = .photoLibrary
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
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
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
    
    func setupTitleLabel(){
        titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
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
        //TODO: fix the way i do all of this bullshit
        //save information to firebase as well
        if (FIRAuth.auth()?.currentUser?.uid) != nil {
            print("made it in here baby")
            //have uid so I can add info to their thingy
            //else we did it successfully
            let ref = FIRDatabase.database().reference()
            let locationID = ref.child("AllUserLocations").childByAutoId()
            //locationString = "|"+String(describing: locationID)+"|"
            print("Users Location ... \(locationID)")
            var values: [String: Any]!
            let id = locationID.key
            let uid = FIRAuth.auth()?.currentUser?.uid
            let timeNum = Date(timeIntervalSinceReferenceDate: Date.timeIntervalSinceReferenceDate)
            let time = Double(timeNum.timeIntervalSinceReferenceDate)
            descriptionText = descriptionTextField.text
            titleText = titleTextField.text
            values = ["latitude": Double(self.latitude), "longitude": Double(self.longitude), "title": NSString(string: self.titleText), "desc": NSString(string: self.descriptionText), "owner": uid, "id":id, "time": time]
            locationID.updateChildValues(values, withCompletionBlock: { (err, ref) in
                //there was an error
                if err != nil{
                    print(err)
                    return
                }
                //success
                print("saved user successfully go team")
            })
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
        return 10
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath)
            //cell.backgroundView = pickedImages

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
