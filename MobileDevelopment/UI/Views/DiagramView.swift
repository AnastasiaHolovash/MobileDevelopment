//
//  DiagramView.swift
//  MobileDevelopment
//
//  Created by Anastasia Holovash on 08.02.2021.
//

import UIKit

final class DiagramView: UIView {
    
    // MARK: - Variables
    
    var units: [DiagramUnit] = [DiagramUnit(value: 0.35, color: .green),
                                DiagramUnit(value: 0.4, color: .yellow),
                                DiagramUnit(value: 0.25, color: .red)]
    
    // MARK: - Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    private func setup() {
        backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        
        var lastAngle: CGFloat = 0
        
        units.forEach { unit in
            let path = UIBezierPath()
            
            let endAngle: CGFloat = lastAngle + CGFloat(unit.value * 2 * Double.pi)
            let radius = frame.width / 3
            
            path.addArc(withCenter: CGPoint(x: frame.width / 2, y: frame.height / 2), radius: radius, startAngle: lastAngle, endAngle: endAngle, clockwise: true)
            
            path.lineWidth = radius / 1.5
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
