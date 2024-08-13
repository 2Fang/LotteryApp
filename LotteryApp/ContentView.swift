import SwiftUI

struct ContentView: View {
    @State private var lotteryDraws: [LotteryDraw] = []

    var body: some View {
        NavigationView {
            VStack {
                List(lotteryDraws) { draw in
                    NavigationLink(destination: DrawDetailView(draw: draw)) {
                        Text("Draw Date: \(draw.drawDate)")
                    }
                }

                NavigationLink(destination: TicketPurchaseView(draws: lotteryDraws)) {
                    Text("Purchase Ticket")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.top)

                NavigationLink(destination: RulesView()) {
                    Text("View Winning Rules")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.top)
            }
            .navigationTitle("Lottery Draws")
            .onAppear(perform: loadLotteryData)
        }
    }

    func loadLotteryData() {
        if let url = Bundle.main.url(forResource: "lotteryData", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let lotteryData = try decoder.decode(LotteryData.self, from: data)
                self.lotteryDraws = lotteryData.draws
            } catch {
                print("Error decoding JSON: (error)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
