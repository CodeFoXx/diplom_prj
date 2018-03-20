//
//  ActivityCalloutView.swift
//  CoreML_test
//
//  Created by Осина П.М. on 27.02.18.
//  Copyright © 2018 Осина П.М. All rights reserved.
//

import Foundation
import MapKit

private struct Constants{
    static let cornerRadius: CGFloat = 8
    static let calloutOffset: CGFloat = 8
    static let verticalSeparatorLeadingOffset: CGFloat = 14
    static let verticalSeparatorWithImageLeadingOffset: CGFloat = 34
}

protocol ActivityCalloutViewDelegate: class {
    func activityCalloutViewDidTapEdit(_ view: ActivityCalloutView)
}


class ActivityCalloutView: UIView {
    
    weak var annotation: ActivityAnnotation?
    weak var delegate: ActivityCalloutViewDelegate?
    
    private var verticalSeparatorLeadingConstraint: NSLayoutConstraint?
    private let backgroundView: UIView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = Constants.cornerRadius
        return view
    }()
    
    private let contentView: UIView={
       let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.layer.cornerRadius = Constants.cornerRadius
        return contentView
    }()
    
    private let titleLabel: KerningLabel = {
        let label = KerningLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.kern = 0.6
        label.textColor = .white
        label.font = UIFont.sfuiDisplaySemibold(ofSize: 15)
        return label
    }()
    
    private let subtitleLabel: KerningLabel = {
        let label = KerningLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.kern = 0.5
        label.font = UIFont.sfuiDisplay(ofSize: 12)
        label.textColor = UIColor.white.withAlphaComponent(0.7)
        return label
    }()
    
}
