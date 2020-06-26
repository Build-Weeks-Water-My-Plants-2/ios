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
        getDetails()
    }
    
    // MARK: - Methods
    
    func getDetails() {
        guard let plantCell = self.plantCell else { return }
        apiController.fetchPlantsFromDatabase { data in
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
