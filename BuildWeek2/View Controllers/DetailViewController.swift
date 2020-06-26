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
            let plant = plantCell
            else { return }
        plant.nickname = nickname
        plant.species = plantSpeciesTextField.text
        plant.h20Frequency = Int16(waterFrequencyTextField.text ?? "0") ?? 0
        apiController.addPlantToDatabase(plant: plant)
        do{
            try CoreDataStack.shared.mainContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
    
    // MARK: - Private Functions
    
    private func updateViews() {
        nicknameTextField.text = plantCell?.nickname
        plantSpeciesTextField.text = plantCell?.species
        waterFrequencyTextField.text = String(plantCell?.h20Frequency ?? 0) 
    }
}
