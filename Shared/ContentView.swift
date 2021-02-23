//
//  ContentView.swift
//  Shared
//
//  Created by Soheil  Novinfard on 23/02/2021.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var electionPublisher = ElectionPublisher(nomineeList: Nominee.listOfNominee)

    var body: some View {
        VStack {
            Text("🏆 The winner is:")
                .font(.headline)
            Spacer()
                .frame(height: 20)
            Text(descriptionText)
                .font(.title)
                .multilineTextAlignment(.center)
                .padding(15)
            Text(electionPublisher.winner.name)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(textColor)
            Text("@" + electionPublisher.winner.user)
                .foregroundColor(textColor)
            Image(resultImageName)
                .resizable()
                .scaledToFit()
                .frame(height: 200)

        }
    }

    var textColor: Color {
        guard self.electionPublisher.electionDone else { return .black }
        return self.electionPublisher.winner.color
    }

    var resultImageName: String {
        guard self.electionPublisher.electionDone else { return "" }
        return self.electionPublisher.winner.resultImageName
    }

    var descriptionText: String {
        guard electionPublisher.electionDone else { return "" }
        return electionPublisher.winner.resultText
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

fileprivate extension Nominee {
    var color: Color {
        blank == true ? .red : .orange
    }

    var resultText: String {
        if blank == true {
            return "و بازی پوچ شد! 😢"
        } else {
            return "برنده خوشبخت امشب شما هستید! تبریک میگم! 🎉🤑"
        }
    }

    var resultImageName: String {
        blank == true ? "oops" : "happy"
    }
}
