import XCTest
@testable import LotteryApp

class LotteryAppTests: XCTestCase {
    
    let sampleDraws = [
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
        ),
        LotteryDraw(
            id: "draw-2",
            drawDate: "2023-05-22",
            number1: "5",
            number2: "45",
            number3: "51",
            number4: "32",
            number5: "24",
            number6: "18",
            bonusBall: "28",
            topPrize: 6000000000
        ),
        LotteryDraw(
            id: "draw-3",
            drawDate: "2023-05-29",
            number1: "34",
            number2: "21",
            number3: "4",
            number4: "58",
            number5: "1",
            number6: "15",
            bonusBall: "51",
            topPrize: 6000000000
        )
    ]
    
    let sampleNo = 0


    func testLoadLotteryData() throws {
        if let url = Bundle.main.url(forResource: "lotteryData", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let lotteryData = try decoder.decode(LotteryData.self, from: data)

                XCTAssertEqual(lotteryData.draws.count, 3)
                XCTAssertEqual(lotteryData.draws.first?.id, "draw-1")
                XCTAssertEqual(lotteryData.draws.first?.drawDate, "2023-05-15")
                XCTAssertEqual(lotteryData.draws.first?.topPrize, 4000000000)
            } catch {
                XCTFail("Failed to load and parse lottery data: (error)")
            }
        } else {
            XCTFail("Could not find lotteryData.json")
        }
    }
    
    func testEmptyLotteryData() throws {
        let emptyJSON = """
        {
          "draws": []
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let lotteryData = try decoder.decode(LotteryData.self, from: emptyJSON)

        XCTAssertEqual(lotteryData.draws.count, 0)
    }
    
    func testInvalidLotteryData() throws {
        let invalidJSON = """
        {
          "draws": [
            {"id": "draw-1", "drawDate": "2023-05-15", "number1": "2"}  // Incomplete data
          ]
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        XCTAssertThrowsError(try decoder.decode(LotteryData.self, from: invalidJSON)) { error in
            print("Expected error: (error)")
        }
    }
    
    func testGenerateTicket() {
        let ticketPurchaseView = TicketPurchaseView(draws: sampleDraws)

        ticketPurchaseView.generateTicket(for: sampleDraws[sampleNo])
        print(ticketPurchaseView.getGeneratedTicket())

        XCTAssertEqual(ticketPurchaseView.getGeneratedTicket().count, 6, "Generated ticket should have 6 numbers")

        // Ensure all numbers are unique
        let uniqueNumbers = Set(ticketPurchaseView.getGeneratedTicket())
        XCTAssertEqual(uniqueNumbers.count, 6, "All numbers in the generated ticket should be unique")
        
        // tests failed due to generatedTicket being a @state variable
        // caught generatedTicket being passed through to checkWinningTicket() and changed it so ticketNumbers is passed instead. This was tested manually and seems to work
    }
    
    func testWinningTicket() {
        let ticketPurchaseView = TicketPurchaseView(draws: sampleDraws)
        
        // Case 1: Jackpot (6 correct numbers)
        let jackpotTicket = sampleDraws[sampleNo].numbers
        let resultJackpot = ticketPurchaseView.checkWinningTicket(draw: sampleDraws[sampleNo], ticket: jackpotTicket)
        XCTAssertEqual(resultJackpot, "Congratulations! You've won the Jackpot of $\(sampleDraws[sampleNo].topPrize)!", "Should win the Jackpot")

        // Case 2: 5 correct numbers + bonus ball
        var ticketWith5AndBonus = Array(jackpotTicket.dropLast())
        ticketWith5AndBonus.append(sampleDraws[sampleNo].bonusBall)
        let result5AndBonus = ticketPurchaseView.checkWinningTicket(draw: sampleDraws[sampleNo], ticket: ticketWith5AndBonus)
        XCTAssertEqual(result5AndBonus, "Congratulations! You've won $1,000,000!", "Should win $1,000,000")

        // Case 3: 5 correct numbers (no bonus ball)
        var ticketWith5 = Array(jackpotTicket.dropLast())
        ticketWith5.append("1")  // Incorrect last number
        let result5 = ticketPurchaseView.checkWinningTicket(draw: sampleDraws[sampleNo], ticket: ticketWith5)
        XCTAssertEqual(result5, "Congratulations! You've won $1,750!", "Should win $1,750")

        // Case 4: 4 correct numbers
        var ticketWith4 = Array(jackpotTicket.dropLast(2))
        ticketWith4.append(contentsOf: ["1", "3"])  // Two incorrect numbers
        let result4 = ticketPurchaseView.checkWinningTicket(draw: sampleDraws[sampleNo], ticket: ticketWith4)
        XCTAssertEqual(result4, "Congratulations! You've won $140!", "Should win $140")

        // Case 5: 3 correct numbers
        var ticketWith3 = Array(jackpotTicket.dropLast(3))
        ticketWith3.append(contentsOf: ["1", "3", "4"])  // Three incorrect numbers
        let result3 = ticketPurchaseView.checkWinningTicket(draw: sampleDraws[sampleNo], ticket: ticketWith3)
        XCTAssertEqual(result3, "Congratulations! You've won $30!", "Should win $30")

        // Case 6: No win
        let noWinTicket = ["1", "2", "3", "4", "5", "6"]
        let resultNoWin = ticketPurchaseView.checkWinningTicket(draw: sampleDraws[sampleNo], ticket: noWinTicket)
        XCTAssertEqual(resultNoWin, "Sorry, you didn't win. Better luck next time!", "Should not win anything")
    }
    //all tests except testGeneratedTickets passed (reason for this test failing explained)
}
