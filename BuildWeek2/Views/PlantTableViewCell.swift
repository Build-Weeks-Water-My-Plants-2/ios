//
//  PlantTableViewCell.swift
//  BuildWeek2
//
//  Created by John Holowesko on 6/23/20.
//  Copyright © 2020 Clayton Watkins. All rights reserved.
//

import UIKit

class PlantTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var plantImageView: UIImageView!
    @IBOutlet private weak var plantLabel: UILabel!
    
    // MARK: - Properties

    var plant: Plant? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Private Function
    
    private func updateViews() {
        guard let plant = plant else { return }
        plantLabel.text = plant.nickname
    }
}
