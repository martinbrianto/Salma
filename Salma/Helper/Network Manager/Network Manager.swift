//
//  Network Manager.swift
//  Salma
//
//  Created by gratianus.brianto on 05/07/22.
//

import Foundation
import Alamofire

class NetworkManager {
    
    var mockContentData: Data {
        return getData(name: "singleLocationMock")
    }
    
    var mockCouriersData: Data {
        return getData(name: "couriersMock")
    }

    func getData(name: String, withExtension: String = "json") -> Data {
        let bundle = Bundle(for: type(of: self))
        let fileUrl = bundle.url(forResource: name, withExtension: withExtension)
        let data = try! Data(contentsOf: fileUrl!)
        return data
    }
    
    static let shared = NetworkManager()
    private let BASE_URL = "https://api.biteship.com"
    private let headers: HTTPHeaders = [
        "Authorization":"biteship_test.eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoiU2FsbWFUZXN0IiwidXNlcklkIjoiNjIzZGM3ZGRhYjM4NGUwOGJmMjQwZjEzIiwiaWF0IjoxNjU2OTU0NzQ4fQ.u0a7e95tW30nerl9M85cdEimbh2UvT8-RjNJ0H4iN2g",
        "Content-Type":"application/json"
    ]
}

extension NetworkManager {
    func getSingleLocation(_ location: String, completion: @escaping (LocationResponse?, Error?) -> Void){
        let encode = location.addingPercentEncoding(withAllowedCharacters: .afURLQueryAllowed)
        let url = BASE_URL+"/v1/maps/areas?countries=ID&input=\(encode ?? "")&type=single"
        let request = AF.request(url, method: .get, encoding: URLEncoding.default, headers: headers)
        request.responseDecodable(of: LocationResponse.self) { response in
            if let data = response.value {
                completion(data, nil)
            } else if let error = response.error {
                completion(nil, error)
            }
        }
    }
    
    func getshippingRate(_ parameter: ShippingRequest, completion: @escaping (ShippingResponse?, Error?) -> Void) {
        let url = BASE_URL+"/v1/rates/couriers"
        let request = AF.request(url, method: .post, parameters: parameter, encoder: JSONParameterEncoder.default, headers: headers)
        request.responseDecodable(of: ShippingResponse.self) { response in
            if let data = response.value {
                completion(data, nil)
            } else if let error = response.error {
                completion(nil, error)
            }
        }
    }
}
