import UIKit
import CoreDataStack

class DetailViewController: UIViewController {
   // MARK: - Properties
   
   var apiController = APIController.shared
   var plant: Plant?
   
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
      guard let nickname = nicknameTextField.text, !nickname.isEmpty, let species = plantSpeciesTextField.text else { return }
      let h20Frequency = Int16(waterFrequencyTextField.text ?? "0") ?? 0
      
      if let plant = self.plant {
         plant.nickname = nickname
         plant.species = species
         plant.h20Frequency = h20Frequency
         guard let representation = plant.plantRepresentation else { return }
         self.apiController.addPlantToDatabase(plantRepresentation: representation)
         do{
            try CoreDataStack.shared.mainContext.save()
         } catch {
            print("Error saving managed object context: \(error)")
         }
         navigationController?.popViewController(animated: true)
         return
      }
      
      let newPlant = Plant(id: nil, nickname: nickname, species: species, h20Frequencey: h20Frequency, avatarUrl: "", happiness: false)
      
      guard let representation = newPlant.plantRepresentation else { return }
      self.apiController.addPlantToDatabase(plantRepresentation: representation)
      do{
         try CoreDataStack.shared.mainContext.save()
      } catch {
         print("Error saving managed object context: \(error)")
      }
      
      navigationController?.popViewController(animated: true)
   }
   
   // MARK: - Private Functions
   
   private func updateViews() {
      nicknameTextField.text = plant?.nickname
      plantSpeciesTextField.text = plant?.species
      waterFrequencyTextField.text = String(plant?.h20Frequency ?? 0)
   }
}
