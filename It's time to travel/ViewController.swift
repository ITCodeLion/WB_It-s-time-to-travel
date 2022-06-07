//
//  ViewController.swift
//  It's time to travel
//
//  Created by Lev on 01.06.2022.
//

import UIKit

class ViewController: UIViewController {
    
    private var tickets = [Ticket]()
    
    
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .plain)//.zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .systemGray5
        tableView.register(AirTicketCell.self, forCellReuseIdentifier: AirTicketCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        
        //
        let urlString = "https://travel.wildberries.ru/statistics/v1/cheap"
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                //
                parse(json: data)
            }
        }
        //
        layout()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    private func setupNavigationBar() {
        
        //self.navigationController?.navigationBar.prefersLargeTitles = false
        //self.navigationController?.navigationBar.isHidden = false
        //self.navigationController?.navigationBar.isTranslucent = true
        //self.navigationController?.navigationBar.barTintColor = .black
        title = "WB voyage"
        let textAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.isTranslucent = false
        //self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        //self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        if let jsonTickets = try? decoder.decode(TicketsAPI.self, from: json) {
            tickets = jsonTickets.data
            //
            print("tickets")
        }
    }
    
    private func layout() {

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tickets.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: AirTicketCell.identifier, for: indexPath) as! AirTicketCell
        cell.delegate = self
        
        if !tickets.isEmpty {
            cell.setUpCell(self.tickets[indexPath.row])
        }
//        if
//        cell.setUpCell(self.tickets[indexPath.row])
        
        //let ind = indexPath
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = TicketInfoController()
        detailVC.infoData = tickets[indexPath.item]
        //detailVC.contentView.delegate = self
        detailVC.delegate = self
        //paths =
        navigationController?.pushViewController(detailVC, animated: true)
        
        
    }
}
// MARK: - для лайков
extension ViewController: AirTicketCellProtocol, TicketInfoControllerProtocol {
//    func pressLike(button: UIButton, keyToken: String) {
//        <#code#>
//    }
    //cell: AirTicketCell,
    func pressLike(button: UIButton, keyToken: String) {
        
        
        
        switch button.tintColor {
        case UIColor.purple:
            button.tintColor = .white
            LikeBase.likeBase[keyToken]?.toggle()
            print("111")
        case UIColor.white:
            button.tintColor = .purple
            LikeBase.likeBase[keyToken]?.toggle()
            print("222")
        default:
            return
        }
    }
}

