//
//  UserProfile.swift
//  sherpaApp
//
//  Created by james oeth on 12/28/16.
//  Copyright © 2016 jamesOeth. All rights reserved.
//

import Foundation
import UIKit

class UserProfile: NSObject {
    var id: String?
    var firstName: String?
    var lastName: String??
    var email: String??
    var profileImageUrl: String?
    var profileImage:UIImage?
    var carLat: Double?
    var carLong: Double?
    var username: String?
    var locations: [String:PinAnnotation]?
    var playlists: [String]?
    var following: [String] = []
    var followers: [String] = []
    var requestedFollowers: [String] = []
    var requestedFollowing: [String] = []
    var contactName: String?
    var bio: String?
    var playlistDict: [String:playlist] = [String: playlist]()

}
