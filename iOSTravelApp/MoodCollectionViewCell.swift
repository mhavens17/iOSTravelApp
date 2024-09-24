//
//  MoodCollectionViewCell.swift
//  iOSTravelApp
//
//  Created by Lyle Dev, Loaner on 9/23/24.
//

import UIKit

class MoodCollectionViewCell: UICollectionViewCell {
// set mood label function
    @IBOutlet weak var moodName: UILabel!
    func configure(with mood: String){
        moodName.text = mood
    }
    
}
