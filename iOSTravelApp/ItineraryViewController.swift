//
//  ItineraryViewController.swift
//  iOSTravelApp
//
//  Created by Max Havens on 9/22/24.
//

// ItineraryViewController.swift

import UIKit

class ItineraryViewController: UIViewController {

    //initilize relevant variables for the view
    var currStrength: Int = 1
    var itinerary: [String]?
    
    @IBOutlet weak var moodStrength: UILabel!
    @IBOutlet weak var isPlanning: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load default value for mood strength
        moodStrength.text = "Mood Strength: \(currStrength)"
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
    @IBAction func step(_ sender: Any) {
        // Safely cast sender to UIStepper
        if let stepper = sender as? UIStepper {
            // Update the moodStrength variable with the stepper's current value
            currStrength = Int(stepper.value)
            
            // Update the label
            moodStrength.text = "Mood Strength: \(currStrength)"
        }
    }
}
