//
//  Nominee.swift
//  SimpleLottery
//
//  Created by Soheil  Novinfard on 23/02/2021.
//

import Foundation

struct Nominee: Equatable {
    let name: String
    let user: String
    let blank: Bool

    init(name: String, user: String, blank: Bool = false) {
        self.name = name
        self.user = user
        self.blank = blank
    }
}
