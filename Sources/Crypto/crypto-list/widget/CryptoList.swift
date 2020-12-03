// Copyright author 2020
// Created by Jesus Manresa Parres
//


class CryptoList {
    private let controller = CryptoListControllerRx()

    var view: CryptoListViewRx? { 
        return controller.view as? CryptoListViewRx
    }
}

extension CryptoList: CryptoListProtocol {
}