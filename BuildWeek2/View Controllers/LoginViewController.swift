import UIKit
import CoreDataStack

class LoginViewController: UIViewController {
    
    // MARK: - Enums
    
    enum LoginType {
        case signUp
        case signIn
    }
    
    // MARK: - Properties
    
    let apiController = APIController.shared
    var loginType = LoginType.signUp
    let moc = CoreDataStack.shared.mainContext
    
    var user: User?
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet weak var loginSegementedController: UISegmentedControl!
    @IBOutlet private weak var signInButton: UIButton!
    
    // MARK: - App Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBActions
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        guard let inputedUsername = usernameTextField.text, !inputedUsername.isEmpty,
            let inputedPassword = passwordTextField.text, !inputedPassword.isEmpty else {
                print("Bad input")
                return
        }
        let newUser = UserRepresentation(id: nil,
                                         username: inputedUsername,
                                         password: inputedPassword,
                                         phoneNumber: nil,
                                         avatarUrl: nil,
                                         bearer: apiController.bearer?.token)
        if loginType == .signUp {
            apiController.signUp(with: newUser) { bearerToken in
                do {
                    try self.moc.save()
                } catch {
                    print("Error saving newly created User")
                    return
                }
            }
            let alertController = UIAlertController(title: "Sign Up Successful", message: "Now please log in", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true) {
                self.loginType = .signIn
                self.loginSegementedController.selectedSegmentIndex = 1
                self.signInButton.setTitle("Sign In", for: .normal)
            }
        } else {
            apiController.signIn(with: newUser) { result in
                do {
                    let success = try result.get()
                    if success{
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                } catch {
                    if let error = error as? APIController.NetworkError {
                        switch error {
                        case .failedSignIn:
                            print("sign in failed")
                        case .noToken, .noData:
                            print("no data recieved")
                        default:
                            print("Other error occured")
                        }
                    }
                }
            }
            self.dismiss(animated: true, completion: nil)
        }
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
