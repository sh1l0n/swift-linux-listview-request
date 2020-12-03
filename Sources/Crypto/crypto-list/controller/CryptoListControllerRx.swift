// Copyright author 2020
// Created by Jesus Manresa Parres
//


class CryptoListControllerRx {
    init() {
        _view = CryptoListViewRx(controller: self)
        model = CryptoListModelRx(view: _view)
        filter(query: "")
    }

    private var model: CryptoListModelRxProtocol?
    private var _view: CryptoListViewRxProtocol?
    var view: CryptoListViewRxProtocol? {
        return _view
    }
}

extension CryptoListControllerRx: CryptoListControllerRxProtocol {
    func didTouchOnItem(id: String) {
        //TODO
    }

    func filter(query: String) {
        model?.filter(query: query)
    }
}