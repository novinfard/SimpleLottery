//
//  LotteryPlayer.swift
//  SimpleLottery
//
//  Created by Soheil  Novinfard on 23/02/2021.
//

import Foundation

struct LotteryPlayer: Equatable {
    let userId: Int
    let name: String
    let username: String
    let regDate: Date
    let void: Bool
}

extension LotteryPlayer {
    static let mockModelList: [LotteryPlayer] = [.mockModel, .mockModel2, .mockModel3]

    static let mockModel = LotteryPlayer(
        userId: 10,
        name: "Test Name",
        username: "test140",
        regDate: Date(),
        void: false
    )

    static let mockModel2 = LotteryPlayer(
        userId: 35,
        name: "Mammad",
        username: "mamali",
        regDate: Date(),
        void: true
    )

    static let mockModel3 = LotteryPlayer(
        userId: 44,
        name: "Lopez",
        username: "Lopenzono",
        regDate: Date(),
        void: true
    )
}
