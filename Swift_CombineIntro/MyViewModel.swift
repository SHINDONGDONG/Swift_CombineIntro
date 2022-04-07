//
//  MyViewModel.swift
//  Swift_CombineIntro
//
//  Created by 申民鐡 on 2022/04/07.
//

import Foundation
import Combine

//입력을 할 때마다 여기서 입력을받고 구독을할거임.
class MyViewModel {
    
    @Published var passwordInput: String = ""
    @Published var passwordConfirmInput: String = ""
    
    
    //들어온 퍼블리셔들 값 일치여부를 반환하는 퍼블리셔.
    //값이 나중에 설정될것이기 때문에 lazy로 설정
    lazy var isMatchPasswordInput : AnyPublisher<Bool,Never> = Publishers
    //passwordinput과 passwordconfirminput에 들어오는것을 map으로 받아준다.
        .CombineLatest($passwordInput, $passwordConfirmInput)
    //password, confirm을 string으로 받아주고
        .map({(password: String, passwordConfirm: String) in
            if password == "" || passwordConfirm == "" {
                return false
            }
            //passrod와 passwordconfirm이 같으면 true로 반환해준다.
            if password == passwordConfirm {
                return true
            } else {
                return false
            }
        })
        .print()
        .eraseToAnyPublisher()
}
