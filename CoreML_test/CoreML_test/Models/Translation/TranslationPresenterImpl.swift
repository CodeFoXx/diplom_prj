//
//  TranslationPresenterImpl.swift
//  CoreML_test
//
//  Created Осина П.М. on 19.03.18.
//  Copyright © 2018 Осина П.М.. All rights reserved.
//

import Foundation
import UIKit
import RxAlamofire
import Alamofire
import RxSwift

class TranslationPresenterImpl: TranslationPresenter {

    weak private var view: TranslationView!
    private let router: TranslationRouter
    private var translationService: TranslationProvider
    
    //private let appendingPath = "translate?"
    private let appendingPath = "translate"
    let userDefaults = UserDefaults.standard
    private var disposeBag = DisposeBag()
    private let yandexApiDefaultsKey = "yandexApiDefaultsKey"
    
    init(view: TranslationView, router: TranslationRouter, translationService: TranslationProvider) {
        self.view = view
        self.router = router
        self.translationService = translationService
    }
    
    
    var i = 0
    
    func runEndlessUpdate() {
        disposeBag.insert(Observable<Int>.interval(0.5, scheduler: MainScheduler.instance)
            .subscribe(onNext: {[weak self] timerInt in
                self?.i = timerInt
                //self?.o
            }))
    }
    
    
    func translationRequest(language: String, text: String){
        var api = userDefaults.string(forKey: yandexApiDefaultsKey)
        let parameters: Parameters = [
            "key": api!,
            "text": text,
            "lang": language
        ]
        
        disposeBag.insert(translationService.requestJSON(path: appendingPath, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
            .subscribe(onNext: { [weak self]
                (r, json) in
                print(json)
                if let objectsData = try? JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions(rawValue: 0)){
                    var objectString = String(data: objectsData, encoding: .utf8)
                    print(objectString)
                }
                }, onError: {
                    print($0)
            }))
    }

}
