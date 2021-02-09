//
//  DrawingViewController.swift
//  MobileDevelopment
//
//  Created by Anastasia Holovash on 08.02.2021.
//

import UIKit

final class DrawingViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - Variables
    
    private var chartView: ChartView!
    private var diagramView: DiagramView!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        scrollViewSetup()
        setTextForLabel(currentPage: pageControl.currentPage)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        viewsSizesSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        viewsSizesSetup()
    }
    
    // MARK: - Private funcs
    
    private func setTextForLabel(currentPage: Int) {
        label.text = currentPage == 0 ? "Графік" : "Діаграма"
    }
    
    private func scrollViewSetup() {
        
        scrollView.delegate = self
        
        chartView = ChartView()
        diagramView = DiagramView()
        
        scrollView.isPagingEnabled = true
        scrollView.addSubview(chartView)
        scrollView.addSubview(diagramView)
    }
    
    private func viewsSizesSetup() {
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width * 2, height: scrollView.frame.height)
        chartView.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        diagramView.frame = CGRect(x: scrollView.frame.width, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        scrollView.setContentOffset(CGPoint(x: scrollView.frame.width * CGFloat(pageControl.currentPage), y: 0), animated: true)
    }
    
    // MARK: - IBActions
    
    @IBAction func didChangePageControl(_ sender: UIPageControl) {
        
        scrollView.setContentOffset(CGPoint(x: scrollView.frame.width * CGFloat(sender.currentPage), y: 0), animated: true)
        setTextForLabel(currentPage: sender.currentPage)
    }
}

// MARK: - UIScrollViewDelegate

extension DrawingViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageIndex = round(Float(scrollView.contentOffset.x / scrollView.frame.width))
        pageControl.currentPage = Int(pageIndex)
        setTextForLabel(currentPage: Int(pageIndex))
    }
}
