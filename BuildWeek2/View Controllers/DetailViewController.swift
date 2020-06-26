import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var apiController = APIController.shared
    var plantCell: Plant?
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var plantImageView: UIImageView!
    @IBOutlet private weak var nicknameTextField: UITextField!
    @IBOutlet private weak var plantSpeciesTextField: UITextField!
    @IBOutlet private weak var waterFrequencyTextField: UITextField!
    @IBOutlet private weak var happinessSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var savePlantButton: UIButton!
    
    // MARK: - App Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    // MARK: - IBAction
    @IBAction func buttonTapped(_ sender: UIButton) {
        guard let nickname = nicknameTextField.text, !nickname.isEmpty,
        let species = plantSpeciesTextField.text
            else { return }
        let h20Frequency = Int16(waterFrequencyTextField.text ?? "0") ?? 0
        
        CoreDataStack.shared.mainContext.perform {
            if let plant = self.plantCell{
                plant.nickname = nickname
                plant.species = species
                plant.h20Frequency = h20Frequency
                self.apiController.addPlantToDatabase(plant: plant)
            } else {
               let newPlant = Plant(nickname: nickname,
                                 species: species,
                                 h20Frequencey: h20Frequency,
                                 avatarUrl: "",
                                 happiness: false,
                                 lastWateredAt: Date())
                self.apiController.addPlantToDatabase(plant: newPlant)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Private Functions
    
    private func updateViews() {
        nicknameTextField.text = plantCell?.nickname
        plantSpeciesTextField.text = plantCell?.species
        waterFrequencyTextField.text = String(plantCell?.h20Frequency ?? 0) 
    }
}
