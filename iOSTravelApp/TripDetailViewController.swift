import UIKit

class TripDetailViewController: UIViewController {
    // Create outlets for the UI elements to show trip details
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    // Variables to hold the passed data
    var tripName: String?
    var tripDescription: String?
    var tripDate: Date?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the labels with the passed data
        nameLabel.text = tripName
        descriptionLabel.text = tripDescription
        
        if let date = tripDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateLabel.text = dateFormatter.string(from: date)
        }
    }
}
