//
//  DrawingViewController.swift
//  MobileDevelopment
//
//  Created by Anastasia Holovash on 08.02.2021.
//

import UIKit

class DrawingViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var chartView: ChartView!
    var diagramView: DiagramView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollViewSetup()
        setTextForLabel(currentPage: pageControl.currentPage)
    }
    
    private func scrollViewSetup() {
        
        scrollView.delegate = self
        
        chartView = ChartView()
        diagramView = DiagramView()
        
        scrollView.contentSize = CGSize(width: view.frame.width * 2, height: view.frame.width)
        scrollView.isPagingEnabled = true
        
        chartView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width)
        scrollView.addSubview(chartView)
        
        diagramView.frame = CGRect(x: view.frame.width, y: 0, width: view.frame.width, height: view.frame.width)
        scrollView.addSubview(diagramView)
    }
    
    private func setTextForLabel(currentPage: Int) {
        label.text = currentPage == 0 ? "Графік" : "Діаграма"
    }
    
    @IBAction func didChangePageControl(_ sender: UIPageControl) {
        
        scrollView.setContentOffset(CGPoint(x: view.frame.width * CGFloat(sender.currentPage), y: 0), animated: true)
        setTextForLabel(currentPage: sender.currentPage)
    }
}

extension DrawingViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageIndex = round(Float(scrollView.contentOffset.x / view.frame.width))
        pageControl.currentPage = Int(pageIndex)
        setTextForLabel(currentPage: Int(pageIndex))
    }
}
