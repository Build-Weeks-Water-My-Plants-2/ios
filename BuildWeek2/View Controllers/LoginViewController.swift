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
            
            apiController.signUp(with: newUser) { bearerToken in
                
                //            var newUser1 = UserRepresentation(id: nil,
                //                                             username: inputedUsername,
                //                                             password: inputedPassword,
                //                                             phoneNumber: nil,
                //                                             avatarUrl: nil,
                //                                             bearer: self.apiController.bearer?.token)
                
                var userToSave = User(userRepresentation: newUser, context: self.moc)
                
                do {
                    try self.moc.save()
                } catch {
                    print("Error saving newly created User")
                    return
                }
            }
            #warning("Make dat Alert")
            self.dismiss(animated: true, completion: nil)
//        } else if loginType == .signIn{
//            let returningUser = UserRepresentation(id: nil, username: inputedUsername, password: inputedPassword, phoneNumber: nil, avatarUrl: nil, bearer: nil)
//            apiController.signIn(with: returningUser) { result in
//                do{
//                    let success = try result.get()
//                    if success{
//                        DispatchQueue.main.async {
//                            self.dismiss(animated: true, completion: nil)
//                        }
//                    }
//                } catch {
//                    print("\(error)")
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
