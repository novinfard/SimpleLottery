//
//  LotteryListRepository.swift
//  SimpleLotteryTests
//
//  Created by Soheil  Novinfard on 29/07/2021.
//

import Foundation
import Combine

struct LotteryListNetResponse: Decodable {
    let lotteryList: [LotteryUser]
}

struct LotteryUser: Equatable, Decodable {
    let userId: Int
    let void: Bool
}

enum LotteryListRepositoryError: Error {
    case invalidUrl
    case responseError(Error)
    case parseError(Error)
}

protocol LotteryListRepository {
    var modelPublisher: AnyPublisher<[LotteryUser], LotteryListRepositoryError> { get }
    func load()
}

class LotteryListRepositoryImplementation: LotteryListRepository {
    private let session: URLSession
    private let endpoint: URL?

    init(session: URLSession, endpoint: URL?) {
        self.session = session
        self.endpoint = endpoint
    }

    var modelPublisher: AnyPublisher<[LotteryUser], LotteryListRepositoryError> {
        guard let url = endpoint else {
            return Fail(error: LotteryListRepositoryError.invalidUrl)
                .eraseToAnyPublisher()
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601DateOnly)

        return session
            .dataTaskPublisher(for: url)
            .mapError { error in LotteryListRepositoryError.responseError(error) }
            .map { $0.data }
            .decode(type: LotteryListNetResponse.self, decoder: decoder)
            .map { $0.lotteryList }
            .mapError { error in LotteryListRepositoryError.parseError(error) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func load() {

    }
}
