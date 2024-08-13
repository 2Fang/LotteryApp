import SwiftUI

struct DrawDetailView: View {
    let draw: LotteryDraw

    var body: some View {
        VStack(alignment: .leading) {
            Text("Draw Date: \(draw.drawDate)")
                .font(.headline)
            Text("Numbers: \(draw.numbers.joined(separator: ", "))")
            Text("Bonus Ball: \(draw.bonusBall)")
            Text("Top Prize: \(draw.topPrize)")
        }
        .padding()
        .navigationTitle("Draw Details")
    }
}

struct DrawDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DrawDetailView(draw: LotteryDraw(
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
        ))
    }
}
