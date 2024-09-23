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
    @IBOutlet weak var isPlanning: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        // Display the itinerary (you can add your own UI elements for this)
        if let itinerary = itinerary {
            print("Itinerary: \(itinerary.joined(separator: "\n"))")
        }
    }
    @IBAction func donePlanning(_ sender: Any) {
        //        cast sender as switch and set label according to the state
        if let switchSender = sender as? UISwitch {
            if switchSender.isOn {
                isPlanning.text = "Finished Planning"
            } else {
                isPlanning.text = "Planning"
            }
        }
    }
}
