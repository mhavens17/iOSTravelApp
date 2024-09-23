import UIKit

class TripDetailViewController: UIViewController {
    
    var trip: TripModel?
    
    private let destinationLabel = UILabel()
    private let dateRangeLabel = UILabel()
    private let favoriteButton = UIButton()
    private let itineraryButton = UIButton()
    private let countdownLabel = UILabel()  // Countdown Label
    
    private var countdownTimer: Timer?  // Timer to update the countdown
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        updateUI()
        startCountdown()  // Start the countdown when the view loads
    }
    
    private func setupUI() {
        // Destination Label
        destinationLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(destinationLabel)
        
        // Date Range Label
        dateRangeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dateRangeLabel)
        
        // Favorite Button
        favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .selected)
        favoriteButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(favoriteButton)
        
        // Countdown Label
        countdownLabel.translatesAutoresizingMaskIntoConstraints = false
        countdownLabel.textAlignment = .center
        countdownLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        view.addSubview(countdownLabel)
        
        NSLayoutConstraint.activate([
            destinationLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            destinationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            destinationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            dateRangeLabel.topAnchor.constraint(equalTo: destinationLabel.bottomAnchor, constant: 10),
            dateRangeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dateRangeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            favoriteButton.topAnchor.constraint(equalTo: dateRangeLabel.bottomAnchor, constant: 20),
            favoriteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            countdownLabel.topAnchor.constraint(equalTo: favoriteButton.bottomAnchor, constant: 20),
            countdownLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // Itinerary Button
        itineraryButton.setTitle("How to plan an itinerary", for: .normal)
        itineraryButton.setTitleColor(.systemBlue, for: .normal)
        itineraryButton.addTarget(self, action: #selector(showItinerary), for: .touchUpInside)
        itineraryButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(itineraryButton)

        NSLayoutConstraint.activate([
            itineraryButton.topAnchor.constraint(equalTo: countdownLabel.bottomAnchor, constant: 20),
            itineraryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func updateUI() {
        guard let trip = trip else { return }
        
        destinationLabel.text = trip.destination
        dateRangeLabel.text = "\(formatDate(trip.startDate)) - \(formatDate(trip.endDate))"
        favoriteButton.isSelected = trip.isFavorite
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    @objc private func toggleFavorite() {
        guard let trip = trip else { return }
        trip.isFavorite.toggle()
        favoriteButton.isSelected = trip.isFavorite
        TripManager.shared().updateTrip(trip)
    }
    
    @objc private func showItinerary() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let itineraryVC = storyboard.instantiateViewController(withIdentifier: "ItineraryViewController") as? ItineraryViewController {
            // Pass data if necessary
            itineraryVC.itinerary = trip?.itinerary
            navigationController?.pushViewController(itineraryVC, animated: true)
        }
    }

    // MARK: - Countdown Timer Logic
    
    private func startCountdown() {
        updateCountdownLabel()  // Initial update
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdownLabel), userInfo: nil, repeats: true)
    }
    
    @objc private func updateCountdownLabel() {
        guard let trip = trip else { return }
        
        let now = Date()
        let timeInterval = trip.startDate.timeIntervalSince(now)
        
        if timeInterval > 0 {
            let days = Int(timeInterval) / (24 * 3600)
            let hours = (Int(timeInterval) % (24 * 3600)) / 3600
            let minutes = (Int(timeInterval) % 3600) / 60
            let seconds = Int(timeInterval) % 60
            
            countdownLabel.text = String(format: "%02d days %02d:%02d:%02d until trip", days, hours, minutes, seconds)
        } else {
            countdownLabel.text = "Your trip has started!"
            countdownTimer?.invalidate()  // Stop the timer if the trip has already started
        }
    }
    
    // Stop the timer when the view is deallocated to prevent memory leaks
    deinit {
        countdownTimer?.invalidate()
    }
}
