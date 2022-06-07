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
        tableView.separatorStyle = .none
        tableView.register(AirTicketCell.self, forCellReuseIdentifier: AirTicketCell.identifier)
        return tableView
    }()
    
    lazy var activityView: UIActivityIndicatorView = {
        let activityView: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
        activityView.hidesWhenStopped = true
        activityView.startAnimating()
        activityView.translatesAutoresizingMaskIntoConstraints = false
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        layout()
        
        DispatchQueue.global().async {
            let apiURL = "https://travel.wildberries.ru/statistics/v1/cheap"
            self.getData(fromURL: apiURL)
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        setGradientBackground()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    private func setupNavigationBar() {
        
        let navBarApp = UINavigationBarAppearance()
        navBarApp.configureWithOpaqueBackground()
        navBarApp.backgroundColor = UIColor(named: "CB11AB")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Назад",
                                                           style: .plain,
                                                           target: nil,
                                                           action: nil)
        title = "WB voyage"
        navBarApp.largeTitleTextAttributes = [.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
        navBarApp.titleTextAttributes = [.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
        navigationController?.navigationBar.standardAppearance = navBarApp
        navigationController?.navigationBar.isTranslucent = false
    }
    
    private func getData(fromURL urlString: String) {
        guard let url = URL(string: urlString),
              let data = try? Data(contentsOf: url) else {
            return
        }
        
        parseTickets(json: data) { [weak self] in
            DispatchQueue.main.async {
                self?.activityView.stopAnimating()
                self?.tableView.reloadData()
            }
        }
    }
    
    private func parseTickets(json: Data, completion: @escaping () -> Void) {
        let decoder = JSONDecoder()
        
        guard let jsonTickets = try? decoder.decode(TicketData.self, from: json) else {
            completion()
            return
        }
        
        tickets = jsonTickets.data
        completion()
    }
    
    private func layout() {
        view.addSubview(activityView)
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
