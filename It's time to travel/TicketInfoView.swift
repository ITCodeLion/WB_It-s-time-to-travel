//
//  TicketInfoView.swift
//  It's time to travel
//
//  Created by Lev on 05.06.2022.
//

import UIKit

protocol TicketInfoViewProtocol: AnyObject {
    func pressLike(button: UIButton, keyToken: String)
}

class TicketInfoView: UIView {
    
    weak var delegate: TicketInfoViewProtocol?
    
    private let logoTicket: UIImageView = {
        let logo = UIImageView()
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.backgroundColor = .black
        logo.contentMode = .scaleAspectFit
        logo.image = UIImage(named: "WB")
        logo.layer.cornerRadius = 20
        logo.clipsToBounds = true
        return logo
    }()
    
    private let cityFromLabel: UILabel = {
        let city = UILabel()
        city.translatesAutoresizingMaskIntoConstraints = false
        city.text = "From city"
        city.font = UIFont.boldSystemFont(ofSize: 22)
        city.textColor = .black
        city.numberOfLines = 2
        city.textAlignment = .center
        return city
    }()
    
    private let cityToLabel: UILabel = {
        let city = UILabel()
        city.translatesAutoresizingMaskIntoConstraints = false
        city.text = "To city"
        city.font = UIFont.boldSystemFont(ofSize: 22)
        city.textColor = .black
        city.numberOfLines = 2
        city.textAlignment = .center
        return city
    }()
    
    private let departureLabel: UILabel = {
        let departure = UILabel()
        departure.translatesAutoresizingMaskIntoConstraints = false
        departure.text = "01.06.2022"
        departure.font = UIFont.systemFont(ofSize: 16)
        departure.textColor = .black
        departure.textAlignment = .center
        return departure
    }()
    
    private let arrivalLabel: UILabel = {
        let arrival = UILabel()
        arrival.translatesAutoresizingMaskIntoConstraints = false
        arrival.text = "07.06.2022"
        arrival.font = UIFont.systemFont(ofSize: 16)
        arrival.textColor = .black
        arrival.textAlignment = .center
        return arrival
    }()
    
    private let cityFromCodeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "City code Label"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let cityToCodeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "City code Label"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = """
Обращаем Ваше внимание!
Фамилия, имя, отчество (если имеется)* и номер документа пассажира вводятся латинскими буквами.При внесении данных заграничного паспорта — как записано в заграничном паспорте. При внесении данных паспорта гражданина РФ в поле «Срок действия» вводится любая более поздняя дата, чем дата Вашего полета. Номер документа вводится без пробелов.

При покупке авиабилета онлайн в качестве подтверждения бронирования вам на email приходит маршрутная квитанция. Она содержит такую информацию, как паспортные данные пассажира, номер рейса, детали маршрута, данные по оплате и прочую информацию от авиакомпании, и контакты продавца билета.

Маршрутную квитанцию желательно распечатать и иметь с собой в качестве памятки. При регистрации на рейс в аэропорту вам потребуется только паспорт.
"""
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var likeButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(tapLike), for: .touchUpInside)
        return button
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Price Label"
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = .red
        return label
    }()
    
    private let arrowImage: UIImageView = {
        var arrow = UIImageView()
        arrow.translatesAutoresizingMaskIntoConstraints = false
        arrow.image = UIImage(systemName: "airplane")
        arrow.tintColor = .black
        return arrow
    }()
    
    private let fromImage: UIImageView = {
        var arrow = UIImageView()
        arrow.translatesAutoresizingMaskIntoConstraints = false
        arrow.image = UIImage(systemName: "airplane.departure")
        arrow.tintColor = .purple
        return arrow
    }()
    
    private let toImage: UIImageView = {
        var arrow = UIImageView()
        arrow.translatesAutoresizingMaskIntoConstraints = false
        arrow.image = UIImage(systemName: "airplane.arrival")
        arrow.tintColor = .purple
        return arrow
    }()
    
