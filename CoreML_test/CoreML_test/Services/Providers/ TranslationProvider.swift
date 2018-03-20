//
//  TranslationProvider.swift
//  CoreML_test
//
//  Created by owl on 18.03.18.
//  Copyright © 2018 Осина П.М. All rights reserved.
//

import Foundation
import RxAlamofire
import Alamofire
import RxSwift
import UIKit
import ObjectMapper
import Localize_Swift


class TranslationProvider {
    
    private let apiURL: URL!
    
    
    required init (endpointPath: String) throws{
        guard let apiURL = URL(string: endpointPath) else {
            throw TranslationApiError.illegalArgument("Endpoint URL not setted")
        }
        self.apiURL = apiURL
        
    }
    
//    func requestJSON (
//        path: String,
//        method: HTTPMethod,
//        parameters: [String:Any]? = nil,
//        encoding: ParameterEncoding = URLEncoding(destination: .methodDependent),
//        headers: [String: String]? = nil) -> Observable<(HTTPURLResponse, Any)>{
//
//        return RxAlamofire.requestJSON(method,
//                                       apiURL.appendingPathComponent(path),
//                                       parameters: parameters,
//                                       encoding: encoding,
//                                       headers: headers)
//            .flatMap {(result: HTTPURLResponse, object: Any) -> Observable <(HTTPURLResponse, Any)> in
//                if (!result.isSuccessful()){
//                    guard let jsonData = try? JSONSerialization.data(withJSONObject: object as! [String: Any])
//                        else {
//                            throw NSError(domain: "", code: -1,
//                                          userInfo: [NSLocalizedDescriptionKey: "Please validate JSON for \(String(describing:ApiError.self)) struct "])
//                    }
//                    guard let apiError = try? JSONDecoder().decode(ApiError.self, from: jsonData) else {
//                        throw NSError(domain: "", code: -1,
//                                      userInfo: [NSLocalizedDescriptionKey: "Failed to decode Codable struct \(String(describing: ApiError.self))"])
//                    }
//                    if apiError != nil {
//                        let error = TranslationApiError.apiError(apiError)
//                        if error.code() == 401{
//                            print("error code = 401")
//                        }
//                        return Observable.error(error)
//                    }
//                    let genericError = TranslationApiError.generic(result.statusCode, "Error")
//                    return Observable.error(genericError)
//
//                }
//                return Observable.just((result, object))
//        }
//    }
    
    
    func requestJSON (
        path: String,
        method: HTTPMethod,
        parameters: [String: Any]? = nil,
        encoding: ParameterEncoding = URLEncoding(destination: .methodDependent),
        headers: [String: String]? = nil) -> Observable<(HTTPURLResponse, Any)> {

        return RxAlamofire.requestJSON(method,
                                       apiURL.appendingPathComponent(path),
                                       parameters: parameters,
                                       encoding: encoding,
                                       headers: headers)
            .flatMap { (result: HTTPURLResponse, object: Any) -> Observable<(HTTPURLResponse, Any)> in
                print("OBJECT\n\n\(object)\n\n")
                if (!result.isSuccessful()) {
                    var apiError = Mapper<ApiError>().map(JSONObject: object)
                    if (apiError != nil) {
                        apiError!.code = result.statusCode
                    }
                    if let apiError = apiError {
                        let error = TranslationApiError.apiError(apiError)
                        /*
                         if result.statusCode == 401 {
                         let vc = UIApplication.shared.keyWindow?.rootViewController
                         let viewController:UIViewController = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "AuthVC") as UIViewController
                         if vc?.nibName != viewController.nibName{
                         vc?.present(viewController, animated: true, completion: nil)
                         }
                         }
                         */
                        return Observable.error(error)
                    }
                    
                    let genericError = TranslationApiError.generic(result.statusCode, "Error".localized())
                    
                    return Observable.error(genericError)
                }
                print(object)
                return Observable.just((result, object))
                
        }
        
    }
    
    func mappingObjects <Obj> (jsonData: Data, toStruct: Obj.Type) -> Decodable where Obj: Decodable {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        let result = try! decoder.decode(toStruct, from: jsonData)
        return result
    }
    
}
