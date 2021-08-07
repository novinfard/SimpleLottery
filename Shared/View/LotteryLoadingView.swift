//
//  LotteryLoadingView.swift
//  SimpleLottery
//
//  Created by Soheil  Novinfard on 23/06/2021.
//

import SwiftUI

struct LotteryLoadingView: View {
    var body: some View {
        ProgressView("Loading ...")
    }
}

struct LotteryLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LotteryLoadingView()
    }
}
