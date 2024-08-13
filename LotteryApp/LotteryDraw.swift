import Foundation

struct LotteryDraw: Codable, Identifiable, Hashable {
    let id: String
    let drawDate: String
    let number1: String
    let number2: String
    let number3: String
    let number4: String
    let number5: String
    let number6: String
    let bonusBall: String
    let topPrize: Int
    
    var numbers: [String] {
        return [number1, number2, number3, number4, number5, number6]
    }
    
    enum CodingKeys: String, CodingKey {
        case id, drawDate, number1, number2, number3, number4, number5, number6, bonusBall = "bonus-ball", topPrize
    }
}

struct LotteryData: Codable {
    let draws: [LotteryDraw]
}
