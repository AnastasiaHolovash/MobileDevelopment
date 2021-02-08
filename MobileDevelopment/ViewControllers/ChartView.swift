//
//  ChartView.swift
//  MobileDevelopment
//
//  Created by Anastasia Holovash on 08.02.2021.
//

import UIKit

class ChartView: UIView {
    
    var startPoint: Int = -5
    var endPoint: Int = 5
    
    var unit: Int {
        return Int(frame.height) / (endPoint * endPoint + 1)
    }
    
    var chartHeight: Int {
        return endPoint * endPoint * unit
    }
    
    // MARK: - Life cycle

    override func draw(_ rect: CGRect) {
        let start = startPoint * unit
        let end = endPoint * unit
        
        let chartPath = UIBezierPath()
        let initialPoint = getPoint(for: start)
        chartPath.move(to: initialPoint)
        
        for x in start...end {
            let point = getPoint(for: x)
            chartPath.addLine(to: point)
        }
        
        // stroke
        chartPath.lineWidth = 1.5
        let strokeColor = UIColor.blue
        strokeColor.setStroke()

        // Move the path to a new location
        chartPath.apply(CGAffineTransform(translationX: 0, y: 0))

        // fill and stroke the path
        chartPath.stroke()
        
        // x
        let xLine = UIBezierPath()
        let xLineInitialPoint = CGPoint(x: 0, y: chartHeight)
        xLine.move(to: xLineInitialPoint)
        xLine.addLine(to: CGPoint(x: Int(frame.width), y: chartHeight))
       
        // stroke
        xLine.lineWidth = 1.0
        let xLineColor = UIColor.black
        xLineColor.setStroke()

        // Move the path to a new location
        xLine.apply(CGAffineTransform(translationX: 0, y: 0))

        // fill and stroke the path
        xLine.stroke()
        
        // y
        let yLine = UIBezierPath()
        let yLineInitialPoint = CGPoint(x: (Int(frame.width) / 2), y: 0)
        yLine.move(to: yLineInitialPoint)
        yLine.addLine(to: CGPoint(x: (Int(frame.width) / 2), y: (Int(frame.height))))
       
        // stroke
        yLine.lineWidth = 1.0
        let yLineColor = UIColor.black
        yLineColor.setStroke()

        // Move the path to a new location
        yLine.apply(CGAffineTransform(translationX: 0, y: 0))

        // fill and stroke the path
        yLine.stroke()
    }
    
    private func getPoint(for x: Int) -> CGPoint {
        
        let newX = x + (Int(frame.width) / 2)
        let newY = x * x - chartHeight
        
        return CGPoint(x: newX, y: -newY)
    }
}
