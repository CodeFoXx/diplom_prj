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
    
    func navigateToTextDetectionView(){
        router.navigateToTextDetectionView()
    }
    
    
    func translationRequest(language: String, text: String){
        var api = userDefaults.string(forKey: yandexApiDefaultsKey)
        var transalatedData: TranslatedData!
        let parameters: Parameters = [
            "key": "trnsl.1.1.20170803T140152Z.ff3df58b936ba3e4.cb34d86877638b493fd3388f2842d20c61948c58",
            "text": text,
            "lang": language
        ]
        print(parameters)
        disposeBag.insert(translationService.requestJSON(path: appendingPath, method: .post, parameters: parameters, encoding: URLEncoding.queryString, headers: nil)
            .subscribe(onNext: { [weak self]
                (r, json) in
                print(json)
                if let objectsData = try? JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions(rawValue: 0)){
                    var objectString = String(data: objectsData, encoding: .utf8)
                    transalatedData = self?.translationService.mappingObjects(jsonData: objectsData, toStruct: TranslatedData.self) as! TranslatedData
                    print(transalatedData.text)
                    self?.view.setTranslatedText(text: transalatedData.text)
                    
                }
                }, onError: {
                    print($0)
            }))
    }

}
