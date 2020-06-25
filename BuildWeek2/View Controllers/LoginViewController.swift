import UIKit

class LoginViewController: UIViewController {
    
    
    // MARK: - Enums
    
    enum LoginType {
        case signUp
        case SIgnIn
    }

    
    // MARK: - Properties
    
    let apiController = APIController()
    
    
    // MARK: - IBOutlets

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var signInButton: UIButton!
    
    
    // MARK: - App Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    // MARK: - IBActions
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        
        let testUser = UserRepresentation(id: 1, username: "jholowesko", password: "123456", phoneNumber: nil, avatarUrl: nil)
        
        apiController.signUp(with: testUser) { (_) in
            
        }
    }
    
    @IBAction func signInTypeChanged(_ sender: UISegmentedControl) {
        
    }
    

}
