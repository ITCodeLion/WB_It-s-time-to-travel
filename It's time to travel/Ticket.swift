//
//  Ticket.swift
//  It's time to travel
//
//  Created by Lev on 02.06.2022.
//

import UIKit

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

//startCity":"РњРѕСЃРєРІР°","startCityCode":"mow","endCity":"РЎР°РЅРєС‚-РџРµС‚РµСЂР±СѓСЂРі","endCityCode":"led","startDate":"2022-07-17T00:00:00Z","endDate":"2022-07-24T00:00:00Z","price":2690,"searchToken":"MOW0906PEE1606Y100"}]}
