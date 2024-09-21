//
//  ViewController.swift
//  iOSTravelApp
//
//  Created by Max Havens on 9/20/24.
//

import UIKit

class TravelDetailViewController: UIViewController, UIScrollViewDelegate {

    // Store the name of the destination
    var destinationName: String?
    
    // Lazy instantiation of the shared TravelModel instance
    lazy var travelModel: TravelModel = {
        return TravelModel.sharedInstance()!
    }()
    
    // Lazy instantiation for the image view
    lazy private var destinationImageView: UIImageView? = {
        if let name = self.destinationName {
            return UIImageView(image: self.travelModel.getDestinationImage(withName: name))
        }
        return nil
    }()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup the view using the destination name
        if let name = destinationName {
            title = name
            descriptionLabel.text = travelModel.getDestinationDescription(withName: name)
            
            // Set up the scroll view with the image if available
            if let imageView = destinationImageView, let size = imageView.image?.size {
                scrollView.addSubview(imageView)
                scrollView.contentSize = size
                scrollView.minimumZoomScale = 0.1
                scrollView.delegate = self
            }
        }
    }

    // Implement zooming for UIScrollViewDelegate
    @objc(viewForZoomingInScrollView:) func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.destinationImageView
    }
}






