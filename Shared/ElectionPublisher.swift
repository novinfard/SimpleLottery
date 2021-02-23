//
//  ElectionPublisher.swift
//  SimpleLottery
//
//  Created by Soheil  Novinfard on 23/02/2021.
//

import Foundation
import Combine

class ElectionPublisher: ObservableObject {
    @Published var winner: Nominee
    @Published var electionDone: Bool = false
    private let nomineeList: [Nominee]

    private let maximumRounds = 10
    private let updateInterval: TimeInterval = 0.4
    private var cancellable: Cancellable?
    private var currentRound = 0

    init(nomineeList: [Nominee]) {
        precondition(!nomineeList.isEmpty)

        self.nomineeList = nomineeList
        self.winner = nomineeList.randomElement()!

        self.startTimer()
    }

    func startTimer() {
        self.cancellable?.cancel()
        self.cancellable = Timer
            .publish(every: updateInterval, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self, let winner = self.selectNominee() else { return }
                self.winner = winner
                self.currentRound += 1

                if self.currentRound > self.maximumRounds {
                    self.electionDone = true
                    self.cancellable?.cancel()
                }
            }
    }

    private func selectNominee() -> Nominee? {
        let newCadidate = nomineeList.randomElement()
        guard newCadidate != winner else { return selectNominee() }
        return newCadidate
    }

}
