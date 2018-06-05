//
//  CustomPinAnnotationView.swift
//  DronecodeSDKSwiftDemo
//
//

import UIKit
import MapKit

class CustomPinAnnotationView: MKAnnotationView {

    var labelTitle: String?

    
    init(annotation: MKAnnotation?) {
        super.init(annotation: annotation, reuseIdentifier: "pin")
        // get text to display from Annotation
        let myCustomPointAnnotation = annotation as? CustomPointAnnotation
        labelTitle = (myCustomPointAnnotation?.labelTitle)!
       
        // specific pin image
        image = UIImage(named: "pin-image")
        
        // label to display text from annotation
        let label = UILabel(frame: CGRect(x: 0, y: -4, width: 30, height: 25))
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.text = labelTitle
        label.font = label.font.withSize(8)
        addSubview(label)
        
        // position related to image
        self.centerOffset = CGPoint(x: 0.0, y: -((image?.size.height)!)/2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
