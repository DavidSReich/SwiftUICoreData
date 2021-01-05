//
//  DataSource.swift
//  SwiftUICoreData
//
//  Created by David S Reich on 16/11/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import Foundation
import Combine

class DataSource {
    private let networkService: NetworkService

    private var purchaseOrders = [PurchaseOrderModel]()
    private var disposables = Set<AnyCancellable>()

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func getData(urlString: String,
                 mimeType: String,
                 completion: @escaping (_ referenceError: ReferenceError?) -> Void) {
        guard let dataPublisher = networkService.getDataPublisher(urlString: urlString, mimeType: mimeType) else {
            completion(.badURL)
            return
        }

        dataPublisher
            .flatMap(maxPublishers: .max(1)) { data -> AnyPublisher<[PurchaseOrderModel], ReferenceError> in
                return data.decodeData() as AnyPublisher<[PurchaseOrderModel], ReferenceError>
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { value in
                switch value {
                case .failure(let error):
                    completion(error)
                case .finished:
                    completion(nil)
                }
            }, receiveValue: { [weak self] results in
                guard let self = self else { return }
                self.purchaseOrders = results
            })
            .store(in: &disposables)
    }

    func getPurchaseOrders() -> [PurchaseOrderModel] {
        return purchaseOrders
    }
}
