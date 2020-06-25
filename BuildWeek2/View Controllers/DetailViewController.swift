//
//  DetailViewController.swift
//  BuildWeek2
//
//  Created by Clean Mac on 6/22/20.
//  Copyright © 2020 Clayton Watkins. All rights reserved.
//

import UIKit




class DetailViewController: UIViewController {
    
    var apiController: APIController?
      var plantCell: Plant?
    
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var plantSpeciesTextField: UITextField!
    @IBOutlet weak var waterFrequencyTextField: UITextField!
    @IBOutlet weak var happinessSegmentedControl: UISegmentedControl!
    @IBOutlet weak var savePlantButton: UIButton!
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDetails()
        
        
        // Do any additional setup after loading the view.
    }
    
    func getDetails() {
        guard let apiController = apiController,
            let plantCell = self.plantCell else { return }
        apiController.fetchPlantsFromDatabase() { (data) in
            if (try? data.get()) != nil {
                DispatchQueue.main.async {
                    self.updateViews(with: plantCell)
                }
            }
        }
        
    }
    
    private func updateViews(with plant: Plant) {
        nicknameTextField.text = plant.nickname
        plantSpeciesTextField.text = plant.species
        waterFrequencyTextField.text = ""
        happinessSegmentedControl.selectedSegmentIndex = 0
        
        
        
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
    }

}







