import SwiftUI

struct searches: View {
	func fillArray() {
		if randomIndex.count < 5 {
			randomIndex = getRandIndexes()
		}
		
		for x in randomIndex {
			products.append(getProducts(type: "Search", index: x))
			randomIndex.remove(x)
			
			if(products.count > call_size) {
				return
			}
		}
	}
	
	func pressed(upper: Bool) {
		if ((upper && products[0].value <= products[1].value) || (!upper && products[0].value >= products[1].value)) {
			products.remove(at: 0)
			score += 1
		} else {
			highScore = max(highScore, score)
			UserDefaults.standard.set(highScore, forKey: "HighScoreSearch")
			score = 0
			products = products_empty
			fillArray()
			products.remove(at: 0)
			products.remove(at: 0)
		}
		
		if products.count <= 4 {
			fillArray()
		}
		
		return
	}
	
	@State private var randomIndex = Set<Int>()
	@State private var score: Int = 0
	@State private var highScore: Int = 0
	@State private var products: [Product] = products_empty
	
	private var bounds = UIScreen.main.bounds
	
    var body: some View {
		ZStack {
//			Score
			VStack {
				HStack {
					Text("Score: \(score)").bold().padding()
					Spacer()
					Text("High Score: \(highScore)").bold().padding()
				}.padding()
				
				Spacer()
			}
			
//			Texts
			VStack {
				Spacer()
				
				VStack {
					Text("\"\(products[0].name)\"")
						.font(Font.title2)
						.bold()
						.padding()
					Text("has")
						.font(Font.caption)
					Text("\(Int(products[0].value))")
						.font(Font.largeTitle)
						.bold()
						.padding(1)
						.foregroundColor(.yellow)
					Text("average monthly searches")
						.font(Font.caption)
				}
				
				Spacer()
				
				VStack {
					Text("\"\(products[1].name)\"")
						.font(Font.title2)
						.bold()
						.padding()
					Text("has")
						.font(Font.caption)
					Text("???")
						.font(Font.largeTitle)
						.bold()
						.padding(1)
						.foregroundColor(.yellow)
					Text("average monthly searches")
						.font(Font.caption)
				}
				
				Spacer()
			}
		
//			Rectangles
			VStack {
				Rectangle()
					.size(width: bounds.width, height: bounds.height / 2)
					.foregroundColor(.blue)
					.ignoresSafeArea()
					.opacity(0.1)
					.onTapGesture { pressed(upper: false) }
				Rectangle()
					.size(width: bounds.width, height: bounds.height / 2)
					.foregroundColor(.red)
					.ignoresSafeArea()
					.opacity(0.1)
					.onTapGesture { pressed(upper: true) }
			}
			
//			Buttons
			VStack {
				Spacer()
				HStack {
					Spacer()
					Button {
						pressed(upper: true)
					} label: {
						Label("HIGHER", systemImage: "arrowtriangle.up.fill")
					}.buttonStyle(GrowingButton())
					Spacer()
					Button {
						pressed(upper: false)
					} label: {
						Label("LOWER", systemImage: "arrowtriangle.down.fill")
					}.buttonStyle(GrowingButton())
					Spacer()
				}
				Spacer()
			}
		}.onAppear{
			highScore = UserDefaults.standard.integer(forKey: "HighScoreSearch")
			(minimum, maximum) = setupConnection(type: "Search")
			randomIndex = getRandIndexes()
			fillArray()
			products.remove(at: 0)
			products.remove(at: 0)
		}
	}
}
