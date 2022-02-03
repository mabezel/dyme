//
//  HappyaBDayControllerViewController.swift
//  DYME!
//
//  Created by max on 29.08.2021.
//

import UIKit
import Foundation

class HappyaBDayControllerViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    var r: Double = 0.24949
    var g: Double = 0.296934
    var b: Double = 0.393818
    var increase: Bool = true
    
    var backgroundColours = [UIColor()]
    var backgroundLoop = 0
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 5
        return pageControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        pageControl.addTarget(self, action: #selector(pageControlDidChange(_:)), for: .valueChanged)
        view.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        view.addSubview(pageControl)
        view.addSubview(scrollView)
        changeBottomColor()
    }
    
    @objc private func pageControlDidChange(_ sender: UIPageControl) {
        let current = sender.currentPage
        scrollView.setContentOffset(CGPoint(x: CGFloat(current) * view.frame.size.width, y: 0), animated: true)
    }
    
    func changeBottomColor() {
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: {timer in

            
            if self.increase {
                self.r += Double.random(in: 0.0...0.001)
                self.g += Double.random(in: 0.0...0.001)
                self.b += Double.random(in: 0.0...0.001)
            } else {
                self.r -= Double.random(in: 0.0...0.001)
                self.g -= Double.random(in: 0.0...0.001)
                self.b -= Double.random(in: 0.0...0.001)
            }
            
            if self.r > 0.98 || self.g > 0.98 || self.b > 0.98 {
                self.increase = false
            }

            if self.r < 0.05 || self.g < 0.05 || self.b < 0.05 {
                self.increase = true
            }
            
            self.view.backgroundColor = UIColor.init(red: CGFloat(self.r), green: CGFloat(self.g), blue: CGFloat(self.b), alpha: 1)
            if !(self.viewIfLoaded?.window != nil) {
                print("stooppped")
                timer.invalidate()
            }
        })
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pageControl.frame = CGRect(x: 10, y: view.frame.size.height - 100, width: view.frame.size.width - 20, height: 70)
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height - 100)
        
        configureScrollView()
//        if scrollView.subviews.count == 2 {
//            configureScrollView()
//        }
    }
    
    private func configureScrollView() {
        scrollView.contentSize = CGSize(width: view.frame.size.width * 5, height: scrollView.frame.size.height)
        scrollView.isPagingEnabled = true
        let colors: [UIColor] = [#colorLiteral(red: 0.9098039216, green: 0.6, blue: 0.5529411765, alpha: 1), #colorLiteral(red: 0.9333333333, green: 0.8235294118, blue: 0.8, alpha: 1), #colorLiteral(red: 0.9490196078, green: 0.8901960784, blue: 0.737254902, alpha: 1), #colorLiteral(red: 0.631372549, green: 0.4078431373, blue: 0.2274509804, alpha: 1), #colorLiteral(red: 0.7200478315, green: 0.6342515945, blue: 0.7305134535, alpha: 1)]
        for x in 0..<5 {
            let page = UIView(frame: CGRect(x: CGFloat(x) * view.frame.size.width, y: 0, width: view.frame.size.width, height: scrollView.frame.size.height))
            page.tag = x
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 360, height: 610))
            label.center = CGPoint(x: view.center.x, y: view.center.y - 60)
            label.textAlignment = .center
            label.numberOfLines = 0
           // label.text = congrats[x]
            
            page.addSubview(label)
            
            page.backgroundColor = colors[x]
            scrollView.addSubview(page)
        }
        
    }
}

extension HappyaBDayControllerViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(floorf(Float(scrollView.contentOffset.x) / Float(scrollView.frame.size.width)))
    }
}
