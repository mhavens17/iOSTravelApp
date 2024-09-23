//
//  AddTripViewController.swift
//  iOSTravelApp
//
//  Created by Claudia on 9/22/24.
//

import UIKit

class AddTripViewController: UIViewController {
    
    var tripAddedCallback: (() -> Void)?
    
    private let destinationTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Destination"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let startDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let endDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Trip", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(destinationTextField)
        view.addSubview(startDatePicker)
        view.addSubview(endDatePicker)
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            destinationTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            destinationTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            destinationTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            startDatePicker.topAnchor.constraint(equalTo: destinationTextField.bottomAnchor, constant: 20),
            startDatePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            startDatePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            endDatePicker.topAnchor.constraint(equalTo: startDatePicker.bottomAnchor, constant: 20),
            endDatePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            endDatePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            addButton.topAnchor.constraint(equalTo: endDatePicker.bottomAnchor, constant: 20),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        addButton.addTarget(self, action: #selector(addTripTapped), for: .touchUpInside)
    }
    
    @objc private func addTripTapped() {
        guard let destination = destinationTextField.text, !destination.isEmpty else {
            showAlert(message: "Please enter a destination")
            return
        }
        
        let startDate = startDatePicker.date
        let endDate = endDatePicker.date
        
        if startDate > endDate {
            showAlert(message: "End date must be after start date")
            return
        }
        
        print("Attempting to save trip: \(destination), Start: \(startDate), End: \(endDate)")
        TripManager.shared().saveTrip(withDestination: destination, start: startDate, end: endDate)
        print("Trip saved, calling callback")
        tripAddedCallback?()
        print("Callback called, dismissing view controller")
        dismiss(animated: true) {
            print("AddTripViewController dismissed")
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
