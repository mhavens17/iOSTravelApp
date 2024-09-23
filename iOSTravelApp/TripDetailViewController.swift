import UIKit

class TripDetailViewController: UIViewController {
    
    var trip: TripModel?
    
    private let destinationLabel = UILabel()
    private let dateRangeLabel = UILabel()
    private let favoriteButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        updateUI()
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
        
        NSLayoutConstraint.activate([
            destinationLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            destinationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            destinationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            dateRangeLabel.topAnchor.constraint(equalTo: destinationLabel.bottomAnchor, constant: 10),
            dateRangeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dateRangeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            favoriteButton.topAnchor.constraint(equalTo: dateRangeLabel.bottomAnchor, constant: 20),
            favoriteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
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
        guard var trip = trip else { return }
        trip.isFavorite.toggle()
        favoriteButton.isSelected = trip.isFavorite
        TripManager.shared().updateTrip(trip)
    }
}
