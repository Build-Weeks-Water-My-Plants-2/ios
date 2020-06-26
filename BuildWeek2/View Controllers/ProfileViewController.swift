import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var phoneNumberTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var saveButton: UIButton!
    
    // MARK: - App Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBActions
    
    @IBAction func buttonTapped(_ sender: UIButton) {
    }
}
