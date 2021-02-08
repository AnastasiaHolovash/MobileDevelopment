//
//  DiagramView.swift
//  MobileDevelopment
//
//  Created by Anastasia Holovash on 08.02.2021.
//

import UIKit

final class DiagramView: UIView {
    
    // MARK: - Variables
    
    var units: [DiagramUnit] = [DiagramUnit(value: 0.35, color: .systemGreen),
                                DiagramUnit(value: 0.4, color: .yellow),
                                DiagramUnit(value: 0.5, color: .red)]
    
    // MARK: - Life cycle
    
    override func draw(_ rect: CGRect) {
        
        var lastAngle: CGFloat = 0

        units.forEach { unit in
            let path = UIBezierPath()
            
            let endAngle: CGFloat = lastAngle + CGFloat(unit.value * 2 * Double.pi)
            
            path.addArc(withCenter: CGPoint(x: frame.width / 2, y: frame.height / 2), radius: frame.width / 2 - 25, startAngle: lastAngle, endAngle: endAngle, clockwise: true)

            path.lineWidth = 50
            unit.color.setStroke()
            path.stroke()

            lastAngle = endAngle
        }

    }
    
    // MARK: - DiagramUnit
    
    struct DiagramUnit {
        
        let value: Double
        let color: UIColor
    }
}
