//
//  LotteryLandingView.swift
//  SimpleLottery
//
//  Created by Soheil  Novinfard on 23/06/2021.
//

import SwiftUI

struct LotteryLandingView: View {
    let detailRequested: () -> Void

    var body: some View {
        Button("Start It!") {
            detailRequested()
        }
    }
}

struct LotteryLandingView_Previews: PreviewProvider {
    static var previews: some View {
        LotteryLandingView() {}
    }
}
