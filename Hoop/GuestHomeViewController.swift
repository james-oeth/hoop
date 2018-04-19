//
//  GuestHomeViewController.swift
//  Hoop
//
//  Created by james oeth on 4/10/18.
//  Copyright © 2018 jamesOeth. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import CoreFoundation
import Firebase

class GuestHomeViewController: UIViewController , CLLocationManagerDelegate, MKMapViewDelegate{
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
    var currentCoordinate: MKCoordinateRegion?
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
    //setup the settings launcher variable
    lazy var settingsLauncher: SettingsLauncher = {
        let launcher = SettingsLauncher()
        launcher.GuestHomeViewController = self
        return launcher
    }()

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        UIView.setAnimationsEnabled(true)
        self.navigationController?.viewControllers = [self]
        
    }
    
    
    //view did load function
    override func viewDidLoad() {
        super.viewDidLoad()
        //set the button constant so that the buttons are sized perfectly for every screen
        buttonConstant = CGFloat((view.frame.width-20-(view.frame.width/3.5))/5)
        buttonConstant += 5
        //get the current users locations and playlists
        getUsersLocationsAndPlaylists()
        //make this the bottom view controller on the navigation stack
        self.navigationController?.viewControllers = [self]
        //make the bool array
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
        navigationItem.title = "Home"
        currentLabel = UILabel(frame: CGRect(x: 0,y: 0,width: view.frame.width-32, height: view.frame.height))
        currentLabel.text = "Find A Game"
        currentLabel.textColor = UIColor.white
        currentLabel.font = UIFont.systemFont(ofSize: 20)
        navigationItem.titleView = currentLabel
        navigationController?.navigationBar.isTranslucent = false
        //setup the two bar button items
        setupNavBarButtons()
       
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
            self.navigationController?.viewControllers = [loginController]
            self.navigationController?.pushViewController(loginController, animated: true)        }
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
       //setup the settings launcher
    func setupNavBarButtons(){
        let searchImage = UIImage(named: "search_icon")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
        let moreButton = UIImage(named: "nav_more_icon")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        let moreBarButtonItem = UIBarButtonItem(image: moreButton, style: .plain, target: self, action: #selector(handleMore))
        navigationItem.rightBarButtonItems = [moreBarButtonItem, searchBarButtonItem]
        
    }
    
    //setup of all of the button
    
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
    
    //
    ///
    ////
    /////
    //////handle different buttons being tapped
    /////
    ////
    ///
    //
    
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
        mapMyAnnotations()
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
        mapView.addAnnotation(pin)
    }
    
    func mapMyAnnotations(){
        print("in map my annotations")
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
