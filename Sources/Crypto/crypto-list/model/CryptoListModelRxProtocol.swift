// Copyright author 2020
// Created by Jesus Manresa Parres
//

import Foundation

struct CryptoListItem {
    let icon: String
    let id: String
    let ask: Double
    let bid: Double
}

protocol CryptoListModelRxProtocol {
    func filter(query: String)
}