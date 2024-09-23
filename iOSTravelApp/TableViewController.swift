////
////  TableViewController.swift
////  iOSTravelApp
////
////  Created by Max Havens on 9/22/24.
////

import UIKit

class TableViewController: UITableViewController {

    // Lazy instantiation of the TravelModel shared instance
    lazy var travelModel: TravelModel = {
        return TravelModel.sharedInstance()!
    }()
    
    // Array to hold sorted destinations
    var sortedDestinations: [(name: String, date: Date)] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Sort the destinations by date when the view loads
        sortDestinationsByDate()
        
        // Reload the table to reflect the sorted data
        tableView.reloadData()
    }

    // Function to sort destinations by date
    private func sortDestinationsByDate() {
        // Get all destination names and their associated dates
        var destinationsWithDates: [(name: String, date: Date)] = []

        for i in 0..<travelModel.numberOfDestinations() {
            if let destinationName = travelModel.getDestinationName(for: i), // Unwrap the destination name
               let destinationDate = travelModel.getDestinationDate(withName: destinationName) {
                destinationsWithDates.append((name: destinationName, date: destinationDate))
            }
        }

        // Sort the destinations by their date
        sortedDestinations = destinationsWithDates.sorted(by: { $0.date < $1.date })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedDestinations.count // Use sortedDestinations count
    }

    // Helper function to format the date
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium // Format as "Sep 22, 2024"
        return dateFormatter.string(from: date)
    }

    // CELLS
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue the reusable cell with identifier "TravelNameCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: "TravelNameCell", for: indexPath)

        // Get the sorted destination for the current row
        let destination = sortedDestinations[indexPath.row]
        
        // Format the date to display it nicely
        let formattedDate = formatDate(destination.date)
        
        // Configure the cell with the destination name (main text) and the date (subtitle)
        cell.textLabel?.text = destination.name
        cell.detailTextLabel?.text = formattedDate

        return cell
    }

    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    

    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTripDetails" {
            if let destinationVC = segue.destination as? TripDetailViewController {
                // Get the selected trip
                if let indexPath = tableView.indexPathForSelectedRow {
                    let selectedTrip = sortedDestinations[indexPath.row]
                    
                    // Pass data to TripDetailViewController
                    destinationVC.tripName = selectedTrip.name
                    destinationVC.tripDescription = travelModel.getDestinationDescription(withName: selectedTrip.name)
                    destinationVC.tripDate = selectedTrip.date
                }
            }
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
class TripListViewController: UITableViewController {
    
    var trips: [TripModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TripListViewController viewDidLoad")
        title = "My Trips"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TripCell")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTrip))
        
        loadTrips()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("TripListViewController viewWillAppear")
        loadTrips()
        tableView.reloadData()
    }
    
    func loadTrips() {
        print("Loading trips")
        trips = TripManager.shared().getAllTrips().sorted { $0.startDate < $1.startDate }
        print("Loaded \(trips.count) trips")
        for trip in trips {
            print("Trip: \(trip.destination), Start: \(trip.startDate), End: \(trip.endDate), Upcoming: \(trip.isUpcoming)")
        }
    }
    
    @objc func addNewTrip() {
        print("Add new trip tapped")
        let addTripVC = AddTripViewController()
        addTripVC.tripAddedCallback = { [weak self] in
            print("Trip added callback received")
            self?.loadTrips()
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                print("Table view reloaded")
            }
        }
        let navController = UINavigationController(rootViewController: addTripVC)
        present(navController, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let upcomingTrips = trips.filter { $0.isUpcoming }
        let pastTrips = trips.filter { !$0.isUpcoming }
        print("numberOfRowsInSection - Upcoming trips: \(upcomingTrips.count), Past trips: \(pastTrips.count)")
        return section == 0 ? upcomingTrips.count : pastTrips.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TripCell", for: indexPath)
        
        let upcomingTrips = trips.filter { $0.isUpcoming }
        let pastTrips = trips.filter { !$0.isUpcoming }
        let trip = indexPath.section == 0 ? upcomingTrips[indexPath.row] : pastTrips[indexPath.row]
        
        cell.textLabel?.text = trip.destination
        cell.detailTextLabel?.text = "\(formatDateForDisplay(trip.startDate)) - \(formatDateForDisplay(trip.endDate))"
        
        print("Configuring cell for trip: \(trip.destination), Upcoming: \(trip.isUpcoming)")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Upcoming Trips" : "Past Trips"
    }
    
    private func formatDateForDisplay(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

