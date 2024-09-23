//
//  ItineraryViewController.swift
//  iOSTravelApp
//
//  Created by Max Havens on 9/22/24.
//

// ItineraryViewController.swift

import UIKit

class ItineraryViewController: UIViewController {
    
    var itinerary: [String]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        // Display the itinerary (you can add your own UI elements for this)
        if let itinerary = itinerary {
            print("Itinerary: \(itinerary.joined(separator: "\n"))")
        }
    }
}
