//
//  MainController.swift
//  Swift_CombineIntro
//
//  Created by 申民鐡 on 2022/04/07.
//

import Foundation
import UIKit
import Combine

class MainController: UIViewController {
    
    //MARK: - Properties
    private var mySubscription = Set<AnyCancellable>()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        //true 이면 검색중에 searchbar이외의 뷰들을 흐리게한다
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = .label
        searchController
            .searchBar
            .searchTextField
            .accessibilityIdentifier = "mySearchBarTextField"
        searchController.searchBar.placeholder = "Search Your Ideas"
       return searchController
    }()
    
    private let textLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 40)
        return label
    }()
    
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configures()
    }
    
    //MARK: - Configures
    func configures(){
        title = "Debounce"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        self.navigationItem.searchController = searchController
        searchController.isActive = true
        
        //searchcontroler의 searchtextfield를 구독한다.
        searchController.searchBar.searchTextField
            .myDebounceSearchPublisher
        //completion은 없고 receiveValue만 받아온다.
            .sink { [ weak self ] receivedValue in
                //weak self로 약한 참조를 해도됨.
                self?.textLabel.text = receivedValue
                print("TextLabel : \(receivedValue)")
            }
            .store(in: &mySubscription)
        
        view.addSubview(textLabel)
        applyConst()
    }
    
    func applyConst() {
        let textLabelConst = [
            textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(textLabelConst)
    }
    
    
}

//MARK: - extension

extension UISearchTextField { //uisearchtextfield를 커스텀해준다.
    // anypublisher로 스트링값을 받고.
    var myDebounceSearchPublisher : AnyPublisher<String,Never> {
        //노션 디폴트 퍼블리셔에서 uisearchtextfield에 textdidchange가 감지되면
        NotificationCenter.default.publisher(for:
            UISearchTextField.textDidChangeNotification, object: self)
        //컴팩트맵으로 오브젝트를 가지고오고 그것이 uisearchtextfield이다.
        .compactMap{ $0.object as? UISearchTextField }
        //UISearchTextField에서 String을 가져온다.
        .map{ $0.text ?? "" }
        //데이터를 제어하여 data낭비가 없게끔 만드는게 debounce
        //for에는 지정된단위 이후에 데이터가 들어오게 하고, schedluer는 스레드를 지정한다.
        .debounce(for: .milliseconds(1000), scheduler: RunLoop.main)
        //빈값이 들어올 때 페이지가 갱신되지 않도록 필터를 걸어줌.
        .filter{ $0.count > 0 } //데이터의 길이가 0보다 클때 이벤트를 발산한다.
        .eraseToAnyPublisher()
    }
}