//    private lazy var stackFrom: UIStackView = {
//        let stack = UIStackView()
//        stack.axis = .vertical
//        stack.distribution = .fill
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        return stack
//    }()
//
//    private lazy var stackTo: UIStackView = {
//        let stack = UIStackView()
//        stack.axis = .vertical
//        stack.distribution = .fill
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        return stack
//    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layout()
        self.backgroundColor = .white
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func DateFromWeb(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "MM-dd-yy HH:mm"
        return  dateFormatter.string(from: date!)
    }
    
    func setUp(_ infoData: Ticket) {
        cityFromLabel.text = infoData.startCity
        cityToLabel.text = infoData.endCity
        departureLabel.text = DateFromWeb(infoData.startDate)
        arrivalLabel.text = DateFromWeb(infoData.endDate)
        priceLabel.text = "\(String(infoData.price)) RUB"
        cityFromCodeLabel.text = "Код города: \(infoData.startCityCode)"
        cityToCodeLabel.text = "Код города: \(infoData.endCityCode)"
        guard let key = LikeBase.likeBase[infoData.searchToken] else { return }
        if key {
            likeButton.tintColor = .purple
            keyToken = infoData.searchToken
        }
    }
    
    private var keyToken: String = ""
    
    private func layout() {
        [logoTicket, cityFromCodeLabel, cityFromLabel, cityToCodeLabel, cityToLabel, departureLabel, arrivalLabel, arrowImage, fromImage, toImage, textLabel, likeButton, priceLabel].forEach { self.addSubview($0) }
        // likeButton, priceLabel,
        let inset: CGFloat = 10

        NSLayoutConstraint.activate([
            logoTicket.topAnchor.constraint(equalTo: self.topAnchor, constant: inset),
            logoTicket.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            logoTicket.widthAnchor.constraint(equalToConstant: 100),
            logoTicket.heightAnchor.constraint(equalToConstant: 100)
        ])

        NSLayoutConstraint.activate([
            cityFromLabel.topAnchor.constraint(equalTo: logoTicket.bottomAnchor, constant: inset),
            cityFromLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: (inset - 2)),
            cityFromLabel.trailingAnchor.constraint(equalTo: arrowImage.leadingAnchor, constant: (-inset + 2)),
            cityFromLabel.heightAnchor.constraint(equalToConstant: 60)
        ])

        NSLayoutConstraint.activate([
            arrowImage.centerYAnchor.constraint(equalTo: cityFromLabel.centerYAnchor),
            arrowImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            //arrowImage.leadingAnchor.constraint(equalTo: cityFromLabel.trailingAnchor, constant: inset),
            arrowImage.heightAnchor.constraint(equalToConstant: inset * 3),
            arrowImage.widthAnchor.constraint(equalToConstant: inset * 3)
        ])

        NSLayoutConstraint.activate([
            cityToLabel.topAnchor.constraint(equalTo: cityFromLabel.topAnchor),
            cityToLabel.leadingAnchor.constraint(equalTo: arrowImage.trailingAnchor, constant: (inset-2)),
            cityToLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: (-inset + 2)),
            cityToLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        NSLayoutConstraint.activate([
            cityFromCodeLabel.topAnchor.constraint(equalTo: cityFromLabel.bottomAnchor, constant: (inset / 2)),
            cityFromCodeLabel.leadingAnchor.constraint(equalTo: cityFromLabel.leadingAnchor),
            cityFromCodeLabel.trailingAnchor.constraint(equalTo: arrowImage.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            cityToCodeLabel.topAnchor.constraint(equalTo: cityToLabel.bottomAnchor, constant: (inset / 2)),
            cityToCodeLabel.leadingAnchor.constraint(equalTo: arrowImage.trailingAnchor),
            cityToCodeLabel.trailingAnchor.constraint(equalTo: cityToLabel.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            fromImage.topAnchor.constraint(equalTo: cityFromCodeLabel.bottomAnchor, constant: (inset/2)),
            //fromImage.centerYAnchor.constraint(equalTo: departureLabel.centerYAnchor),
            fromImage.leadingAnchor.constraint(equalTo: cityFromCodeLabel.leadingAnchor),
            //fromImage.bottomAnchor.constraint(equalTo: departureLabel.bottomAnchor),
            fromImage.heightAnchor.constraint(equalToConstant: 16),
            fromImage.widthAnchor.constraint(equalTo: fromImage.heightAnchor)//(equalTo: fromImage.heightAnchor)
        ])

        NSLayoutConstraint.activate([
            departureLabel.centerYAnchor.constraint(equalTo: fromImage.centerYAnchor),
            //departureLabel.topAnchor.constraint(equalTo: cityFromCodeLabel.bottomAnchor, constant: (inset / 2)),
            departureLabel.leadingAnchor.constraint(equalTo: fromImage.trailingAnchor, constant: (inset / 5))//,
            //departureLabel.trailingAnchor.constraint(equalTo: cityFromLabel.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            toImage.topAnchor.constraint(equalTo: cityToCodeLabel.bottomAnchor, constant: (inset / 2)),
            toImage.leadingAnchor.constraint(equalTo: cityToCodeLabel.leadingAnchor),
            toImage.heightAnchor.constraint(equalToConstant: 16),
            toImage.widthAnchor.constraint(equalTo: fromImage.heightAnchor)
        ])

        NSLayoutConstraint.activate([
            arrivalLabel.centerYAnchor.constraint(equalTo: toImage.centerYAnchor),
            //arrivalLabel.topAnchor.constraint(equalTo: cityToCodeLabel.bottomAnchor, constant: inset),
            //arrivalLabel.leadingAnchor.constraint(equalTo: toImage.trailingAnchor, constant: inset/2),
            arrivalLabel.leadingAnchor.constraint(equalTo: toImage.trailingAnchor, constant: (inset / 5))
        ])
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: departureLabel.bottomAnchor, constant: inset),
            textLabel.leadingAnchor.constraint(equalTo: cityFromLabel.leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: cityToLabel.trailingAnchor)//,
            //textLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -inset)
        ])

        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: inset),
            priceLabel.leadingAnchor.constraint(equalTo: textLabel.leadingAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -inset)
        ])

        NSLayoutConstraint.activate([
            likeButton.topAnchor.constraint(equalTo: priceLabel.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -inset),
            likeButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -inset),
            likeButton.widthAnchor.constraint(equalTo: likeButton.heightAnchor)
        ])
    }
    
    //var likePressed: Bool = false
    
    @objc private func tapLike() {
//        switch likeButton.tintColor {
//        case UIColor.purple:
//            likeButton.tintColor = .white
//            LikeBase.likeBase[keyToken] = false
//            delegate?.pressLike()
//            print("111")
//        case UIColor.white:
//            likeButton.tintColor = .purple
//            LikeBase.likeBase[keyToken] = true
//            delegate?.pressLike()
//            print("222")
//        default:
//            return
//        }
        delegate?.pressLike(button: likeButton ,keyToken: keyToken)
    }
}
