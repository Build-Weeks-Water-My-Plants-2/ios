import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Enums
    
    enum LoginType {
        case signUp
        case signIn
    }
    
    // MARK: - Properties
    
//    let userController = UserController.shared
    var loginType = LoginType.signUp
    let moc = CoreDataStack.shared.mainContext
    
    var user: User?
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginSegementedController: UISegmentedControl!
    @IBOutlet private weak var signInButton: UIButton!
    
    // MARK: - App Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBActions
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        guard let inputedUsername = usernameTextField.text,
            !inputedUsername.isEmpty,
            let inputedPassword = passwordTextField.text,
            !inputedPassword.isEmpty else {
                print("Empty text fields")
                return
        }
        
        let tempUser = UserRepresentation( id: nil,
                                           username: inputedUsername,
                                           password: inputedPassword,
                                           phoneNumber: nil,
                                           avatarUrl: nil,
                                           bearer: nil )
        
//        userController.signUp(userRep: tempUser) { bool, bearer in
//            if bool == false {
//                print("bad signup")
//                return
//            } else {
//                guard let bearer = bearer else { return }
//                let createdUser = User(userRepresentation: tempUser)
//                createdUser?.bearer = bearer.token
//                do {
//                    try self.moc.save()
//                } catch {
//                    print("Error saving new User.")
//                }
//            }
//        }
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
