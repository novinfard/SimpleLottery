//
//  LotteryLandingView.swift
//  SimpleLottery
//
//  Created by Soheil  Novinfard on 23/06/2021.
//

import SwiftUI

struct LotteryLandingView: View {
    let detailRequested: () -> Void
    let errorMessage: String?

    init(errorMessage: String? = nil,
         detailRequested: @escaping () -> Void = {}) {
        self.detailRequested = detailRequested
        self.errorMessage = errorMessage
    }

    var body: some View {
        VStack {
            if let error = errorMessage {
                VStack {
                    Text(error)
                    Text("Try Again")
                }.foregroundColor(.red)
                .padding(20)
            } else {
                Text("To start the lottery press the button!")
                    .padding(20)
            }

            Button("Start It!") {
                detailRequested()
            }
            .buttonStyle(BlueButton())
        }
    }
}

struct BlueButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color(red: 0, green: 0, blue: 0.5))
            .foregroundColor(.white)
            .clipShape(Capsule())
    }
}

struct LotteryLandingView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LotteryLandingView()
            LotteryLandingView(errorMessage: "An Error Happened in connectivity. ")
        }
    }
}
