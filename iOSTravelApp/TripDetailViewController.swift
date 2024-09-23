import UIKit

class TripDetailViewController: UIViewController {

    var trip: TripModel?
    private var countdownTimer: Timer?

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let destinationLabel = UILabel()
    private let dateRangeLabel = UILabel()
    private let countdownLabel = UILabel()
    private let favoriteButton = UIButton(type: .system)
    private let segmentedControl = UISegmentedControl(items: ["Itinerary", "Notes", "Packing List"])
    private let contentTextView = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUI()
        startCountdownTimer()
    }

    private func setupUI() {
        view.backgroundColor = .white

        // Scroll View
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        // Content View
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        // Destination Label
        destinationLabel.font = UIFont.boldSystemFont(ofSize: 24)
        destinationLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(destinationLabel)

        // Date Range Label
        dateRangeLabel.font = UIFont.systemFont(ofSize: 16)
        dateRangeLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dateRangeLabel)

        // Countdown Label
        countdownLabel.font = UIFont.systemFont(ofSize: 16)
        countdownLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(countdownLabel)

        // Favorite Button
        favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .selected)
        favoriteButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(favoriteButton)

        

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            destinationLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            destinationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            destinationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            dateRangeLabel.topAnchor.constraint(equalTo: destinationLabel.bottomAnchor, constant: 10),
            dateRangeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dateRangeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            countdownLabel.topAnchor.constraint(equalTo: dateRangeLabel.bottomAnchor, constant: 10),
            countdownLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            countdownLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            favoriteButton.topAnchor.constraint(equalTo: countdownLabel.bottomAnchor, constant: 20),
            favoriteButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

           
        ])
    }

    private func updateUI() {
        guard let trip = trip else { return }
        
        destinationLabel.text = trip.destination
        dateRangeLabel.text = "\(formatDate(trip.startDate)) - \(formatDate(trip.endDate))"
        favoriteButton.isSelected = trip.isFavorite
        updateContent()
        updateCountdownLabel()
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    private func startCountdownTimer() {
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.updateCountdownLabel()
        }
    }

    private func updateCountdownLabel() {
        guard let trip = trip else { return }
        
        let now = Date()
        let calendar = Calendar.current
        
        if now < trip.startDate {
            // Trip hasn't started yet
            let components = calendar.dateComponents([.day, .hour, .minute, .second], from: now, to: trip.startDate)
            countdownLabel.text = String(format: "%d days, %02d:%02d:%02d until trip starts", components.day ?? 0, components.hour ?? 0, components.minute ?? 0, components.second ?? 0)
        } else if now >= trip.startDate && now <= trip.endDate {
            // Trip is ongoing
            let components = calendar.dateComponents([.day, .hour, .minute, .second], from: now, to: trip.endDate)
            countdownLabel.text = String(format: "%d days, %02d:%02d:%02d until trip ends", components.day ?? 0, components.hour ?? 0, components.minute ?? 0, components.second ?? 0)
        } else {
            // Trip has ended
            countdownLabel.text = "Trip has ended"
            countdownTimer?.invalidate()
        }
    }

    @objc private func toggleFavorite() {
        guard var trip = trip else { return }
        trip.isFavorite.toggle()
        favoriteButton.isSelected = trip.isFavorite
        TripManager.shared().updateTrip(trip)
    }

    @objc private func segmentChanged() {
        updateContent()
    }

    private func updateContent() {
        guard let trip = trip else { return }
        
        switch segmentedControl.selectedSegmentIndex {
        case 0: // Itinerary
            contentTextView.text = trip.itinerary.joined(separator: "\n")
        case 1: // Notes
            contentTextView.text = trip.notes ?? "No notes yet. Add some notes here!"
        case 2: // Packing List
            contentTextView.text = trip.packingList.map { "\($0.name) - \($0.isPacked ? "Packed" : "Not Packed")" }.joined(separator: "\n")
        default:
            break
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveContent()
        countdownTimer?.invalidate()
    }

    private func saveContent() {
        guard var trip = trip else { return }
        
        switch segmentedControl.selectedSegmentIndex {
        case 0: // Itinerary
            trip.itinerary = contentTextView.text.components(separatedBy: .newlines)
        case 1: // Notes
            trip.notes = contentTextView.text
        case 2: // Packing List
            // For simplicity, we're not updating the packing list here.
            // In a real app, you'd want to parse the text and update the packingList array.
            break
        default:
            break
        }
        
        TripManager.shared().updateTrip(trip)
    }
}
