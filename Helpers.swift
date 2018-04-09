//
//  Helpers.swift
//  Hoop
//
//  Created by james oeth on 3/18/18.
//  Copyright © 2018 jamesOeth. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
}

extension UIView {
    func addConstraintsWithFormat(_ format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

extension UIColor {
    static func rgb(_ red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

public extension UIView {
    
    /**
     Fade in a view with a duration
     
     - parameter duration: custom animation duration
     */
    func fadeIn(_ duration: TimeInterval = 0.5) {
        UIView.animate(withDuration: duration, animations: {
            print("running the animation")
            print(self.alpha)
            self.alpha = 1.0
            print(self.alpha)
        })
    }
    
    /**
     Fade out a view with a duration
     
     - parameter duration: custom animation duration
     */
    func fadeOut(_ duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: duration, animations: {
            print("running the animation")
            print(self.alpha)
            self.alpha = 0.0
            print(self.alpha)
            
        })
    }
    
}

public extension String {
    
    func contains(_ find: String) -> Bool{
        return self.range(of: find) != nil
    }
    
    func containsIgnoringCase(_ find: String) -> Bool{
        return self.range(of: find, options: NSString.CompareOptions.caseInsensitive) != nil
    }
}

public extension UIView {
    
    /**
     Removes all constraints for this view
     */
    func removeConstraints() {
        if let superview = self.superview {
            var list = [NSLayoutConstraint]()
            for constraint in superview.constraints {
                if constraint.firstItem as? UIView == self || constraint.secondItem as? UIView == self {
                    list.append(constraint)
                }
            }
            superview.removeConstraints(list)
        }
        self.removeConstraints(self.constraints)
    }
}

struct MyVariables {
    //static var mainColor = UIColor(r: 255 , g: 102, b: 0) //this is the origional orange
    //static var secondaryColor = UIColor(r: 255 , g: 80, b: 0) // this is the second origional orange
    
    
    //this i the one baby!!!!
    //this is the blue color scheme
    static var mainColor = UIColor(r: 63 , g: 176 , b: 172) //cool teal
    static var secondaryColor = UIColor(r: 23 , g: 62 , b: 67) // cool dark color that goes with the teal
    static var tierciaryColor = UIColor(r: 23 , g: 62 , b: 67) // cool dark color that goes with the teal
    //static var buttonColors = UIColor(r: 59 , g: 89, b: 152)//origional button color
    static var buttonColors = UIColor(r: 23 , g: 62 , b: 67)
    static var backgroundColor = UIColor(r: 250 , g: 250, b: 250)
    static var pinColor = UIColor(r: 245 , g: 37 , b: 73)
    static var hilightColor = UIColor(r: 250 , g: 229 , b: 150)
    static var button = UIColor(r: 30 , g: 69 , b: 74)
    
    
    /*
     static var mainColor = UIColor(r: 246 , g: 144, b: 0) //cool teal  (249,173,1)
     //static var secondaryColor = UIColor(r: 52 , g: 41 , b: 37) // cool dark color that goes with the teal
     // static var tierciaryColor = UIColor(r: 195 , g: 27 , b: 0) // cool dark color that goes with the teal
     static var tierciaryColor = UIColor(r: 246 , g: 86, b: 0)// cool dark color that goes with the teal
     //static var secondaryColor = UIColor(r: 11 , g: 77, b: 97) // cool blue color
     //static var secondaryColor = UIColor(r: 87 , g: 40, b: 58)
     static var secondaryColor = UIColor(r: 64 , g: 81 , b: 89) // cool dark color that goes with the teal
     //static var secondaryColor = UIColor(r: 70 , g: 70 , b: 70) // cool dark color that goes with the teal
     //static var buttonColors = UIColor(r: 59 , g: 89, b: 152)//origional button color
     static var buttonColors = UIColor(r: 23 , g: 62 , b: 67)
     static var backgroundColor = UIColor(r: 250 , g: 250, b: 250)
     static var pinColor = UIColor(r: 245 , g: 37 , b: 73)
     static var hilightColor = UIColor(r: 250 , g: 229 , b: 150)
     static var button = UIColor(r: 30 , g: 69 , b: 74)
     */
    
    /*
     //hopefully this is the desert color scheme
     static var mainColor = UIColor(r: 207 , g: 82 , b: 48) //cool teal 207,82,48
     static var secondaryColor = UIColor(r: 110 , g: 53 , b: 44) // cool dark color that goes with the teal 110,53,44
     //static var buttonColors = UIColor(r: 59 , g: 89, b: 152)//origional button color
     static var buttonColors = UIColor(r: 23 , g: 62 , b: 67)
     static var backgroundColor = UIColor(r: 227 , g: 197, b: 152) //background deserty color 227,197,152
     static var pinColor = UIColor(r: 245 , g: 154 , b: 68) // (245,154,68) pumpkin orange color
     static var hilightColor = UIColor(r: 110 , g: 97 , b: 47) // 110,97,47) greenish color
     static var button = UIColor(r: 110 , g: 53 , b: 44)
     */
    
    /*
     //hopefully this is the desert color scheme
     static var mainColor = UIColor(r: 233 , g: 122 , b: 46) //cool teal (233,122,46)
     static var secondaryColor = UIColor(r: 131 , g: 78 , b: 113) // cool dark color that goes with the teal (131,78,113)
     //static var buttonColors = UIColor(r: 59 , g: 89, b: 152)//origional button color
     static var buttonColors = UIColor(r: 0 , g: 170 , b: 160) // (136,213,210)
     static var backgroundColor = UIColor(r: 227 , g: 197, b: 152) //background deserty color 227,197,152
     static var pinColor = UIColor(r: 245 , g: 37 , b: 73) // (245,154,68) pumpkin orange color
     static var hilightColor = UIColor(r: 110 , g: 97 , b: 47) // 110,97,47) greenish color
     static var button =  UIColor(r: 131 , g: 78 , b: 113) // (136,213,210)  UIColor(r: 233 , g: 122 , b: 46)
     */
    /*
     //hopefully this is the desert color scheme
     static var mainColor = UIColor(r: 65 , g: 146 , b: 74) //cool teal (233,122,46)
     static var secondaryColor = UIColor(r: 131 , g: 78 , b: 113) // cool dark color that goes with the teal (131,78,113)
     //static var buttonColors = UIColor(r: 59 , g: 89, b: 152)//origional button color
     static var buttonColors = UIColor(r: 0 , g: 170 , b: 160) // (136,213,210)
     static var backgroundColor = UIColor(r: 227 , g: 197, b: 152) //background deserty color 227,197,152
     static var pinColor = UIColor(r: 0 , g: 128 , b: 128) // (245,154,68) pumpkin orange color
     static var hilightColor = UIColor(r: 110 , g: 97 , b: 47) // 110,97,47) greenish color
     static var button =  UIColor(r: 79 , g: 13 , b: 4) // (136,213,210)  UIColor(r: 233 , g: 122 , b: 46)
     */
    /*
     leaves color panel
     //hopefully this is the desert color scheme
     static var mainColor = UIColor(r: 234 , g: 184 , b: 0)  //cool teal (233,122,46)
     static var secondaryColor = UIColor(r: 219 , g: 130 , b: 0) // cool dark color that goes with the teal (131,78,113)
     //static var buttonColors = UIColor(r: 59 , g: 89, b: 152)//origional button color
     static var buttonColors = UIColor(r: 0 , g: 170 , b: 160) // (136,213,210)
     static var backgroundColor = UIColor(r: 227 , g: 197, b: 152) //background deserty color 227,197,152
     static var pinColor = UIColor(r: 80 , g: 129 , b: 4) // (245,154,68) pumpkin orange color
     static var hilightColor = UIColor(r: 110 , g: 97 , b: 47) // 110,97,47) greenish color
     static var button =  UIColor(r: 219 , g: 130 , b: 0) //UIColor(r: 182 , g: 66 , b: 1) // (136,213,210)  UIColor(r: 233 , g: 122 , b: 46)
     */
    /*
     static var mainColor = UIColor(r: 7 , g: 136 , b: 155)  //cool teal (233,122,46)
     static var secondaryColor = UIColor(r: 7 , g: 136 , b: 155) // cool dark color that goes with the teal (131,78,113)
     //static var buttonColors = UIColor(r: 59 , g: 89, b: 152)//origional button color
     static var buttonColors = UIColor(r: 0 , g: 170 , b: 160) // (136,213,210)
     static var backgroundColor = UIColor(r: 227 , g: 197, b: 152) //background deserty color 227,197,152
     static var pinColor = UIColor(r: 131 , g: 78 , b: 113) // (245,154,68) pumpkin orange color
     static var hilightColor = UIColor(r: 110 , g: 97 , b: 47) // 110,97,47) greenish color
     static var button =  UIColor(r: 227 , g: 114 , b: 34) //UIColor(r: 182 , g: 66 , b: 1) // (136,213,210)
     */
    /*
     static var mainColor = UIColor(r: 233 , g: 122 , b: 46) //cool teal (233,122,46)
     static var secondaryColor = UIColor(r: 203 , g: 92 , b: 16) // cool dark color that goes with the teal (131,78,113)
     //static var buttonColors = UIColor(r: 59 , g: 89, b: 152)//origional button color
     static var buttonColors = UIColor(r: 204 , g: 103 , b: 194) // (136,213,210)
     static var backgroundColor = UIColor(r: 227 , g: 197, b: 152) //background deserty color 227,197,152
     static var pinColor = UIColor(r: 245 , g: 37 , b: 73) // (245,154,68) pumpkin orange color
     static var hilightColor = UIColor(r: 110 , g: 97 , b: 47) // 110,97,47) greenish color
     static var button =  UIColor(r: 93 , g: 95 , b: 104) // (136,213,210)  UIColor(r: 233 , g: 122 , b: 46)
     */
    /*
     //facebook and starbucks colors
     static var mainColor = UIColor(r: 0 , g: 112 , b: 74) //cool teal (233,122,46)
     static var secondaryColor = UIColor(r: 0 , g: 112 , b: 74) // cool dark color that goes with the teal (131,78,113)
     //static var buttonColors = UIColor(r: 59 , g: 89, b: 152)//origional button color
     static var buttonColors = UIColor(r: 204 , g: 103 , b: 194) // (136,213,210)
     static var backgroundColor = UIColor(r: 227 , g: 197, b: 152) //background deserty color 227,197,152
     static var pinColor = UIColor(r: 184 , g: 151 , b: 120) // (245,154,68) pumpkin orange color
     static var hilightColor = UIColor(r: 110 , g: 97 , b: 47) // 110,97,47) greenish color
     static var button =  UIColor(r: 59 , g: 89 , b: 152) // (136,213,210)  UIColor(r: 233 , g: 122 , b: 46)
     */
    /*
     //hopefully this is the desert color scheme
     static var mainColor = UIColor(r: 191 , g: 93 , b: 35) //cool teal (233,122,46)
     static var secondaryColor = UIColor(r: 46 , g: 17 , b: 39) // cool dark color that goes with the teal (131,78,113) 46,17,39
     //static var buttonColors = UIColor(r: 59 , g: 89, b: 152)//origional button color
     static var buttonColors = UIColor(r: 191 , g: 93 , b: 35) // (136,213,210)
     static var backgroundColor = UIColor(r: 250 , g: 250, b: 250) //background deserty color 227,197,152
     static var pinColor = UIColor(r: 245 , g: 37 , b: 73) // (245,154,68) pumpkin orange color
     static var hilightColor = UIColor(r: 191 , g: 93 , b: 35) // 110,97,47) greenish color #bf5d23(191,93,35)
     static var button =  UIColor(r: 46 , g: 17 , b: 39) // (136,213,210)  UIColor(r: 233 , g: 122 , b: 46)
     */
}

extension String {
    
    //To check text field or String is blank or not
    var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
            return trimmed.isEmpty
        }
    }
    
    //Validate Email
    var isEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil
        } catch {
            return false
        }
    }
    
    var isPhoneNumber: Bool {
        let charcterSet  = CharacterSet(charactersIn: "+0123456789").inverted
        let inputString = self.components(separatedBy: charcterSet)
        let filtered = inputString.joined(separator: "")
        return  self == filtered
    }
    
    func containsString(find: String) -> Bool{
        if self.lowercased().contains(find.lowercased()) {
            return true
        } else {
            return false
        }
    }
    
    /*
     //validate PhoneNumber
     var isPhoneNumber: Bool {
     let charcter  = CharacterSet(charactersIn: "+0123456789").inverted
     var filtered:NSString!
     let inputString:[NSString] = self.components(separatedBy: charcter)
     filtered = inputString.componentsJoined(by: "") as NSString!
     return  self == filtered
     
     }
     */
}

extension Error {
    var code: Int { return (self as NSError).code }
    var domain: String { return (self as NSError).domain }
}
