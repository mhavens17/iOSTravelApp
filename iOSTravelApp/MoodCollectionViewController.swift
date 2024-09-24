//
//  MoodCollectionViewController.swift
//  iOSTravelApp
//
//  Created by Lyle Dev, Loaner on 9/23/24.
//

import UIKit

private let reuseIdentifier = "Cell"

class MoodCollectionViewController: UICollectionViewController {
//   Set available moods
    let dataSource: [String] = ["Happy", "Sad", "Excited", "Upset", "Scared", "Exuberant"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
//    Create the correct amount of cells
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
//    Modify cell labels
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if let moodCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? MoodCollectionViewCell {
            moodCell.configure(with: dataSource[indexPath.row])
            
            cell = moodCell
        }
        
        return cell
    }
//    output selected mood to console
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected Mood: \(dataSource[indexPath.row])")
    }
}
