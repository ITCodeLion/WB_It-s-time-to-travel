//
//  Ticket.swift
//  It's time to travel
//
//  Created by Lev on 02.06.2022.
//

import UIKit

struct TicketData: Codable {
    var data: [Ticket]
}

struct Ticket: Codable {
    
    var startCity: String
    var startCityCode: String
    var endCity: String
    var endCityCode: String
    var startDate: String
    var endDate: String
    var price: Int
    var searchToken: String
}
