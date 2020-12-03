
// Copyright author 2020
// Created by Jesus Manresa Parres
//

import Foundation


class CryptoListModelRx {
    init(view: CryptoListViewRxProtocol?) {
        self.view = view
    }

    private var data = [CryptoListItem]()
    //TODO: weak reference, check CryptoListViewRx controller property
    private var view: CryptoListViewRxProtocol?
}

// Common functions
private extension CryptoListModelRx {
    func getAssetPairs(onSuccess: @escaping (_:[String]) -> Void, onError: @escaping (_:String?) -> Void) {
        request(
            url: "https://api-pub.bitfinex.com/v2/conf/pub:list:pair:exchange", 
            method: .get, 
            data: nil, 
            onSuccess: ({ [onSuccess] response in 
                if let data = response.data(using: .utf8), 
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [Any],
                let message = json.first as? [String] {
                    onSuccess(message)
                    return
                }
                onError("Cannot parse response")
            }), 
            onError: ({ [onError] error in
                onError(error)
            })
        )
    }
}

extension CryptoListModelRx: CryptoListModelRxProtocol {

    func searchFor(query: String) {
        //TODO
    }

    func filter(query: String) {
        getAssetPairs(
            onSuccess: ({ [weak self] response in 
                var args = ""
                for assetPair in response {
                    args += "t\(assetPair),"
                }
                request(
                    url: "https://api-pub.bitfinex.com/v2/tickers?symbols=\(args)", 
                    method: .get, 
                    data: nil, 
                    onSuccess: ({ [weak self] response in 
                        var listUpdates = [CryptoListItem]()
                        
                        if let data = response.data(using: .utf8), 
                        let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [Any] {
                            for item in json {
                                if let itemIsList = item as? [Any],
                                let pairName = itemIsList[0] as? String,
                                let bid = itemIsList[1] as? Double,
                                let ask = itemIsList[3] as? Double {
                                    if query == "" {
                                        listUpdates.append(CryptoListItem(icon: "", id: pairName, ask: ask, bid: bid))
                                    }
                                }
                            }
                        }

                        self?.data = listUpdates.sorted(by: { first, second in 
                            return first.id < second.id 
                        })

                        if let data = self?.data {
                            self?.view?.update(items: data)
                            // var d = [CryptoListItem]()
                            // for i in 0..<20 {
                            //     d += [data[i]]
                            // }
                            // self?.view?.update(items: d)
                        }

                        //self?.view?.update(items: self?.data ?? [])
                    }), 
                    onError: ({ [weak self] error in
                        print("request.onError -> " + (error ?? "")) 
                        self?.view?.update(items: [])
                    })
                )
            }),
            onError: ({ [weak self] _ in 
                self?.view?.update(items: [])
            })
        )
    }
}