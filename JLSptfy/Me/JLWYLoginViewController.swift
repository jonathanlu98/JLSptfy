//
//  JLWYLoginViewController.swift
//  JLSptfy
//
//  Created by Jonathan Lu on 2020/2/22.
//  Copyright © 2020 Jonathan Lu. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

typealias loginCompletionBlock = (Bool) -> Void

class JLWYLoginViewController: UIViewController {
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    let dispose = DisposeBag()
    
    var updateBlock: loginCompletionBlock?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        phoneTextField.keyboardType = .numberPad
        
        loginButton.rx.tap.subscribe(onNext: { (arg0) in
            let () = arg0
            self.loginButton.changStatus(isDisabled: true, disabledColor: #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), enabledColor: #colorLiteral(red: 0.9098273516, green: 0.1333410144, blue: 0.008049141616, alpha: 1))
            JLWYLoginManagement.shared.login(phone: self.phoneTextField.text ?? "-", password: self.passwordTextField.text ?? "-") { (result, error) in
                if result == true {
                    self.updateBlock!(true)
                    self.dismiss(animated: true)
                } else {
                    self.presentAlertController(title: "Error", message: "登录失败", buttonTitle: "Ok")
                    self.loginButton.changStatus(isDisabled: false, disabledColor: #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), enabledColor: #colorLiteral(red: 0.9098273516, green: 0.1333410144, blue: 0.008049141616, alpha: 1))
                }
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: dispose)
        
        // Do any additional setup after loading the view.
    }
    



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
