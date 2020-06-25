import UIKit

class LoginViewController: UIViewController {
    
    
    // MARK: - Enums
    
    enum LoginType {
        case signUp
        case signIn
    }

    
    // MARK: - Properties
    
    
    
    // MARK: - IBOutlets

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var signInButton: UIButton!
    
    var apiController: APIController?
    var loginType = LoginType.signUp
    struct User {
        var username: String
        var password: String
        
    }
    
    // MARK: - App Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    // MARK: - IBActions
    
    @IBAction func buttonTapped(_ sender: UIButton) {
    
    }
    
    @IBAction func signInTypeChanged(_ sender: UISegmentedControl) {
        // switch UI between modes
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            signInButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            signInButton.setTitle("Sign In", for: .normal)
        }
    }
}
