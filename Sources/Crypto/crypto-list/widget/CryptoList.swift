// Copyright author 2020
// Created by __sh0l1n@
//


class CryptoList {
    private let controller = CryptoListControllerRx()

    var view: CryptoListViewRx? { 
        return controller.view as? CryptoListViewRx
    }
}

extension CryptoList: CryptoListProtocol {
}