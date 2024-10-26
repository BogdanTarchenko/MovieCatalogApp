//
//  GradientLabel.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 26.10.2024.
//

import UIKit

class GradientLabel: UILabel {
    
    private let gradientColors = [
        UIColor(red: 223/255, green: 40/255, blue: 0/255, alpha: 1).cgColor,
        UIColor(red: 255/255, green: 102/255, blue: 51/255, alpha: 1).cgColor
    ]
    
    init() {
        super.init(frame: .zero)
        font = UIFont(name: "Manrope-Bold", size: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.saveGState()
        context.translateBy(x: 0, y: rect.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        super.draw(rect)
        guard let textImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else { return }
        UIGraphicsEndImageContext()
        
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors as CFArray, locations: [0.0, 1.0]) else { return }
        
        let startPoint = CGPoint(x: 0, y: rect.midY)
        let endPoint = CGPoint(x: rect.width, y: rect.midY)
        
        context.clip(to: rect, mask: textImage)
        
        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])
        
        context.restoreGState()
    }
}
