//
//  AirTicketCell.swift
//  It's time to travel
//
//  Created by Lev on 01.06.2022.
//

import UIKit

class AirTicketCell: UITableViewCell {
    
    private let viewTicket: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.alpha = 0.7
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.black.cgColor
        view.clipsToBounds = true
        return view
    }()
    
    private let logoTicket: UIImageView = {
        let logo = UIImageView()
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.backgroundColor = .black
        logo.contentMode = .scaleAspectFit
        logo.layer.cornerRadius = 10
        logo.clipsToBounds = true
        return logo
    }()
    
    private let cityFromLabel: UILabel = {
        let city = UILabel()
        city.translatesAutoresizingMaskIntoConstraints = false
        city.text = "From city"
        city.font = UIFont.boldSystemFont(ofSize: 20)
        city.textColor = .black
        city.numberOfLines = 2
        return city
    }()
    
    private let cityToLabel: UILabel = {
        let city = UILabel()
        city.translatesAutoresizingMaskIntoConstraints = false
        city.text = "To city"
        city.font = UIFont.boldSystemFont(ofSize: 16)
        city.textColor = .black
        city.numberOfLines = 2
        return city
    }()
    
    private let departureLabel: UILabel = {
        let departure = UILabel()
        departure.translatesAutoresizingMaskIntoConstraints = false
        departure.text = "01.06.2022"
        departure.font = UIFont.systemFont(ofSize: 10)
        departure.textColor = .black
        return departure
    }()
    
    private let arrivalLabel: UILabel = {
        let arrival = UILabel()
        arrival.translatesAutoresizingMaskIntoConstraints = false
        arrival.text = "07.06.2022"
        arrival.font = UIFont.systemFont(ofSize: 10)
        arrival.textColor = .black
        return arrival
    }()
    
    private let likesLabel: UILabel = {
        let likesLabel = UILabel()
        likesLabel.translatesAutoresizingMaskIntoConstraints = false
        likesLabel.text = "likes Label"
        likesLabel.font = UIFont.systemFont(ofSize: 10)
        likesLabel.textColor = .black
        return likesLabel
    }()
    
    private lazy var likeButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
        button.tintColor = .systemGray5
        button.addTarget(self, action: #selector(tapLike), for: .touchUpInside)
        return button
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Price Label"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .red
        return label
    }()
    
    private let arrowImage: UIImageView = {
        var arrow = UIImageView()
        arrow.translatesAutoresizingMaskIntoConstraints = false
        arrow.image = UIImage(systemName: "arrow.right")
        arrow.tintColor = .purple
        return arrow
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func DateFromWeb(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "MMM d, HH:mm"
        return  dateFormatter.string(from: date!)
    }
    
    private var model: Ticket?
    public var tapHandler: (() -> Void)?
    
    func setUpCell(_ infoData: Ticket) {
        model = infoData
        cityFromLabel.text = infoData.startCity
        cityToLabel.text = infoData.endCity
        departureLabel.text = DateFromWeb(infoData.startDate)
        arrivalLabel.text = DateFromWeb(infoData.endDate)
        priceLabel.text = "\(String(infoData.price)) RUB"
        logoTicket.image = UIImage(named: "WB")
        
        likePressed = LikeBase.defaults.bool(forKey: infoData.searchToken)
    }
    
    private func layout() {
        [viewTicket, logoTicket, cityFromLabel, cityToLabel, departureLabel, arrivalLabel, likeButton, priceLabel, arrowImage].forEach { contentView.addSubview($0) }

        let inset: CGFloat = 10
        
        NSLayoutConstraint.activate([
            viewTicket.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            viewTicket.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset),
            viewTicket.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: (inset - 2)),
            viewTicket.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset + 2)
        ])
        
        NSLayoutConstraint.activate([
            logoTicket.topAnchor.constraint(equalTo: viewTicket.topAnchor, constant: inset),
            logoTicket.leadingAnchor.constraint(equalTo: viewTicket.leadingAnchor, constant: inset),
            logoTicket.widthAnchor.constraint(equalToConstant: 50),
            logoTicket.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            cityFromLabel.topAnchor.constraint(equalTo: logoTicket.topAnchor),
            cityFromLabel.leadingAnchor.constraint(equalTo: logoTicket.trailingAnchor, constant: inset),
            cityFromLabel.heightAnchor.constraint(equalToConstant: 40),

        ])
        
        NSLayoutConstraint.activate([
            arrowImage.centerYAnchor.constraint(equalTo: cityFromLabel.centerYAnchor),
            arrowImage.leadingAnchor.constraint(equalTo: cityFromLabel.trailingAnchor, constant: inset),
            arrowImage.heightAnchor.constraint(equalToConstant: 20),
            arrowImage.widthAnchor.constraint(equalToConstant: 20)

        ])
        
        NSLayoutConstraint.activate([
            cityToLabel.topAnchor.constraint(equalTo: logoTicket.topAnchor),
            cityToLabel.leadingAnchor.constraint(equalTo: arrowImage.trailingAnchor, constant: inset),
            cityToLabel.trailingAnchor.constraint(equalTo: viewTicket.trailingAnchor, constant: -inset),
            cityToLabel.heightAnchor.constraint(equalToConstant:40)
        ])
        
        NSLayoutConstraint.activate([
            departureLabel.topAnchor.constraint(equalTo: cityFromLabel.bottomAnchor, constant: inset/2),
            departureLabel.leadingAnchor.constraint(equalTo: cityFromLabel.leadingAnchor),
            departureLabel.trailingAnchor.constraint(equalTo: cityFromLabel.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            arrivalLabel.topAnchor.constraint(equalTo: cityToLabel.bottomAnchor, constant: inset/2),
            arrivalLabel.leadingAnchor.constraint(equalTo: cityToLabel.leadingAnchor),
            arrivalLabel.trailingAnchor.constraint(equalTo: cityToLabel.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: logoTicket.bottomAnchor, constant: inset),
            priceLabel.leadingAnchor.constraint(equalTo: logoTicket.leadingAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: viewTicket.bottomAnchor, constant: -inset)
        ])
        
        NSLayoutConstraint.activate([
            likeButton.topAnchor.constraint(equalTo: priceLabel.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: viewTicket.trailingAnchor, constant: -inset),
            likeButton.bottomAnchor.constraint(equalTo: viewTicket.bottomAnchor, constant: -inset),
            likeButton.widthAnchor.constraint(equalTo: likeButton.heightAnchor)
        ])
    }
    
    private var likePressed: Bool = false {
        didSet {
            likeButton.tintColor = likePressed ? #colorLiteral(red: 0.7960784314, green: 0.06666666667, blue: 0.6705882353, alpha: 1) : .systemGray5
        }
    }
    
    @objc private func tapLike() {
        guard let model = model else { return }
        
        likePressed = !likePressed
        LikeBase.defaults.set(likePressed, forKey: model.searchToken)
        tapHandler?()
    }
}
