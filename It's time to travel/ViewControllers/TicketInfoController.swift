//
//  TicketInfoController.swift
//  It's time to travel
//
//  Created by Lev on 05.06.2022.
//

import UIKit

class TicketInfoController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigatiomBar()
        self.setupView()
    }
    
    private func setupNavigatiomBar() {
        self.navigationItem.title = "Детали перелета"
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    private lazy var scrollView: UIScrollView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIScrollView())
    
    private lazy var contentView: UIView = {
        let view = TicketInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        if let info = infoData {
            view.setUp(info)
        }
        return view
    }()
    
    var infoData: Ticket?
    
    private func setupView() {
        
        view.addSubview(scrollView)
        view.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
}
