//
//  UserRepository.swift
//  SimpleLottery (iOS)
//
//  Created by Soheil  Novinfard on 27/07/2021.
//

import Foundation
import Combine

struct UserNetResponse: Decodable {
    let items: [User]
}

struct User: Equatable, Decodable {
    let userId: Int
    let name: String
    let username: String
    let regDate: Date
}

enum UserRepositoryError: Error {
    case invalidUrl
    case responseError(Error)
    case parseError(Error)
}

protocol UserRepository {
    var modelPublisher: AnyPublisher<[User], UserRepositoryError> { get }
    func load()
}

class UserRepositoryImplementation: UserRepository {
    private let session: URLSession
    private var urlTask: URLSessionDataTask?
    private let endpoint: String

    init(session: URLSession, endpoint: String) {
        self.session = session
        self.endpoint = endpoint
    }

    var modelPublisher: AnyPublisher<[User], UserRepositoryError> {
        guard let url = URL(string: endpoint) else {
            return Fail(error: UserRepositoryError.invalidUrl)
                .eraseToAnyPublisher()
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601DateOnly)

        return session
            .dataTaskPublisher(for: url)
            .mapError { error in UserRepositoryError.responseError(error) }
            .tryMap { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
            .mapError { error in UserRepositoryError.responseError(error) }
            .decode(type: UserNetResponse.self, decoder: decoder)
            .map { $0.items }
            .mapError { error in UserRepositoryError.parseError(error) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func load() {
        urlTask?.resume()
    }
}

extension DateFormatter {
  static let iso8601DateOnly: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
  }()
}
