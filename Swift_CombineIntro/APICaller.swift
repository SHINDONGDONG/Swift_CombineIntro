//
//  APICaller.swift
//  Swift_CombineIntro
//
//  Created by 申民鐡 on 2022/04/05.
//

import Combine
import Foundation

//APICaller 클래스를 만들어주고
class APICaller {
    static let shard = APICaller()
    
    //컴퍼니를 가져오는 closure를 만들어줌
    //Future (미래의 스트링 배열과, 에러를 반환한다)
    func fetchCompanies() -> Future<[String],Error> {

        //실행이 되는것은 약속한 future를 실행하고 데이터를 호출하는것
        return Future { promixe in
            //호출을 지연시키는 asyncafter 에서 .now
            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                promixe(.success(["apple","Google","Samsung","Microsoft"]))
            }
            
        }
    }
}
