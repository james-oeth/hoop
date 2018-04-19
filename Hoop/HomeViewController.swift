//
//  HomeViewController.swift
//  Hoop
//
//  Created by james oeth on 3/18/18.
//  Copyright © 2018 jamesOeth. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import CoreFoundation
import Firebase

class HomeViewController: UIViewController, UICollectionViewDataSource , CLLocationManagerDelegate, MKMapViewDelegate, UICollectionViewDelegateFlowLayout{
    //
    ///
    ////
    /////
    //////Setup All of the class variables
    /////
    ////
    ///
    //
    var choseAnnotation: Bool = false
    //make my map view
    var mapView: MKMapView = MKMapView()
    //make the map manager
    let manager = CLLocationManager()
    //make all of the image views
    var currentCoordinate: MKCoordinateRegion?{
        didSet {
            print("set the current coordinate titty balls")
            findGridZone(currentCoordinate!)
            self.saveButton.addTarget(self, action: #selector(saveLocationButtonTapped), for: .touchUpInside)
            
        }
    }
    var currentAnnotation: MKPointAnnotation?
    //reference to save location class
    var saveLocationClass: SaveLocationViewController?
    //list to hold all of the pins
    var allPinAnnotations: [String:PinAnnotation] = [String:PinAnnotation]()
    //list to hold the global pins
    var allGlobalPinAnnotations: [String:PinAnnotation] = [String:PinAnnotation]()
    //make the label baby
    var currentLabel:UILabel!
    //user to set the values for
    var user = User()
    //list of user locations
    var allUserLocations = [Location]()
    //list of all global locstions
    var allGlobalPlaylists:[String:[String]] = [String:[String]]()
    //list of user playlists
    var userPlaylist = ["Add Filter:"]
    //list of bools
    var playListBool = [Bool]()
    //create the second collection viewf
    var playlistCollectionView: UICollectionView!
    //make the cell id
    let cellId = "cellId"
    //vars to hold the cell height and width
    var cellHeight = 0
    var cellWidth = 0
    //make collection view
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    //make the permanent user
    let userProfile = UserProfile()
    //make two timestamps
    let time:Double = 10.0
    //let global playlist
    let globalPlaylist: [String] = {
        var a = ["Add Filter:","Biking", "Cliff Jumping", "Climbing", "Dispersed Camping", "Gear Store", "Hiking", "Ice Climbing", "Resteraunts", "Site Camping", "Skiing", "Sunrise View", "Sunset View", "Trail Running"]
        return a
    }()    //let global plauylist bool
    var globalPlaylistBool:[Bool] = []
    //button color
    let buttonColor = MyVariables.secondaryColor
    //make the global grid of bools
    var gridBool: [[Bool]] = [[]]
    var buttonConstant: CGFloat = 0
    var circleConstant: CGFloat = 0
    //
    ///
    ////
    /////
    //////Setup All of the Views
    /////
    ////
    ///
    //
    //variable for the save button at the bottom of the view, this button changes title depending on which side pannel button is pressed
    lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        //button.backgroundColor = UIColor(r: 59 , g: 89, b: 152)
        button.backgroundColor = MyVariables.mainColor
        //start the title at save locations
        button.setTitle("Save Location", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        button.layer.borderColor = MyVariables.tierciaryColor.cgColor
        button.layer.borderWidth = 2
        button.layer.masksToBounds = true
        return button
    }()
    
    //view to hold all of the left panel buttons
    var buttonHolderView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.clear
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 5
        v.layer.masksToBounds = true
        v.alpha = 1
        return v
        
    }()
    
