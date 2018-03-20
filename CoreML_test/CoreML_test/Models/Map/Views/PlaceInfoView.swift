//
//  PlaceInfoView.swift
//  CoreML_test
//
//  Created by Осина П.М. on 27.02.18.
//  Copyright © 2018 Осина П.М. All rights reserved.
//

import UIKit

class PlaceInfoView: UIView {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!

    private lazy var timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
    
    func configure(withSegment date: Date){
        var image: UIImage?
        var name: String?
        
        imageView.image = #imageLiteral(resourceName: "subway")
        nameLabel.text = "123"
        dateLabel.text = timeFormatter.string(from: date)
    }

}
