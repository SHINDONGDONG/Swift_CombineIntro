//
//  ViewController.swift
//  Swift_CombineIntro
//
//  Created by 申民鐡 on 2022/04/05.
//

import UIKit
import Combine

class ViewController:UIViewController {
    
    //MARK: - Properties
    private var mySubscriptions = Set<AnyCancellable>()
    
    var viewModel: MyViewModel!
    
    private let passwordTextField:UITextField  = {
        let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.backgroundColor = .systemBackground
        text.placeholder = "비밀번호 입력"
        text.font = .systemFont(ofSize: 20)
        text.isSecureTextEntry = true
        text.layer.borderWidth = 1
        text.layer.cornerRadius = 5
        return text
    }()
    
    private let passwordConfirmTextField:UITextField  = {
        let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.backgroundColor = .systemBackground
        text.placeholder = "비밀번호 입력 확인"
        text.font = .systemFont(ofSize: 20)
        text.layer.borderWidth = 1
        return text
    }()
    
    private let button:UIButton  = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemGray
        button.setTitle("내 버튼", for: UIControl.State.normal)
        button.titleLabel?.font = .systemFont(ofSize: 40)
        
        return button
    }()
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configures()
    }
    
    
    //MARK: - Configures
    func configures(){
        viewModel = MyViewModel()
        view.backgroundColor = .systemBackground
        view.addSubview(passwordTextField)
        view.addSubview(passwordConfirmTextField)
        view.addSubview(button)

        applyConstraints()
        
        passwordTextField
            .myTextPublisher
            .print("Password")
            //스레드 - 글로벌에서 받겠다, 메인에서 받겠다
            .receive(on: DispatchQueue.main)
            //viewModel의 passwordInput에 넣어준다 //구독
            .assign(to: \.passwordInput, on: viewModel)
            //메모리관리
            .store(in: &mySubscriptions)
        
        passwordConfirmTextField
            .myTextPublisher
            .print("Confirm")
            //스레드 - 글로벌에서 받겠다, 메인에서 받겠다
            .receive(on: DispatchQueue.main)
            //viewModel의 passwordInput에 넣어준다 //구독
            .assign(to: \.passwordConfirmInput, on: viewModel)
            //메모리관리
            .store(in: &mySubscriptions)
        
        //버튼이 뷰모델의 퍼블리셔를 구독함.
        viewModel.isMatchPasswordInput
            //다른스레드와 같은 작업을 할 때 RunLoop로 돌린다.
            //위에서 pasword들의 스레드를 돌리고있으니 runloop에서한다.
            .receive(on: RunLoop.main)
            //뷰모델을 구독함
            .assign(to: \.isValid, on: button)
            .store(in: &mySubscriptions)
    }
    
    func applyConstraints() {
        let text1Const = [
            passwordTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            passwordTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            passwordTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            passwordTextField.heightAnchor.constraint(equalToConstant: 60)
        ]
        let text2Const = [
            passwordConfirmTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10),
            passwordConfirmTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            passwordConfirmTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            passwordConfirmTextField.heightAnchor.constraint(equalToConstant: 60)
        ]
        let text3Const = [
            button.topAnchor.constraint(equalTo: passwordConfirmTextField.bottomAnchor, constant: 10),
            button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            button.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            button.heightAnchor.constraint(equalToConstant: 60)
        ]
        NSLayoutConstraint.activate(text1Const)
        NSLayoutConstraint.activate(text2Const)
        NSLayoutConstraint.activate(text3Const)
    }
}

//MARK: - Extension
//가져와야하는게 텍스트필드니깐 extension으로 텍스트필드를 커스텀해줌
extension UITextField {
    //mytextpublisher를 anypublisher형태로 클로저로 가져오게됨.
    var myTextPublisher : AnyPublisher<String,Never> {
        //uitextField의 notificationcenter를 가지고오는것임.
        NotificationCenter.default.publisher(
            //textfield에 didchange가 들어왔을 때 이벤트를 발산하는것임.
            for:UITextField.textDidChangeNotification,object: self)
        //compactmap으로 오브젝트 형태로 가져와서 UItextfield로 가져옴
        .compactMap{$0.object as? UITextField }
        //uitextfield로 가져온거에서 text를 가져옴
        .map{$0.text ?? "" }
//        .print()
        //anypublisher로 퉁쳐서 다 가져옴.
        .eraseToAnyPublisher()
    }
}

extension UIButton {
    var isValid: Bool {
        get {
            backgroundColor == .yellow
        }
        set {
            backgroundColor = newValue ? .yellow : .lightGray
            isEnabled = newValue
            setTitleColor(newValue ? .blue : .white, for: UIControl.State.normal)
        }
    }
}
