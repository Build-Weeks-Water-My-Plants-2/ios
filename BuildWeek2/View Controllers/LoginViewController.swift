import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Enums
    
    enum LoginType {
        case signUp
        case signIn
    }
    
    // MARK: - Properties
    
    let apiController = APIController.shared
    var loginType = LoginType.signUp
    
    var user: User?
    
    // MARK: - IBOutlets

    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginTypeSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var signInButton: UIButton!
    
    // MARK: - App Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBActions
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        guard let inputedUsername = usernameTextField.text,
            let inputedPassword = passwordTextField.text else {
                print("Bad input")
                return
        }
        
        let _ = UserRepresentation(id: nil, username: inputedUsername, password: inputedPassword, phoneNumber: nil, avatarUrl: nil)
        
        
    }
    
    @IBAction func loginTypeChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            signInButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            signInButton.setTitle("Sign In", for: .normal)
        }
    }
}
