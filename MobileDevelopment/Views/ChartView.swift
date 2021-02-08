//
//  ChartView.swift
//  MobileDevelopment
//
//  Created by Anastasia Holovash on 08.02.2021.
//

import UIKit

final class ChartView: UIView {
    
    // MARK: - Variables
    
    // Initial values
    var startPoint: Double = -5.0
    var endPoint: Double = 5.0
    
    var width: Double {
        return Double(frame.width)
    }
    
    var height: Double {
        return Double(frame.height)
    }
    
    // The equivalent value of the unit relative to the UIView size
    var equivalentUnit: Double {
        return height / (endPoint * endPoint + 1)
    }
    
    var equivalentStartPoint: Double {
        return startPoint * equivalentUnit
    }
    
    var equivalentEndPoint: Double {
        return endPoint * equivalentUnit
    }
    
    var chartHeight: Double {
        return endPoint * equivalentEndPoint
    }
    
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
        
        drawChart()
        
        let line = UIBezierPath()
        
        // Stroke
        line.lineWidth = 1.0
        UIColor.black.setStroke()
        
        // Ox
        let xEndPoint = CGPoint(x: width, y: chartHeight)
        line.move(to: CGPoint(x: 0, y: chartHeight))
        line.addLine(to: xEndPoint)
        line.move(to: CGPoint(x: width - 10, y: chartHeight - 10))
        line.addLine(to: xEndPoint)
        line.move(to: CGPoint(x: width - 10, y: chartHeight + 10))
        line.addLine(to: xEndPoint)
        line.move(to: CGPoint(x: equivalentStartPoint + width / 2, y: chartHeight + 5))
        line.addLine(to: CGPoint(x: equivalentStartPoint + width / 2, y: chartHeight - 5))
        line.move(to: CGPoint(x: equivalentEndPoint + width / 2, y: chartHeight + 5))
        line.addLine(to: CGPoint(x: equivalentEndPoint + width / 2, y: chartHeight - 5))
        
        // Oy
        let yEndPoint = CGPoint(x: width / 2, y: 0)
        line.move(to: CGPoint(x: width / 2, y: (height)))
        line.addLine(to: yEndPoint)
        line.move(to: CGPoint(x: width / 2 - 10, y: 10))
        line.addLine(to: yEndPoint)
        line.move(to: CGPoint(x: width / 2 + 10, y: 10))
        line.addLine(to: yEndPoint)
        line.move(to: CGPoint(x: width / 2 - 5, y: chartHeight - equivalentEndPoint))
        line.addLine(to: CGPoint(x: width / 2 + 5, y: chartHeight - equivalentEndPoint))
        
        line.stroke()
    }
    
    // MARK: - Private funcs
    
    private func drawChart() {

        let chartPath = UIBezierPath()
        
        // Stroke
        chartPath.lineWidth = 1.5
        UIColor.blue.setStroke()
        
        chartPath.move(to: getPoint(for: startPoint))
        
        for x in stride(from: startPoint, through: endPoint + 0.01, by: 0.1) {
            chartPath.addLine(to: getPoint(for: x))
        }
        chartPath.stroke()
    }

    private func getPoint(for x: Double) -> CGPoint {
        
        let newX = x * equivalentUnit + (width / 2)
        let newY = x * x * equivalentUnit - chartHeight
        
        return CGPoint(x: newX, y: -newY)
    }
}