    //second slide out panel for your personal view options
    var allLocationOptionsView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.clear
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 5
        v.layer.masksToBounds = true
        v.alpha = 1
        return v
    }()
    
    //view to hold the bracket view for  vb
    let bracketHolderView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "closebracket")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = UIColor.lightGray
        imageView.alpha = 0.5
        return imageView
    }()
    
    //top button in the button holder view and it starts out as the one that is pressed it is the button connected to the users current location
    lazy var currentLocationViewButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(currentLocationViewButtonTapped), for: .touchUpInside)
        let currentLocationButtonImage = UIImage(named: "currentLocation")!.withRenderingMode(.alwaysTemplate)
        button.setImage(currentLocationButtonImage, for: .normal)
        //test new image try
        let origImage = UIImage(named: "currentLocation");
        let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = self.buttonColor
        button.alpha = 1
        return button
    }()
    
    //button to zoom the span in
    lazy var zoomButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(zoomButtonTapped), for: .touchUpInside)
        //let currentLocationButtonImage = UIImage(named: "zoom")!.imageWithRenderingMode(.AlwaysTemplate)
        //button.setImage(currentLocationButtonImage, forState: .Normal)
        let origImage = UIImage(named: "zoom");
        let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = self.buttonColor
        return button
    }()
    
    //button to zoom the span out
    lazy var shrinkButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(shrinkButtonTapped), for: .touchUpInside)
        //let currentLocationButtonImage = UIImage(named: "shrink")!.imageWithRenderingMode(.AlwaysTemplate)
        //button.setImage(currentLocationButtonImage, forState: .Normal)
        let origImage = UIImage(named: "shrink");
        let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = self.buttonColor
        return button
    }()
    
    //button to show all of the users locations, this button prompts the secondary all locations options view to slide out
    lazy var allLocationsViewButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(allLocationsViewButtonTapped), for: .touchUpInside)
        let currentLocationButtonImage = UIImage(named: "singlePin") as UIImage?
        button.setImage(currentLocationButtonImage, for: .normal)
        let origImage = UIImage(named: "singlePin");
        let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = self.buttonColor
        return button
    }()
    
    //button to save where your car is this is the third button down
    lazy var carLocationsViewButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(carLocationsViewButtonTapped), for: .touchUpInside)
        //let currentLocationButtonImage = UIImage(named: "carIcon") as UIImage?
        //button.setImage(currentLocationButtonImage, forState: .Normal)
        let origImage = UIImage(named: "car");
        let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = self.buttonColor
        return button
    }()
    
    //bottom button in the left side pannel view still has no function
    //TODO: make the friends view work
    lazy var friendsLocationsViewButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(friendsLocationsViewButtonTapped), for: .touchUpInside)
        //let currentLocationButtonImage = UIImage(named: "account") as UIImage?
        //button.setImage(currentLocationButtonImage, forState: .Normal)
        let origImage = UIImage(named: "account");
        let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = self.buttonColor
        return button
    }()
    
    //button for global locations
    lazy var globalLocationsViewButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(globalLocationsViewButtonTapped), for: .touchUpInside)
        //let currentLocationButtonImage = UIImage(named: "globe") as UIImage?
        //button.setImage(currentLocationButtonImage, forState: .Normal)
        let origImage = UIImage(named: "globe");
        let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = self.buttonColor
        return button
    }()
    
    //setup the settings launcher variable
    lazy var settingsLauncher: SettingsLauncher = {
        let launcher = SettingsLauncher()
        launcher.homeViewController = self
        return launcher
    }()
    
    //button on the botton sends to save locationbutton tapped method
    lazy var circleButtonButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(saveLocationButtonTapped), for: .touchUpInside)
        button.setTitle("Save Location", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        return button
    }()
    //seperates view on bottome
    let seperatorView:UIView = {
        let v = UIView()
        v.backgroundColor = MyVariables.tierciaryColor
        v.layer.masksToBounds = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        UIView.setAnimationsEnabled(true)
        self.navigationController?.viewControllers = [self]
        
    }
    
    func makeGetRequest(){
        // Define server side script URL
        let scriptUrl = "http://localhost:8080/FP201/PlayServe?purpose=locations"
        // Add one parameter
        // Create NSURL Ibject
        let myUrl = NSURL(string: scriptUrl);
        
        // Creaste URL Request
        let request = NSMutableURLRequest(url:myUrl! as URL);
        
        // Set request HTTP method to GET. It could be POST as well
        request.httpMethod = "GET"
        
        // If needed you could add Authorization header value
        // Add Basic Authorization
        /*
         let username = "myUserName"
         let password = "myPassword"
         let loginString = NSString(format: "%@:%@", username, password)
         let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
         let base64LoginString = loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions())
         request.setValue(base64LoginString, forHTTPHeaderField: "Authorization")
         */
        
        // Or it could be a single Authorization Token value
        //request.addValue("Token token=884288bae150b9f2f68d8dc3a932071d", forHTTPHeaderField: "Authorization")
        
        // Excute HTTP Request
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            // Check for error
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            // Print out response string
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("responseString = \(responseString)")
            
            
            // Convert server json response to NSDictionary
            do {
                if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    
                    // Print out dictionary
                    print(convertedJsonIntoDict)
                    
                    // Get value by key
                    let firstNameValue = convertedJsonIntoDict["userName"] as? String
                    print(firstNameValue!)
                    
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }
        
        task.resume()
    }
    
    
    //view did load function
    override func viewDidLoad() {
        super.viewDidLoad()
        makeGetRequest()
        //set the button constant so that the buttons are sized perfectly for every screen
        buttonConstant = CGFloat((view.frame.width-20-(view.frame.width/3.5))/5)
        buttonConstant += 5
        //get the current users locations and playlists
        getUsersLocationsAndPlaylists()
        //make this the bottom view controller on the navigation stack
        self.navigationController?.viewControllers = [self]
        //make the bool array
        makeGridBool()
        //make playlists bool so we know which one should be hilighted
        globalPlaylistBool = [Bool](repeating: false, count: globalPlaylist.count)
        //first check if user is logged in
        checkIfUserIsLoggedIn()
        //then get the users locations and playlists
        getUsersLocationsAndPlaylists()
        print("view did load called")
        //set the location manager settings
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
        //get all of the global locations in a background thread
        DispatchQueue.main.async {
            //self.getListOfFriendsView()
            self.createAllGlobalLocations()
        }
        //setup view
        view.backgroundColor = UIColor.gray
        //setup all of the crazy subviews
        view.addSubview(mapView)
        setupMapView()
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
        manager.requestLocation()
        view.addSubview(saveButton)
        setupSaveButton()
        
        view.addSubview(buttonHolderView)
        setupButtonHolderView()
        navigationItem.title = "Home"
        //label on the left side
        currentLabel = UILabel(frame: CGRect(x: 0,y: 0,width: view.frame.width-32, height: view.frame.height))
        currentLabel.text = "Current Location"
        currentLabel.textColor = UIColor.white
        currentLabel.font = UIFont.systemFont(ofSize: 20)
        navigationItem.titleView = currentLabel
        navigationController?.navigationBar.isTranslucent = false
        //setup the two bar button items
        setupNavBarButtons()
        print("finished view did load")
        //fetch the items from core data
        
        //make a collection view for displaying playlists
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        cellWidth = Int(self.view.frame.width)/2 - 30
        cellHeight = 50
        print(cellHeight)
        print(cellWidth)
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.scrollDirection = .horizontal
        playlistCollectionView = UICollectionView(frame: CGRect(x: 0, y:0, width:0, height:0), collectionViewLayout: layout)
        playlistCollectionView.dataSource = self
        playlistCollectionView.delegate = self
        playlistCollectionView.layer.cornerRadius = 5
        playlistCollectionView.layer.masksToBounds = true
        playlistCollectionView.translatesAutoresizingMaskIntoConstraints = false
        playlistCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        playlistCollectionView.backgroundColor = UIColor.clear
        //watch for followers to send a push notification
        watchForFollowers()
    }
    
    func watchForFollowers(){
        //TODO:make this watch for followers and send a push notification :)
        if let uid = FIRAuth.auth()?.currentUser?.uid{
            let ref = FIRDatabase.database().reference().child(uid).child("requestedFollowers")
            ref.observe(.childAdded, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    print("nipple goblins baby woohoo")
                }
            }, withCancel: nil)
        }
    }
    
    func findGridZone( _ coordinate: MKCoordinateRegion){
        /*
         print("latitude is ")
         print(coordinate.center.latitude)
         print("longitude is " )
         print(coordinate.center.longitude)
         let lat = Int(coordinate.center.latitude)
         let long = Int(coordinate.center.longitude)
         let adjustedLat = lat + 90
         let adjustedLong = long + 180
         print(adjustedLat)
         print(adjustedLong)
         let gridString = String(adjustedLat) + "x" + String(adjustedLong)
         gridBool[adjustedLat][adjustedLong] = true
         print(gridString)
         */
    }
    
    func makeGridBool(){
        /*
         let boolRow = [Bool](repeating: false, count: 361)
         for i in Range(0 ..< 181){
         if i == 0{
         gridBool[0] = boolRow
         }
         else{
         gridBool.append(boolRow)
         }
         }
         */
    }
    
    
    //function to make sure user is logged in on firebase and facebook
    //TODO: get check to see if they made their own username and password then remove the social aspects or figure out a way to let them have social aspects as well
    func checkIfUserIsLoggedIn() {
        
    }
    
    //if the user wants to logout this handles it
    //TODO: check if theyre logged in using fb as well then log them out with that
    func handleLogout(){
        try! FIRAuth.auth()!.signOut()
        let loginController = LoginViewController()
        loginController.userLoggedOut = true
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(loginController, animated: true)
        }
    }
    
    //
    ///
    ////
    /////
    //////Setup All of the Constraints
    /////
    ////
    ///
    //
    //setup the constraints on the save button
    func setupSaveButton(){
        //setup save button
        //make the title save button because thats what it should always load as
        saveButton.setTitle("Save Location", for: .normal)
        //constrain x,y,width,height
        circleConstant = (view.frame.width / -6)
        saveButton.layer.cornerRadius = view.frame.width/2
        saveButton.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        saveButton.topAnchor.constraint(equalTo: view.bottomAnchor, constant: circleConstant).isActive = true
        saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    
    func setupBracketHolderView(){
        print("in bracket holder view")
        bracketHolderView.leftAnchor.constraint(equalTo: allLocationOptionsView.leftAnchor).isActive = true
        bracketHolderView.topAnchor.constraint(equalTo: allLocationOptionsView.topAnchor).isActive = true
        bracketHolderView.bottomAnchor.constraint(equalTo: allLocationOptionsView.bottomAnchor).isActive = true
        //bracketHolderView.rightAnchor.constraintEqualToAnchor(allLocationOptionsView.rightAnchor).active = true
        bracketHolderView.widthAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func setupSeperatorView(){
        seperatorView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        seperatorView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        seperatorView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        seperatorView.heightAnchor.constraint(equalToConstant: 3).isActive = true
    }
    
    func setupZoomButton(){
        print("setting up zoom button")
        zoomButton.leftAnchor.constraint(equalTo: shrinkButton.rightAnchor, constant: 10).isActive = true
        zoomButton.centerYAnchor.constraint(equalTo: saveButton.centerYAnchor).isActive = true
        zoomButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        zoomButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func setupShrinkButton(){
        print("setting up zoom button")
        shrinkButton.leftAnchor.constraint(equalTo: saveButton.rightAnchor, constant: 20).isActive = true
        shrinkButton.centerYAnchor.constraint(equalTo: saveButton.centerYAnchor).isActive = true
        shrinkButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        shrinkButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func setupAllLocationsOptionsView(){
        allLocationOptionsView.centerYAnchor.constraint(equalTo: allLocationsViewButton.centerYAnchor).isActive = true
        allLocationOptionsView.leftAnchor.constraint(equalTo: buttonHolderView.rightAnchor).isActive = true
        allLocationOptionsView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        allLocationOptionsView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    //setup the settings launcher
    func setupNavBarButtons(){
        let searchImage = UIImage(named: "search_icon")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
        let moreButton = UIImage(named: "nav_more_icon")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        let moreBarButtonItem = UIBarButtonItem(image: moreButton, style: .plain, target: self, action: #selector(handleMore))
        navigationItem.rightBarButtonItems = [moreBarButtonItem, searchBarButtonItem]
        
    }
    
    //setup of all of the buttons
    func setupFriendsLocationsViewButton(){
        let radius = pow(Double(view.frame.width/2),2)
        let x = pow(Double((buttonConstant*2)+8),2)
        var secondTierY = CGFloat(sqrt((radius-x)))
        secondTierY -= (view.frame.width / 6 * 2)
        print("setting up the firendsLocationsViewButton ...")
        friendsLocationsViewButton.rightAnchor.constraint(equalTo: currentLocationViewButton.leftAnchor, constant: 0).isActive = true
        friendsLocationsViewButton.heightAnchor.constraint(equalToConstant: buttonConstant).isActive = true
        friendsLocationsViewButton.widthAnchor.constraint(equalToConstant: buttonConstant).isActive = true
        friendsLocationsViewButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -secondTierY-5).isActive = true
        friendsLocationsViewButton.backgroundColor = UIColor.clear
        
    }
    
    func setupCarLocationsViewButton(){
        let radius = pow(Double(view.frame.width/2),2)
        let x = pow(Double((buttonConstant*2)+8),2)
        var secondTierY = CGFloat(sqrt((radius-x)))
        secondTierY -= (view.frame.width / 6 * 2)
        print("setting up the playlistLocationsViewButton ...")
        carLocationsViewButton.leftAnchor.constraint(equalTo: allLocationsViewButton.rightAnchor, constant: 2).isActive = true
        carLocationsViewButton.heightAnchor.constraint(equalToConstant: buttonConstant-7).isActive = true
        carLocationsViewButton.widthAnchor.constraint(equalToConstant: buttonConstant-7).isActive = true
        carLocationsViewButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -secondTierY-22).isActive = true
        carLocationsViewButton.backgroundColor = UIColor.clear
        
    }
    
    func setupAllLocationsViewButton(){
        let radius = pow(Double(view.frame.width/2),2)
        let x = pow(Double((buttonConstant)+8),2)
        var firstTierY = CGFloat(sqrt((radius-x)))
        firstTierY -= (view.frame.width / 6 * 2)
        print("setting up the playlistLocationsViewButton ...")
        allLocationsViewButton.leftAnchor.constraint(equalTo: globalLocationsViewButton.rightAnchor, constant: 5).isActive = true
        allLocationsViewButton.heightAnchor.constraint(equalToConstant: buttonConstant-5).isActive = true
        allLocationsViewButton.widthAnchor.constraint(equalToConstant: buttonConstant-5).isActive = true
        allLocationsViewButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -firstTierY-5).isActive = true
        allLocationsViewButton.backgroundColor = UIColor.clear
    }
    
    func setupGlobalLocationsViewButton(){
        print("setting up the allLocationsViewButton ...")
        globalLocationsViewButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        globalLocationsViewButton.heightAnchor.constraint(equalToConstant: buttonConstant).isActive = true
        globalLocationsViewButton.widthAnchor.constraint(equalToConstant: buttonConstant).isActive = true
        globalLocationsViewButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: circleConstant-5).isActive = true
        globalLocationsViewButton.backgroundColor = UIColor.clear
    }
    
    func setupButtonHolderView() {
        print("setting up the button holder view ...")
        buttonHolderView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buttonHolderView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        buttonHolderView.heightAnchor.constraint(equalToConstant: buttonConstant).isActive = true
        buttonHolderView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        view.addSubview(globalLocationsViewButton)
        setupGlobalLocationsViewButton()
        view.addSubview(allLocationsViewButton)
        setupAllLocationsViewButton()
        view.addSubview(currentLocationViewButton)
        setupCurrentLocationViewButton()
        view.addSubview(carLocationsViewButton)
        setupCarLocationsViewButton()
        view.addSubview(friendsLocationsViewButton)
        setupFriendsLocationsViewButton()
        view.addSubview(circleButtonButton)
        setupCircleButtonButton()
        
    }
    
    func setupCircleButtonButton(){
        circleButtonButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5).isActive = true
        circleButtonButton.leftAnchor.constraint(equalTo: friendsLocationsViewButton.rightAnchor).isActive = true
        circleButtonButton.rightAnchor.constraint(equalTo: carLocationsViewButton.leftAnchor).isActive = true
        circleButtonButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func setupCurrentLocationViewButton() {
        print(view.frame.width/2)
        let radius = pow(Double(view.frame.width/2),2)
        let x = pow(Double((buttonConstant)+8),2)
        var firstTierY = CGFloat(sqrt((radius-x)))
        firstTierY -= (view.frame.width / 6 * 2)
        print("setting up the CurrentLocationViewButton ...")
        currentLocationViewButton.heightAnchor.constraint(equalToConstant: buttonConstant-5).isActive = true
        currentLocationViewButton.widthAnchor.constraint(equalToConstant: buttonConstant-5).isActive = true
        currentLocationViewButton.rightAnchor.constraint(equalTo: globalLocationsViewButton.leftAnchor, constant: -10).isActive = true
        currentLocationViewButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -firstTierY-5).isActive = true
        currentLocationViewButton.tintColor = MyVariables.mainColor
    }
    
    
    
    func setupMapView(){
        print("setting up the map view ...! ")
        // Do any additional setup after loading the view, typically from a nib.
        mapView.mapType = .standard
        mapView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        mapView.delegate = self
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        if let coordinate = currentCoordinate{
            mapView.setRegion(coordinate, animated: true)
        }
        if let annotation = currentAnnotation{
            mapView.addAnnotation(annotation)
        }
        
    }
    
    func handleSearch(){
        print("handle the search baby")
        if let ann = currentAnnotation{
            mapView.removeAnnotation(ann)
        }
        let allAnnotations = mapView.annotations as? [PinAnnotation]
        let searchView = searchLocationViewController()
        guard let ann = allAnnotations else{
            return
        }
        if ann.count != 0{
            searchView.allPinsToSearch = ann
            searchView.userProfile = userProfile
            DispatchQueue.main.async {
                self.navigationController?.navigationBar.tintColor = UIColor.white
                self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
                self.navigationController?.pushViewController(searchView, animated: true)
            }
        }
    }
    
    func handleMore(){
        settingsLauncher.showSettings()
    }
    
    //put the settings controller onto the view
    func showControllerForSetting(_ setting: Setting) {
        //remove the extra views so it resets once we exit from the settings controller
        if setting.name == "Log Out"{
            print("in herer baby")
            handleLogout()
            /*
             let loginViewController = LoginViewController()
             loginViewController.navigationItem.title = "login screen"
             navigationController?.navigationBar.tintColor = UIColor.whiteColor()
             navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
             navigationController?.pushViewController(loginViewController, animated: true)
             */
        }
        else if setting.name == "My Account"{
            print("into this if ")
            
           // let userViewController = UserAccountView()
//            userViewController.navigationItem.title = "My Account"
//            //userViewController.userProfile = userProfile
//            userViewController.playlists = userPlaylist
//            DispatchQueue.main.async {
//                self.navigationController?.navigationBar.tintColor = UIColor.white
//                self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
//                self.navigationController?.pushViewController(userViewController, animated: true)
//            }
        }
        else if setting.name == "Terms & privacy policy"{
            /*
             let privacyView = privacyViewController()
             privacyView.navigationItem.title = "Privacy Policy"
             DispatchQueue.main.async {
             self.navigationController?.navigationBar.tintColor = UIColor.white
             self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
             self.navigationController?.pushViewController(privacyView, animated: true)
             }
             */
        }
            
        else{
            let dummySettingsViewController = UIViewController()
            dummySettingsViewController.view.backgroundColor = UIColor.white
            dummySettingsViewController.navigationItem.title = setting.name
            DispatchQueue.main.async {
                self.navigationController?.navigationBar.tintColor = UIColor.white
                self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
                self.navigationController?.pushViewController(dummySettingsViewController, animated: true)
            }
            
        }
    }
    
    
    //
    ///
    ////
    /////
    //////all of the button tapped methods
    /////
    ////
    ///
    //
    func currentLocationViewButtonTapped(){
        if let ann = currentAnnotation{
            currentLabel.text = "Current Location"
            handleDifferentButton(currentLabel.text!)
            currentLocationViewButton.tintColor = MyVariables.mainColor
            let allAnnotations = self.mapView.annotations
            self.mapView.removeAnnotations(allAnnotations)
            mapView.setRegion(currentCoordinate!, animated: true)
            mapView.addAnnotation(ann)
            mapView.selectedAnnotations.description
            circleButtonButton.setTitle("Save Location", for: .normal)
        }
        else{
            //TODO: make a popup that says it cannot find your current location
            print("No current locations")
        }
        
    }
    
    func zoomButtonTapped(){
        let span = mapView.region.span
        print(span)
        var region = self.mapView.region
        region.span.latitudeDelta /= 3
        region.span.longitudeDelta /= 3
        mapView.setRegion(region, animated: true)
    }
    
    func innerAllLocationButtonTapped(){
        playlistCollectionView.removeFromSuperview()
        playListBool.removeAll()
        playListBool = [Bool](repeating: false, count: globalPlaylist.count)
        print("allLocationButtonTapped")
        allLocationsViewButton.backgroundColor = UIColor.white
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        mapMyAnnotations()
    }
    
    func globalLocationsViewButtonTapped(){
        print("titties")
        currentLabel.text = "Global Locations"
        handleDifferentButton(currentLabel.text!)
        globalLocationsViewButton.tintColor = MyVariables.mainColor
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        circleButtonButton.setTitle("Search Locations", for: .normal)
        showPlaylistCollectionView()
        showAllGlobalLocations()
    }
    
    func showAllGlobalLocations(){
        print(allGlobalPlaylists)
        if let anno = currentAnnotation{
            mapView.addAnnotation(anno)
            let span = MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
            let region = MKCoordinateRegion(center: currentCoordinate!.center, span: span)
            mapView.setRegion(region, animated: true)
            
        }
        else{
            //let span = MKCoordinateSpan(latitudeDelta: 50, longitudeDelta: 50)
            //let region = MKCoordinateRegion(center: currentCoordinate!.center, span: span)
            //mapView.setRegion(region, animated: true)
        }
        for (key,_) in allGlobalPlaylists{
            for k in allGlobalPlaylists[key]!{
                self.mapView.addAnnotation(self.allGlobalPinAnnotations[k]!)
            }
        }
        
    }
    
    func shrinkButtonTapped(){
        var region = self.mapView.region
        region.span.latitudeDelta *= 3
        region.span.longitudeDelta *= 3
        if region.span.longitudeDelta > 300 || region.span.latitudeDelta > 300{
            return
        }
        mapView.setRegion(region, animated: true)
    }
    
    func carLocationsViewButtonTapped(){
        currentLabel.text = "My Car"
        handleDifferentButton(currentLabel.text!)
        carLocationsViewButton.tintColor = MyVariables.mainColor
        circleButtonButton.setTitle("Save Car", for: .normal)
        showCarLocation()
    }
    
    func nearMeButtonTapped(){
        playlistCollectionView.removeFromSuperview()
        let span = MKCoordinateSpanMake(0.02, 0.02)
        if let coordinate = currentCoordinate?.center{
            let region = MKCoordinateRegionMake(coordinate, span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    
    func allLocationsViewButtonTapped(){
        print("all locations options view tapped")
        currentLabel.text = "All Locations"
        handleDifferentButton(currentLabel.text!)
        allLocationsViewButton.tintColor = MyVariables.mainColor
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        circleButtonButton.setTitle("Search Locations", for: .normal)
       // showPlaylistCollectionView()
        mapMyAnnotations()
    }
    
    func friendsLocationsViewButtonTapped(){
        /*
         currentLabel.text = "Friends"
         handleDifferentButton(currentLabel.text!)
         friendsLocationsViewButton.tintColor = MyVariables.mainColor
         circleButtonButton.setTitle("Show Friends", forState: .Normal)
         let allAnnotations = self.mapView.annotations
         self.mapView.removeAnnotations(allAnnotations)
         mapFriendLocations()
         
         let friendsViewController = ShowFollowingViewController()
         friendsViewController.userProfile = userProfile
         print("should push to next view")
         DispatchQueue.main.async {
         self.navigationController?.navigationBar.tintColor = UIColor.white
         self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
         self.navigationController?.pushViewController(friendsViewController, animated: true)
         }
         */
        
    }
    
    func saveLocationButtonTapped(){
        print("save button tapped")
        if circleButtonButton.currentTitle == "Save Location"{
            let saveLocation = SaveLocationViewController()
            if let long = currentCoordinate?.center.longitude {
                saveLocation.longitude = long
                print(long)
            }
            if let lat = currentCoordinate?.center.latitude {
                saveLocation.latitude = lat
                print(lat)
            }
            DispatchQueue.main.async {
                self.navigationController?.navigationBar.tintColor = UIColor.white
                self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
                self.navigationController?.pushViewController(saveLocation, animated: true)
            }
            
        }
        if circleButtonButton.currentTitle == "Search Locations" {
            if let ann = currentAnnotation{
                mapView.removeAnnotation(ann)
            }
            let allAnnotations = mapView.annotations as? [PinAnnotation]
            let searchView = searchLocationViewController()
            guard let ann = allAnnotations else{
                return
            }
            if ann.count != 0{
                searchView.allPinsToSearch = ann
                searchView.userProfile = userProfile
                DispatchQueue.main.async {
                    self.navigationController?.navigationBar.tintColor = UIColor.white
                    self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
                    self.navigationController?.pushViewController(searchView, animated: true)
                }
            }
        }
    }
    
    //
    ///
    ////
    /////
    //////handle different buttons being tapped
    /////
    ////
    ///
    //
    
    func handleDifferentButton(_ sender: String){
        changeHighlightedButton()
        globalPlaylistBool.removeAll()
        globalPlaylistBool = [Bool](repeating: false, count: globalPlaylist.count)
        playListBool.removeAll()
        playListBool = [Bool](repeating: false, count: userPlaylist.count)
        if sender != "All Locations" && sender != "Global Locations"{
            UIView.animate(withDuration: TimeInterval(0.5), animations: {
                self.playlistCollectionView.alpha = 0.0
                self.allLocationOptionsView.alpha = 0.0
            }) { (true) in
                print("completed animations")
                self.playlistCollectionView.removeFromSuperview()
                self.allLocationOptionsView.removeFromSuperview()
            }
            
        }
    }
    
    func changeHighlightedButton(){
        currentLocationViewButton.tintColor = MyVariables.secondaryColor
        friendsLocationsViewButton.tintColor = MyVariables.secondaryColor
        carLocationsViewButton.tintColor = MyVariables.secondaryColor
        allLocationsViewButton.tintColor = MyVariables.secondaryColor
        globalLocationsViewButton.tintColor = MyVariables.secondaryColor
    }
    
    
    //
    ///
    ////
    /////
    //////all of the location methods
    /////
    ////
    ///
    //
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("in here")
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
        if let location = locations.first {
            print("Found user's location: \(location)")
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            annotation.title = "Current Location"
            mapView.addAnnotation(annotation)
            let coordinates = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.005 , longitudeDelta: 0.005)
            let coordinateRegion = MKCoordinateRegion(center: coordinates, span: span)
            currentCoordinate = coordinateRegion
            currentAnnotation = annotation
            mapView.setRegion(coordinateRegion, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    //goes through list of map coordinates and finds the correct span and sets it
    func mapSetSpan(){
        print("setting the span baby")
        var highLat = -500.0
        var lowLat = 500.0
        var highLong = -500.0
        var lowLong = 500.0
        if allPinAnnotations.count != 0{
            for (_,val) in allPinAnnotations{
                var latitude: Double = 0.0
                var longitude: Double = 0.0
                latitude = val.coordinate.latitude
                longitude = val.coordinate.longitude
                print("latitude and longitude for calculations ...")
                print(longitude, latitude)
                //if statements to find highest and lowest distances
                if latitude > highLat{ highLat = latitude }
                if latitude < lowLat{ lowLat = latitude }
                if longitude > highLong{ highLong = longitude }
                if longitude < lowLong{ lowLong = longitude }
            }
            let middleLat = (highLat+lowLat)/2
            print(highLat, lowLat)
            let middleLong = (highLong+lowLong)/2
            print(highLong, lowLong)
            let middlePoint :CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: middleLat, longitude: middleLong)
            //let span = MKCoordinateSpan(latitudeDelta: (highLat-lowLat+1)*2, longitudeDelta: (highLong-lowLong+1)*2)
            let span = MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100)
            let region = MKCoordinateRegion(center: middlePoint, span: span)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.mapView.setRegion(region, animated: true)
            }) { (completed: Bool) in
                
            }
        }
        
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        print("makes it into this shit boiiii")
        if annotation is PinAnnotation {
            print("its a pin annotation!!!")
            let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myPin")
            pinAnnotationView.pinTintColor = MyVariables.pinColor
            //pinAnnotationView.pinTintColor = UIColor.lightGrayColor()
            pinAnnotationView.isDraggable = false
            pinAnnotationView.canShowCallout = true
            pinAnnotationView.animatesDrop = true
            
            let deleteButton = UIButton(type: .custom)
            deleteButton.frame.size.width = 44
            deleteButton.frame.size.height = 44
            deleteButton.backgroundColor = UIColor.white
            deleteButton.tag = 1
            let origImage = UIImage(named: "help");
            let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            deleteButton.setImage(tintedImage, for: .normal)
            deleteButton.tintColor = MyVariables.secondaryColor
            pinAnnotationView.leftCalloutAccessoryView = deleteButton
            
            let directionsButton = UIButton(type: .custom)
            directionsButton.frame.size.width = 35
            directionsButton.frame.size.height = 35
            directionsButton.tag = 2
            directionsButton.backgroundColor = UIColor.white
            let oriImage = UIImage(named: "carIcon");
            let tinteImage = oriImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            directionsButton.setImage(tinteImage, for: .normal)
            directionsButton.tintColor = MyVariables.secondaryColor
            pinAnnotationView.rightCalloutAccessoryView = directionsButton
            return pinAnnotationView
            
        }
        
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotation = view.annotation as? PinAnnotation {
            if control.tag == 1{
                print("tapped on the open button ...")
                let oneLocation = IndividualLocationViewController()
                oneLocation.pinToDisplay = annotation
                oneLocation.userProfile = userProfile
                //let allAnnotations = self.mapView.annotations
                //self.mapView.removeAnnotations(allAnnotations)
                //removeExtraniousViews()
                self.navigationController?.navigationBar.tintColor = UIColor.white
                self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(oneLocation, animated: true)
                }
            }
            else if control.tag == 2{
                let dict = [String:AnyObject]()
                let placeMark = MKPlacemark(coordinate: annotation.coordinate, addressDictionary: dict)
                let mapItem = MKMapItem(placemark: placeMark)
                
                mapItem.name = "The way I want to go"
                
                //You could also choose: MKLaunchOptionsDirectionsModeWalking
                let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                
                mapItem.openInMaps(launchOptions: launchOptions)
            }
        }
    }
    
    //HOOP GET LOCATIONS
    func createAllGlobalLocations(){
        print("making global locations")
        let ref = FIRDatabase.database().reference().child("AllUserLocations")
        ref.observe(.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                print("in the if let ")
                for (key,val) in dictionary{
                    print("key")
                    print(key)
                    self.allGlobalPlaylists[String(key)] = []
                    if let dict = val as? [String: AnyObject]{
                        let loc = Location()
                        loc.setValuesForKeys(dict)
                        self.createPinAnnotation(loc, sender: "global")
                    }
                }
            }
        })
    }
    
    
    func showCarLocation(){
        //show the cars location
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let newPin = PinAnnotation()
                var coordinate = CLLocationCoordinate2D()
                if let lat = dictionary["carLat"] as? Double{
                    coordinate.latitude = lat
                    if let long = dictionary["carLong"] as? Double{
                        coordinate.longitude = long
                    }
                    newPin.setCoordinate(coordinate)
                    newPin.title = "Dude heres my car"
                    let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                    let region = MKCoordinateRegion(center: coordinate, span: span)
                    self.mapView.addAnnotation(newPin)
                    self.mapView.setRegion(region, animated: true)
                }
            }
        }, withCancel: nil)
    }
    
    func saveCurrentLocationAsCar(){
        print("in this bitch")
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            print("made it in here baby")
            //have uid so I can add info to their thingy
            //else we did it successfully
            let ref = FIRDatabase.database().reference(fromURL: "https://drop-335ed.firebaseio.com/")
            let user = ref.child("users").child(uid)
            guard let lat = self.currentCoordinate?.center.latitude else{ return }
            guard let long = self.currentCoordinate?.center.longitude else { return }
            let values = ["carLat": Double(lat), "carLong": Double(long)]
            user.updateChildValues(values)
        }
    }
    
    func  getListOfFriendsView(){
        
    }
    
    func getUsersLocationsAndPlaylists(){
        print("make user locations and playlist called")
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            //for some reason uid = nil
            print("is this the problem")
            return
        }
        FIRDatabase.database().reference().child("users").child(uid).observe(.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                print("make user and playlist called")
                print(dictionary)
                self.user.setValuesForKeys(dictionary)
                self.getUserLocations(self.user)
                self.getUserPlaylists(self.user)
                self.makeUserProfile(self.user)
            }
        }, withCancel: nil)
    }
    
    func makeUserProfile(_ user: User){
        //set user stuff
        if let id = user.id as? String{
            userProfile.id = id
        }
        if let first = user.firstName as? String{
            userProfile.firstName = first
        }
        if let last = user.lastName as? String{
            userProfile.lastName = last
        }
        if let un = user.username as? String{
            userProfile.username = un
        }
        if let url = user.profileImage as? String{
            userProfile.profileImageUrl = url
            let imageView = UIImageView()
            DispatchQueue.main.async {
                imageView.loadImageUsingCacheWithUrlString(url)
            }
        }
        /*
         if let playlists = user.playlists as? [String]{
         print(playlists)
         userProfile.playlists = playlists
         }
         */
        if let followers = user.followers as? [String:AnyObject]{
            let keys = Array(followers.keys)
            print(keys)
            userProfile.followers = keys
        }
        
        if let requestedFollowers = user.requestedFollowers as? [String:AnyObject]{
            let keys = Array(requestedFollowers.keys)
            print(keys)
            userProfile.requestedFollowers = keys
        }
        
        if let following = user.following as? [String:AnyObject]{
            let keys = Array(following.keys)
            userProfile.following = keys
        }
        
        if let requestedFollowing = user.requestedFollowing as? [String:AnyObject]{
            let keys = Array(requestedFollowing.keys)
            print(keys)
            userProfile.requestedFollowing = keys
        }
        
    }
    
    func getUserPlaylists(_ user: User){
        print("whoopie")
        print(user.playlists)
        if let uid = FIRAuth.auth()?.currentUser?.uid{
            let ref = FIRDatabase.database().reference().child("users").child(uid).child("playlists")
            ref.observe(.childAdded, with: { (snapshot) in
                if let dict = snapshot.value as? [String:AnyObject]{
                    print("user dictionary baby")
                    print(dict)
                    let play = playlist()
                    print("making a playlist boiiiiiii")
                    play.setValuesForKeys(dict)
                    if let name = play.name{
                        if !self.userPlaylist.contains(name){
                            self.userPlaylist.append(name)
                            self.userProfile.playlistDict[name] = play
                            self.userPlaylist.sort(by: { $0 < $1 })
                            DispatchQueue.main.async {
                                self.playlistCollectionView.reloadData()
                            }
                        }
                        
                    }
                }
            }, withCancel: nil)
        }
        
        playListBool = [Bool](repeating: false, count: userPlaylist.count)
    }
    
    func getUserLocations(_ user: User){
        /*
        print("in get user locations ...")
        print (self.user.locations)
        if let dict = self.user.locations as? [String:AnyObject]{
            print(" in the if let")
            for (key,value) in dict{
                print(key)
                print(value)
                let ref = FIRDatabase.database().reference(fromURL: String(describing: value))
                ref.observe(.value, with: { (snapshot) in
                    if let dictionary = snapshot.value as? [String: AnyObject] {
                        print("in the if let ")
                        print(dictionary)
                        let loc = Location()
                        loc.setValuesForKeys(dictionary)
                        self.createPinAnnotation(loc, sender: "user")
                    }
                })
            }
        }
        print("here is the end of get user locations")
        print(allUserLocations.count)
        for locs in allUserLocations{
            print("all of the users locations ...")
            print(locs.desc ?? "No Description Given For Location")
        }
         */
        
    }
    
    func createPinAnnotation(_ loc: Location, sender: String){
        print("creating pin annotations ...")
        print(loc.desc ?? "No Description Given For Location")
        let pin = PinAnnotation()
        if let title = loc.title as? String{
            print("made title")
            pin.title = title
        }
        if let desc = loc.desc as? String{
            print("made desc")
            pin.subtitle = String(desc)
        }
        if let lat = loc.latitude as? Double{
            if let long = loc.longitude as? Double{
                print("made coordinate")
                print(lat)
                print(long)
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                pin.setCoordinate(coordinate)
            }
        }
        if let dict = loc.images as? [String: AnyObject]{
            for(key,val) in dict{
                print(val)
                print(key)
                print("here we are rock me like a hurricane")
                if let innerDict = val as? [String:AnyObject]{
                    for(_,val2) in innerDict{
                        if let url = val2 as? String{
                            pin.addImageURLToURLArray(url)
                        }
                    }
                }
            }
        }
        
        if let owner = loc.owner as? String{
            pin.owner = owner
        }
        
        if let id = loc.id as? String{
            allPinAnnotations[id] = pin
            pin.id = id
        }
        if let comments = loc.comments as? [String: AnyObject]{
            for (key,_) in comments{
                pin.addComment(key)
            }
        }
        
    }
    
    func mapMyAnnotations(){
        mapSetSpan()
        for (_,pin) in allPinAnnotations{
            print("adding annotations")
            mapView.addAnnotation(pin)
        }
    }
    
    func getRandomColor() -> UIColor{
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
        if indexPath.item != 0{
            if allLocationsViewButton.tintColor == MyVariables.mainColor{
                if let cell = playlistCollectionView.cellForItem(at: indexPath as IndexPath){
                    //cell.backgroundView!.backgroundColor = UIColor(r: 59 , g: 89, b: 152)
                    cell.backgroundView!.backgroundColor = MyVariables.mainColor
                    if let label = cell.backgroundView as? UILabel{
                        label.textColor = UIColor.white
                    }
                }
                playListBool.removeAll()
                playListBool = [Bool](repeating: false, count: userPlaylist.count)
                playListBool[indexPath.item] = true
                DispatchQueue.main.async {
                    // do something
                    self.playlistCollectionView.reloadData()
                }
                let text = userPlaylist[indexPath.item]
                getLocationsForPlaylist(text)
            }
            else{
                if let cell = playlistCollectionView.cellForItem(at: indexPath as IndexPath){
                    //cell.backgroundView!.backgroundColor = UIColor(r: 59 , g: 89, b: 152)
                    cell.backgroundView!.backgroundColor = MyVariables.mainColor
                    if let label = cell.backgroundView as? UILabel{
                        label.textColor = UIColor.black
                    }
                    
                }
                globalPlaylistBool.removeAll()
                globalPlaylistBool = [Bool](repeating: false, count: globalPlaylist.count)
                globalPlaylistBool[indexPath.item] = true
                DispatchQueue.main.async {
                    self.playlistCollectionView.reloadData()
                }
                let text = globalPlaylist[indexPath.item]
                getLocationsForGlobalPlaylist(text)
            }
            
        }
    }
    
    func getLocationsForGlobalPlaylist(_ playlist: String){
        removeAnnotations()
        if let vals = allGlobalPlaylists[playlist]{
            for val in vals{
                if let anno = allGlobalPinAnnotations[val]{
                    self.mapView.addAnnotation(anno)
                }
            }
        }
    }
    
    func getLocationsForPlaylist(_ playlist: String){
        removeAnnotations()
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            //for some reason uid = nil
            return
        }
        FIRDatabase.database().reference().child("users").child(uid).child("playlists").child(playlist).child("locations").observe(.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                print(dictionary.keys)
                for(key,_) in dictionary{
                    if self.allPinAnnotations.keys.contains(key) {
                        self.mapView.addAnnotation(self.allPinAnnotations[key]!)
                    }
                }
            }
            
        }, withCancel: nil)
    }
    
    /*
     func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
     print("trying to get this cell")
     let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath as IndexPath)
     cell.backgroundColor = UIColor.purple
     cell.layer.cornerRadius = 5
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
     if allLocationsViewButton.tintColor == MyVariables.mainColor{
     print(playListBool)
     if playListBool[indexPath.item] == true{
     //cell.backgroundView?.backgroundColor = UIColor(r: 59 , g: 89, b: 152)
     cell.backgroundView!.backgroundColor = MyVariables.mainColor
     cellLabel.textColor = UIColor.white
     }
     else{
     cell.backgroundView?.backgroundColor = UIColor.white
     }
     print("in cell label")
     cellLabel.text = userPlaylist[indexPath.item]
     return cell
     }
     else if globalLocationsViewButton.tintColor == MyVariables.mainColor{
     print("here is the cell bitches")
     if globalPlaylistBool[indexPath.item] == true{
     //cell.backgroundView?.backgroundColor = UIColor(r: 59 , g: 89, b: 152)
     cell.backgroundView!.backgroundColor = MyVariables.mainColor
     cellLabel.textColor = UIColor.white
     
     }
     else{
     cell.backgroundView?.backgroundColor = UIColor.white
     }
     print("in cell label")
     cellLabel.text = globalPlaylist[indexPath.item]
     print(globalPlaylist[indexPath.item])
     return cell
     }
     return cell
     
     }
     */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if allLocationsViewButton.tintColor == MyVariables.mainColor{
            print("whoops")
            print(userPlaylist.count)
            return userPlaylist.count
        }
        else{
            print("getting count for this item")
            print(globalPlaylist.count)
            return globalPlaylist.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("trying to get this cell")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath as IndexPath)
        cell.backgroundColor = UIColor.purple
        cell.layer.cornerRadius = 5
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
        if allLocationsViewButton.tintColor == MyVariables.mainColor{
            print(playListBool)
            if playListBool[indexPath.item] == true{
                //cell.backgroundView?.backgroundColor = UIColor(r: 59 , g: 89, b: 152)
                cell.backgroundView!.backgroundColor = MyVariables.mainColor
                cellLabel.textColor = UIColor.white
            }
            else{
                cell.backgroundView?.backgroundColor = UIColor.white
            }
            print("in cell label")
            cellLabel.text = userPlaylist[indexPath.item]
            return cell
        }
        else if globalLocationsViewButton.tintColor == MyVariables.mainColor{
            print("here is the cell bitches")
            if globalPlaylistBool[indexPath.item] == true{
                //cell.backgroundView?.backgroundColor = UIColor(r: 59 , g: 89, b: 152)
                cell.backgroundView!.backgroundColor = MyVariables.mainColor
                cellLabel.textColor = UIColor.white
                
            }
            else{
                cell.backgroundView?.backgroundColor = UIColor.white
            }
            print("in cell label")
            cellLabel.text = globalPlaylist[indexPath.item]
            print(globalPlaylist[indexPath.item])
            return cell
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let font = UIFont.boldSystemFont(ofSize: 16)
        let fontAttributes = [NSFontAttributeName: font] // it says name, but a UIFont works
        var myText:String = ""
        if allLocationsViewButton.tintColor == MyVariables.mainColor{
            print("getting size man")
            myText = userPlaylist[indexPath.item]
        }
        else{
            print("getting size for this item")
            myText = globalPlaylist[indexPath.item]
        }
        var size = (myText as NSString).size(attributes: fontAttributes)
        size.height = 50
        size.width += 10
        return size
    }
    func removeAnnotations(){
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
    }
    
    
    func showPlaylistCollectionView(){
        DispatchQueue.main.async {
            self.playlistCollectionView.reloadData()
        }
        playlistCollectionView.alpha = 0
        view.addSubview(playlistCollectionView)
        playlistCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        playlistCollectionView?.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        playlistCollectionView?.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        playlistCollectionView?.heightAnchor.constraint(equalToConstant: 60).isActive = true
        if playlistCollectionView.alpha == 0{
            UIView.animate(withDuration: TimeInterval(1.0), animations: {
                self.playlistCollectionView.alpha = 1.0
                self.navigationController?.isNavigationBarHidden = false
            }) { (true) in
                print("completed animations")
            }
        }
    }
    
}

struct Friend {
    var name, picture: String?
}

