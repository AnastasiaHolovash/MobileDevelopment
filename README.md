###### НАЦІОНАЛЬНИЙ ТЕХНІЧНИЙ УНІВЕРСИТЕТ УКРАЇНИ
###### “КИЇВСЬКИЙ ПОЛІТЕХНІЧНИЙ ІНСТИТУТ ІМЕНІ ІГОРЯ СІКОРСЬКОГО”
###### Факультет інформатики та обчислювальної техніки
###### Кафедра обчислювальної техніки

### Лабораторна робота №2
#### з дисципліни
### “Програмування мобільних систем”

Виконала:

студентка групи ІВ-82

ЗК ІВ-8206

Головаш Анастасія

Київ 2021

## Варіант № 5
(8206 mod 6) + 1 = 5

## Скріншоти роботи додатка

<img src="https://github.com/AnastasiaHolovash/MobileDevelopment/blob/Lab2/ImagesLab2/1.png" width="300">
<img src="https://github.com/AnastasiaHolovash/MobileDevelopment/blob/Lab2/ImagesLab2/2.png" width="300">
<img src="https://github.com/AnastasiaHolovash/MobileDevelopment/blob/Lab2/ImagesLab2/3.png" height="300">
<img src="https://github.com/AnastasiaHolovash/MobileDevelopment/blob/Lab2/ImagesLab2/4.png" height="300">

## Лістинг коду

#### ChartView.swift
```swift
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
        
        // Drawing Ox
        let xEndPoint = CGPoint(x: width - 16, y: chartHeight)
        line.move(to: CGPoint(x: 16, y: chartHeight))
        line.addLine(to: xEndPoint)
        line.move(to: CGPoint(x: width - 26, y: chartHeight - 10))
        line.addLine(to: xEndPoint)
        line.move(to: CGPoint(x: width - 26, y: chartHeight + 10))
        line.addLine(to: xEndPoint)
        line.move(to: CGPoint(x: equivalentStartPoint + width / 2, y: chartHeight + 5))
        line.addLine(to: CGPoint(x: equivalentStartPoint + width / 2, y: chartHeight - 5))
        line.move(to: CGPoint(x: equivalentEndPoint + width / 2, y: chartHeight + 5))
        line.addLine(to: CGPoint(x: equivalentEndPoint + width / 2, y: chartHeight - 5))
        
        // Drawing Oy
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

```

#### DiagramView.swift

```swift
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

```

#### DrawingViewController.swift
```swift
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

```

## Висновок

Під час виконання лабораторної роботи було покращено навички зі створення мобільних додатків для операційної системи iOS. 
У даній роботі було створено UIView для відображення графіку та діаграми за допомогою методу draw(_:) та UIBezierPath.
