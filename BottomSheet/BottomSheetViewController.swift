//
//  BottomSheetViewController.swift
//  BottomSheet
//
//  Created by Rahardyan Bisma on 13/11/20.
//  Copyright © 2020 amsibsam. All rights reserved.
//

import UIKit

open class BottomSheetViewController: UIViewController {
    var viewOutsideArea: UIView!
    var viewBottomSheetArea: UIView!
    var viewSliderArea: UIView!
    var viewContent: UIView!
    var viewSliderIndicator: UIView!
    var constraintSheetHeight: NSLayoutConstraint!
    var constraintSheetBottom: NSLayoutConstraint!
    var constraintSheetLeading: NSLayoutConstraint!
    var constraintSheetTrailing: NSLayoutConstraint!
    var sheetHeight: CGFloat = 400
    var content: [(SheetContentViewController?, CGFloat)] = []
    
    public init(viewController: SheetContentViewController, height: CGFloat = 400) {
        viewOutsideArea = UIView()
        viewOutsideArea.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3774757923)
        viewOutsideArea.translatesAutoresizingMaskIntoConstraints = false
        viewBottomSheetArea = UIView()
        viewBottomSheetArea.clipsToBounds = true
        viewBottomSheetArea.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        viewBottomSheetArea.translatesAutoresizingMaskIntoConstraints = false
        viewSliderArea = UIView()
        viewSliderArea.backgroundColor = .clear
        viewSliderArea.translatesAutoresizingMaskIntoConstraints = false
        viewContent = UIView()
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        viewSliderIndicator = UIView()
        viewSliderIndicator.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        viewSliderIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        viewBottomSheetArea.layer.cornerRadius = 16
        viewSliderIndicator.layer.cornerRadius = 4
        super.init(nibName: nil, bundle: nil)
        self.content.append((viewController, height))
        self.sheetHeight = height
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
        self.view.backgroundColor = .clear
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.animatePresent()
        }
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupContent()
    }
    
    private func setupUI() {
        let outsideAreaGesture = UITapGestureRecognizer(target: self, action: #selector(onOutsideAreaDidTap))
        viewOutsideArea.addGestureRecognizer(outsideAreaGesture)
        
        let sliderAreaGesture = UIPanGestureRecognizer(target: self, action: #selector(onSliderSlide(sender:)))
        viewSliderArea.addGestureRecognizer(sliderAreaGesture)
        
        viewSliderArea.addSubview(viewSliderIndicator)
        viewBottomSheetArea.addSubview(viewSliderArea)
        self.view.addSubview(viewOutsideArea)
        self.view.addSubview(viewBottomSheetArea)        
        
        setupConstraint()
        setupContent()
    }
    
    private func setupContent() {
        if content.isEmpty {
            fatalError("CONTENT SHOULD NOT BE EMPTY")
        }
        
        content.last?.0?.dismissCallback = { [weak self] in
            self?.animateDismiss()
        }
        
        content.last?.0?.changeContentCallback = { [weak self] newContent, newHeight in
            self?.content.last?.0?.view.removeFromSuperview()
            self?.content.append((newContent as? SheetContentViewController, newHeight))
            self?.sheetHeight = newHeight
            self?.setupContent()
        }
        
        content.last?.0?.backToPreviousContentCallback = { [weak self] in
            if self?.content.count == 1 {
                return
            }
            
            self?.content.removeLast()
            self?.sheetHeight = self?.content.last?.1 ?? 0
            self?.setupContent()
        }
        
        constraintSheetHeight?.constant = sheetHeight
        content.last?.0?.view.translatesAutoresizingMaskIntoConstraints = false
        viewBottomSheetArea.insertSubview(content.last!.0!.view, belowSubview: viewSliderArea)
        NSLayoutConstraint.activate([
            content.last!.0!.view.topAnchor.constraint(equalTo: viewBottomSheetArea.topAnchor),
            content.last!.0!.view.trailingAnchor.constraint(equalTo: viewBottomSheetArea.trailingAnchor),
            content.last!.0!.view.bottomAnchor.constraint(equalTo: viewBottomSheetArea.bottomAnchor),
            content.last!.0!.view.leadingAnchor.constraint(equalTo: viewBottomSheetArea.leadingAnchor),
        ])
        
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    private func setupConstraint() {
        constraintSheetHeight = viewBottomSheetArea.heightAnchor.constraint(equalToConstant: sheetHeight)
        if #available(iOS 11.0, *) {
            constraintSheetBottom = viewBottomSheetArea.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: sheetHeight)
            constraintSheetLeading = viewBottomSheetArea.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0)
            constraintSheetTrailing = viewBottomSheetArea.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0)
        } else {
            constraintSheetBottom = viewBottomSheetArea.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: sheetHeight)
            constraintSheetLeading = viewBottomSheetArea.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0)
            constraintSheetTrailing = viewBottomSheetArea.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0)
        }
        
        NSLayoutConstraint.activate([
            constraintSheetBottom,
            constraintSheetHeight,
            constraintSheetTrailing,
            constraintSheetLeading,
            viewOutsideArea.topAnchor.constraint(equalTo: self.view.topAnchor),
            viewOutsideArea.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            viewOutsideArea.bottomAnchor.constraint(equalTo: viewBottomSheetArea.topAnchor, constant: 12),
            viewOutsideArea.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            viewSliderArea.topAnchor.constraint(equalTo: viewBottomSheetArea.topAnchor),
            viewSliderArea.trailingAnchor.constraint(equalTo: viewBottomSheetArea.trailingAnchor, constant: -100),
            viewSliderArea.leadingAnchor.constraint(equalTo: viewBottomSheetArea.leadingAnchor, constant: 100),
            viewSliderArea.heightAnchor.constraint(equalToConstant: 30),
            viewSliderIndicator.topAnchor.constraint(equalTo: viewSliderArea.topAnchor, constant: 8),
            viewSliderIndicator.heightAnchor.constraint(equalToConstant: 6),
            viewSliderIndicator.widthAnchor.constraint(equalToConstant: 80),
            viewSliderIndicator.centerXAnchor.constraint(equalTo: viewSliderArea.centerXAnchor),
        ])
    }
    
    private func animateDismiss() {
        constraintSheetBottom.constant = sheetHeight
        
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.view.layoutIfNeeded()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            let transition: CATransition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: .easeOut)
            transition.type = .fade
            
            self?.view.window?.layer.add(transition, forKey: nil)
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    private func animatePresent() {
        constraintSheetBottom.constant = 12
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    @objc func onOutsideAreaDidTap() {
        animateDismiss()
    }
    
    @objc func onSliderSlide(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        let state = sender.state
        
        guard translation.y > 0 else {
            constraintSheetBottom.constant = 12
            return
        }
        
        constraintSheetBottom.constant = translation.y + 12
        
        if state == .ended {
            if translation.y > (sheetHeight / 1.5) || velocity.y >= 1300 {
                animateDismiss()
            } else {
                animatePresent()
            }
        }
    }

}
