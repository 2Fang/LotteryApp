import SwiftUI

struct TicketPurchaseView: View {
    let draws: [LotteryDraw]
    @State private var selectedDraw: LotteryDraw?
    @State private var generatedTicket: [String] = []
    @State private var resultMessage: String?

    var body: some View {
        VStack {
            Picker("Select Draw Date", selection: $selectedDraw) {
                ForEach(draws) { draw in
                    Text(draw.drawDate).tag(Optional(draw))
                }
            }
            .pickerStyle(WheelPickerStyle())
            .padding()

            if let selectedDraw = selectedDraw {
                Button("Generate Ticket") {
                    generateTicket(for: selectedDraw)
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding(.top)
            }

            if !generatedTicket.isEmpty {
                VStack(alignment: .leading) {
                    Text("Your Ticket: \(generatedTicket.joined(separator: ", "))")
                    Text("Winning Numbers: \(selectedDraw?.numbers.joined(separator: ", ") ?? "")")
                    Text("Bonus Ball: \(selectedDraw?.bonusBall ?? "")")
                }
                .padding(.top)
            }

            if let resultMessage = resultMessage {
                Text(resultMessage)
                    .padding(.top)
                    .font(.headline)
            }
        }
        .navigationTitle("Purchase Ticket")
        .padding()
    }
    
    func getGeneratedTicket() -> [String] {
        return generatedTicket
    }
    
    func getSelectedDraw() -> LotteryDraw? {
        return selectedDraw
    }
    
    func setSelectedDraw(draw: LotteryDraw?) {
        selectedDraw = draw
    }
    
    func getResultMessage() -> String? {
        return resultMessage
    }

    func generateTicket(for draw: LotteryDraw) {
        let ticketNumbers = (1...59).map { String($0) }.shuffled().prefix(6).sorted()
        generatedTicket = Array(ticketNumbers)
        resultMessage = checkWinningTicket(draw: draw, ticket: Array(ticketNumbers))
    }

    func checkWinningTicket(draw: LotteryDraw, ticket: [String]) -> String {
        let matchedNumbers = ticket.filter { draw.numbers.contains($0) }.count
        let matchedBonusBall = draw.bonusBall == ticket.last

        switch matchedNumbers {
        case 6:
            return "Congratulations! You've won the Jackpot of $\(draw.topPrize)!"
        case 5 where matchedBonusBall:
            return "Congratulations! You've won $1,000,000!"
        case 5:
            return "Congratulations! You've won $1,750!"
        case 4:
            return "Congratulations! You've won $140!"
        case 3:
            return "Congratulations! You've won $30!"
        default:
            return "Sorry, you didn't win. Better luck next time!"
        }
    }
}

struct TicketPurchaseView_Previews: PreviewProvider {
    static var previews: some View {
        TicketPurchaseView(draws: [
            LotteryDraw(
                id: "draw-1",
                drawDate: "2023-05-15",
                number1: "2",
                number2: "16",
                number3: "23",
                number4: "44",
                number5: "47",
                number6: "52",
                bonusBall: "14",
                topPrize: 4000000000
            )
        ])
    }
}
