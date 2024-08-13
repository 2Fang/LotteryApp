import SwiftUI

struct RulesView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Winning Rules")
                .font(.title)
                .padding(.bottom, 10)

            Text("6 numbers: Jackpot")
            Text("5 numbers + Bonus Ball: $1,000,000")
            Text("5 numbers: $1,750")
            Text("4 numbers: $140")
            Text("3 numbers: $30")
        }
        .padding()
        .navigationTitle("Winning Rules")
    }
}

struct RulesView_Previews: PreviewProvider {
    static var previews: some View {
        RulesView()
    }
}
