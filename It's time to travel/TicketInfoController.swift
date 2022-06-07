//
//  TicketInfoController.swift
//  It's time to travel
//
//  Created by Lev on 05.06.2022.
//

import UIKit

protocol TicketInfoControllerProtocol: AnyObject {
    func pressLike(button: UIButton, keyToken: String) //, index: IndexPath?)
}

class TicketInfoController: UIViewController {
    
    weak var delegate: TicketInfoControllerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigatiomBar()
        self.setupView()
    }
    
    private func setupNavigatiomBar() {
        //self.navigationController?.navigationBar.prefersLargeTitles = true
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
        view.delegate = self
        return view
    }()
    
    var infoData: Ticket?
    
    private func setupView() {
        self.view.backgroundColor = #colorLiteral(red: 0.4714243412, green: 0.05966885388, blue: 0.5201253891, alpha: 1)
        //self.setupButtons()
        view.addSubview(scrollView)
        
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
// MARK: - для лайков
extension TicketInfoController: TicketInfoViewProtocol {
    func pressLike(button: UIButton, keyToken: String) {
        delegate?.pressLike(button: button ,keyToken: keyToken)
//        switch button.tintColor {
//        case UIColor.purple:
//            button.tintColor = .white
//            LikeBase.likeBase[keyToken] = false
//            //delegate?.pressLike()
//            print("333")
//        case UIColor.white:
//            button.tintColor = .purple
//            LikeBase.likeBase[keyToken] = true
//            //delegate?.pressLike()
//            print("444")
//        default:
//            return
//        }
    }
}
