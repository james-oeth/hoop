//
//  SearchLocationView.swift
//  sherpaApp
//
//  Created by james oeth on 12/28/16.
//  Copyright © 2016 jamesOeth. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class searchLocationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate{
    var locationTableView: UITableView  =   UITableView()
    var keyboardHeight: CGFloat = 0
    var kHeight : CGFloat = 0
    var keyboardBool = false
    var userProfile = UserProfile()
    var allPinsToSearch: [PinAnnotation] = []
    //arry to hold all of the comments
    var holderViewHeight:CGFloat = 50
    //add the search controller
    var filteredPins: [PinAnnotation] = []
    var resultSearchController = UISearchController()
    fileprivate var shadowImageView: UIImageView?
    
    /*
     //make the text view for the user comment
     var searchTermView: UITextView = {
     var textView = UITextView()
     textView.layer.cornerRadius = 5
     textView.layer.masksToBounds = false
     textView.font = UIFont (name: "HelveticaNeue", size: 18)
     textView.translatesAutoresizingMaskIntoConstraints = false
     textView.allowsEditingTextAttributes = false
     return textView
     }()
     //make the profileimageview
     var profileImageView: UIImageView = {
     let imageView = UIImageView()
     imageView.translatesAutoresizingMaskIntoConstraints = false
     imageView.contentMode = .ScaleAspectFill
     imageView.layer.cornerRadius = 20
     imageView.layer.masksToBounds = true
     return imageView
     }()
     //make a holder view to hold the profile image the send button and writing thingy
     var holderView: UIView = {
     let v = UIView()
     v.backgroundColor = UIColor.whiteColor()
     v.translatesAutoresizingMaskIntoConstraints = false
     v.layer.borderWidth = 1
     v.layer.borderColor = UIColor(r: 255 , g: 102, b: 0).CGColor
     v.layer.cornerRadius = 5
     v.layer.masksToBounds = true
     return v
     
     }()
     */
    var searchCover: UIView = {
        let v = UIView()
        v.backgroundColor = MyVariables.mainColor
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let navigationController = self.navigationController {
            let navigationBar = navigationController.navigationBar
            let navBorder: UIView = UIView(frame: CGRect(x: 0, y: navigationBar.frame.size.height - 1, width: navigationBar.frame.size.width, height: 2))
            // Set the color you want here
            navBorder.backgroundColor = MyVariables.mainColor
            navBorder.isOpaque = true
            self.navigationController?.navigationBar.addSubview(navBorder)
        }
        view.backgroundColor = UIColor.white
        /*
         if let url = userProfile.profileImageUrl{
         profileImageView.loadImageUsingCacheWithUrlString(url)
         }
         */
        locationTableView.delegate      =   self
        locationTableView.dataSource    =   self
        //locationTableView.allowsSelection = false
        locationTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        locationTableView.isScrollEnabled = true
        locationTableView.translatesAutoresizingMaskIntoConstraints = false
        locationTableView.register(SearchCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(locationTableView)
        setuplocationTableView()
        
        navigationItem.title = "Search Locations"
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        // Do any additional setup after loading the view, typically from a nib.
        /*
         searchTermView.delegate = self
         searchTermView.becomeFirstResponder()
         */
        self.resultSearchController = UISearchController(searchResultsController: nil)
        self.resultSearchController.searchResultsUpdater = self
        self.resultSearchController.delegate = self
        self.resultSearchController.dimsBackgroundDuringPresentation = false
        self.resultSearchController.searchBar.sizeToFit()
        self.resultSearchController.searchBar.delegate = self
        self.resultSearchController.searchBar.barTintColor =  MyVariables.mainColor
        self.resultSearchController.hidesNavigationBarDuringPresentation = true
        definesPresentationContext = true
        //self.resultSearchController.searchBar.translatesAutoresizingMaskIntoConstraints = false
        //resultSearchController.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44)
        /*
         self.resultSearchController.searchBar.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor).active = true
         self.resultSearchController.searchBar.leftAnchor.constraintEqualToAnchor(view.leftAnchor).active = true
         self.resultSearchController.searchBar.rightAnchor.constraintEqualToAnchor(view.rightAnchor).active = true
         self.resultSearchController.searchBar.heightAnchor.constraintEqualToConstant(44).active = true
         */
        self.locationTableView.tableHeaderView = self.resultSearchController.searchBar
        // self.resultSearchController.searchBar.hidden = false
        //make the cancel button white
        let cancelButtonAttributes: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes as? [String : AnyObject], for: UIControlState.normal)
        //self.view.addSubview(resultSearchController.searchBar)
        //setupSearchBar()
        resultSearchController.searchBar.addSubview(searchCover)
        setupSearchCover()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        resultSearchController.isActive = false

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.resultSearchController.isActive){
            return self.filteredPins.count
        }
        else{
            return self.allPinsToSearch.count
        }
    }
    /*
     override func willMoveToParentViewController(parent: UIViewController?) {
     super.willMoveToParentViewController(parent)
     if parent == nil {
     // The back button was pressed or interactive gesture used
     self.resultSearchController.searchBar.endEditing(true)
     self.resultSearchController.searchBar.hidden = true
     }
     }
     */
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SearchCell = locationTableView.dequeueReusableCell(withIdentifier: "cell")! as! SearchCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        var arrToDisplay: [PinAnnotation] = []
        if (self.resultSearchController.isActive){
            arrToDisplay = filteredPins
        }
        else{
            arrToDisplay = allPinsToSearch
        }
        let ann = arrToDisplay[indexPath.item]
        cell.annotation = ann
        return cell
    }
    
    /*
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:SearchCell = locationTableView.dequeueReusableCellWithIdentifier("cell")! as! SearchCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        var arrToDisplay: [PinAnnotation] = []
        if (self.resultSearchController.isActive){
            arrToDisplay = filteredPins
        }
        else{
            arrToDisplay = allPinsToSearch
        }
        let ann = arrToDisplay[indexPath.item]
        cell.annotation = ann
        
        
        
        
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
         imageView.layer.cornerRadius = 0
         imageView.layer.masksToBounds = true
         imageView.image = UIImage(named: "puppies")
         return imageView
         }()
         cellView.addSubview(profileImageView)
         if let imageUrlArray = arrToDisplay[indexPath.item].URLArray{
         if let s = imageUrlArray[0] as? String{
         profileImageView.loadImageUsingCacheWithUrlString(s)
         }
         }
         profileImageView.leftAnchor.constraintEqualToAnchor(cellView.leftAnchor).active = true
         profileImageView.widthAnchor.constraintEqualToConstant(120).active = true
         profileImageView.topAnchor.constraintEqualToAnchor(cellView.topAnchor).active = true
         profileImageView.bottomAnchor.constraintEqualToAnchor(cellView.bottomAnchor).active = true
         
         let nameLabel:UILabel = {
         let l = UILabel()
         l.translatesAutoresizingMaskIntoConstraints = false
         l.font = UIFont.boldSystemFontOfSize(16)
         l.textAlignment = .Left
         l.textColor = UIColor.blackColor()
         l.backgroundColor = UIColor.clearColor()
         return l
         }()
         if let t = arrToDisplay[indexPath.item].title{
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
         l.font = UIFont.boldSystemFontOfSize(14)
         l.textAlignment = .Left
         l.textColor = UIColor.blackColor()
         l.backgroundColor = UIColor.clearColor()
         l.lineBreakMode = .ByWordWrapping
         l.numberOfLines = 0;
         return l
         }()
         commentLabel.text = arrToDisplay[indexPath.item].subtitle
         cellView.addSubview(commentLabel)
         commentLabel.leftAnchor.constraintEqualToAnchor(profileImageView.rightAnchor, constant: 5).active = true
         commentLabel.rightAnchor.constraintEqualToAnchor(cellView.rightAnchor, constant: -5).active = true
         commentLabel.bottomAnchor.constraintEqualToAnchor(cellView.bottomAnchor, constant: -5).active = true
         commentLabel.topAnchor.constraintEqualToAnchor(nameLabel.bottomAnchor).active = true
         */
        return cell
        
    }
    */
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var arrToDisplay: [PinAnnotation] = []
        if (self.resultSearchController.isActive){
            arrToDisplay = filteredPins
        }
        else{
            arrToDisplay = allPinsToSearch
        }
        let x = arrToDisplay[indexPath.item].subtitle
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 70, height: 10000))
        label.text = x
        label.numberOfLines = 100
        label.font = UIFont(name: "Times New Roman", size: 19.0)
        label.sizeToFit()
        print(label.frame.height + 80)
        if(label.frame.height + 80) > 200{
            return 200
        }
        return label.frame.height + 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
        if let cell = tableView.cellForRow(at: indexPath as IndexPath){
            var arrToDisplay: [PinAnnotation] = []
            if (self.resultSearchController.isActive){
                arrToDisplay = filteredPins
            }
            else{
                arrToDisplay = allPinsToSearch
            }
            self.navigationItem.title = ""
            let ann = arrToDisplay[indexPath.item]
            //TODO make the view that shows one place
//            let oneLocation = IndividualLocationViewController()
//            oneLocation.pinToDisplay = ann
//            oneLocation.userProfile = userProfile
//            // self.resultSearchController.searchBar.endEditing(true)
//            // self.resultSearchController.searchBar.hidden = true
//            //let allAnnotations = self.mapView.annotations
//            //self.mapView.removeAnnotations(allAnnotations)
//            //removeExtraniousViews()
//            DispatchQueue.main.async {
//                self.navigationController?.pushViewController(oneLocation, animated: true)
//            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // self.resultSearchController.searchBar.hidden = false
        // self.resultSearchController.searchBar.becomeFirstResponder()
        self.extendedLayoutIncludesOpaqueBars = !self.navigationController!.navigationBar.isTranslucent
        self.navigationItem.title = "Search Locations"
        UIView.setAnimationsEnabled(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    func keyboardWillShow(notification:NSNotification) {
        if keyboardBool == false{
            let userInfo:NSDictionary = notification.userInfo! as NSDictionary
            let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight  = keyboardRectangle.height
            kHeight = keyboardHeight
            setuplocationTableView()
            keyboardBool = true
            NotificationCenter.default.removeObserver(self)
        }
    }
    /*
     func textViewDidChange(textView: UITextView) {
     print(textView.text)
     var search = textView.text
     var searchArr = search.componentsSeparatedByString(" ")
     print(searchArr)
     for annotation in allPinsToSearch{
     var found = false
     for term in searchArr{
     if annotation.title!.containsIgnoringCase(term){
     found = true
     }
     }
     if !found{
     
     }
     }
     }
     
     func setupHolderView(){
     keyboardHeight *= -1
     holderView.topAnchor.constraintEqualToAnchor(self.view.topAnchor, constant: 5).active = true
     holderView.leftAnchor.constraintEqualToAnchor(self.view.leftAnchor).active = true
     holderView.rightAnchor.constraintEqualToAnchor(self.view.rightAnchor).active = true
     holderView.heightAnchor.constraintEqualToConstant(50).active = true
     setupsearchTermView()
     setupProfileImageView()
     }
     
     func setupsearchTermView(){
     searchTermView.topAnchor.constraintEqualToAnchor(holderView.topAnchor, constant: 5).active = true
     searchTermView.bottomAnchor.constraintEqualToAnchor(holderView.bottomAnchor, constant: -5).active = true
     searchTermView.leftAnchor.constraintEqualToAnchor(holderView.leftAnchor, constant: 50).active = true
     searchTermView.rightAnchor.constraintEqualToAnchor(holderView.rightAnchor, constant: -5).active = true
     }
     func setupProfileImageView(){
     profileImageView.leftAnchor.constraintEqualToAnchor(holderView.leftAnchor, constant: 5).active = true
     profileImageView.centerYAnchor.constraintEqualToAnchor(holderView.centerYAnchor).active = true
     profileImageView.widthAnchor.constraintEqualToConstant(40).active = true
     profileImageView.heightAnchor.constraintEqualToConstant(40).active = true
     }
     */
    
    func setupSearchCover(){
        searchCover.topAnchor.constraint(equalTo: resultSearchController.searchBar.topAnchor).isActive = true
        searchCover.heightAnchor.constraint(equalToConstant: 2).isActive = true
        searchCover.leftAnchor.constraint(equalTo: resultSearchController.searchBar.leftAnchor).isActive = true
        searchCover.rightAnchor.constraint(equalTo: resultSearchController.searchBar.rightAnchor).isActive = true
    }
    
    func setuplocationTableView(){
        print("keyboard height nigga")
        print("keyboard height nigga")
        print("keyboard height nigga")
        print("keyboard height nigga")
        print("keyboard height nigga")
        keyboardHeight = 0 - keyboardHeight
        print(keyboardHeight)
        locationTableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        locationTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        locationTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        locationTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: keyboardHeight).isActive = true
    }
    
    func setupSearchBar(){
        resultSearchController.searchBar.translatesAutoresizingMaskIntoConstraints = false
        resultSearchController.searchBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        resultSearchController.searchBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        resultSearchController.searchBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        resultSearchController.searchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        print("searching")
        let filterString = searchController.searchBar.text
        if filterString == ""{
            filteredPins = allPinsToSearch
        }
        else{
            self.filteredPins.removeAll(keepingCapacity: false)
            filteredPins = allPinsToSearch.filter({ (pin:PinAnnotation) -> Bool in
                if pin.title!.containsIgnoringCase(filterString!){
                    return true
                }
                return false
            })
        }
        DispatchQueue.main.async {
            self.locationTableView.reloadData()
        }

    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("Search button clicked")
        keyboardHeight = 0
        locationTableView.removeConstraints()
        setuplocationTableView()

    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("Search button clicked")
        keyboardHeight = kHeight
        locationTableView.removeConstraints()
        setuplocationTableView()

    }
    /*
     func willPresentSearchController(searchController: UISearchController) {
     self.navigationController?.navigationBar.translucent = true
     }
     
     func willDismissSearchController(searchController: UISearchController) {
     self.navigationController?.navigationBar.translucent = false
     }
     */
}
