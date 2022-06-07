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
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        
        tableView.register(AirTicketCell.self, forCellReuseIdentifier: AirTicketCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
    
        let urlString = "https://travel.wildberries.ru/statistics/v1/cheap"
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
            }
        }
        layout()
    }
    
    lazy var activityView: UIActivityIndicatorView = {
        let activityView: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        activityView.hidesWhenStopped = true
        activityView.startAnimating()
        view.addSubview(activityView)
        return activityView
    }()
    
    func setGradientBackground() {
        let colorTop =  UIColor(red: 72.0/255.0, green: 17.0/255.0, blue: 115.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 203.0/255.0, green: 17.0/255.0, blue: 171.0/255.0, alpha: 1.0).cgColor
                    
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
                
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        setGradientBackground()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sleep(1)
        self.activityView.stopAnimating()
    }

    private func setupNavigationBar() {
        
        let navBarApp = UINavigationBarAppearance()
        navBarApp.configureWithOpaqueBackground()
        navBarApp.backgroundColor = UIColor(named: "CB11AB")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: nil, action: nil)
        title = "WB voyage"
        navBarApp.largeTitleTextAttributes = [.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
        navBarApp.titleTextAttributes = [.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
        self.navigationController?.navigationBar.standardAppearance = navBarApp
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        if let jsonTickets = try? decoder.decode(TicketsAPI.self, from: json) {
            tickets = jsonTickets.data
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
        
        self.activityView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.activityView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.activityView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tickets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: AirTicketCell.identifier, for: indexPath) as! AirTicketCell
        
        if !tickets.isEmpty {
            cell.setUpCell(self.tickets[indexPath.row])
            cell.tapHandler = { [weak self] in
                self?.tableView.reloadData()
            }
        }
        cell.backgroundColor = .clear
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = TicketInfoController()
        detailVC.infoData = tickets[indexPath.item]
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
