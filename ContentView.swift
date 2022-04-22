import SwiftUI

struct searches: View {
	func fillArray() {
		products.append(getProducts(type: "Search", index: randomNumbers.popLast()!))
		
		if randomNumbers.count <= 0 {
			randomNumbers = getRandNum(minimum: minimum, maximum: maximum)
		}
		
		if products.count <= 3 {
			fillArray()
		}
	}
	
	func pressed(upper: Bool) {
		products.remove(at: 0)
		fillArray()
		
		if  (upper && products[0].value <= products[1].value) ||
			(!upper && products[0].value >= products[1].value) ||
			(products[0].value == 0 || products[1].value == 0) {
			score += 1
			return
		}
		
		highScore = max(highScore, score)
		UserDefaults.standard.set(highScore, forKey: "HighScoreSearch")
		score = 0
		return
	}
	
	@State private var randomNumbers: [Int] = [0]
	@State private var score: Int = 0
	@State private var highScore: Int = 0
	@State private var products: [Product] = products_empty
	
	private var bounds = UIScreen.main.bounds
	
    var body: some View {
		ZStack {
//			Pictures
			VStack {
				Image(uiImage: products[0].picture)
					.ignoresSafeArea()
				
				Image(uiImage: products[1].picture)
					.ignoresSafeArea()
			}
			
//			Rectangles
			VStack {
				Rectangle()
					.size(width: bounds.width, height: bounds.height / 2)
					.foregroundColor(.blue)
					.ignoresSafeArea()
					.opacity(0.2)
					.onTapGesture { pressed(upper: false) }
				Rectangle()
					.size(width: bounds.width, height: bounds.height / 2)
					.foregroundColor(.red)
					.ignoresSafeArea()
					.opacity(0.2)
					.onTapGesture { pressed(upper: true) }
			}
			
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
			
//			Source Link
			VStack {
				HStack {
					Spacer()
					
					Text(.init("[\(products[0].source.prefix(10))](https://\(products[0].source))"))
						.font(Font.caption)
						.padding()
					
					Spacer()
				}
				
				Spacer()
				
				
				HStack {
					Spacer()
					
					Text(.init("[\(products[1].source.prefix(10))](https://\(products[1].source))"))
						.font(Font.caption)
						.padding()
					
					Spacer()
				}
				
			}
			
//			Buttons
			VStack {
				Spacer()
				HStack {
					Spacer()
					Button {
						pressed(upper: false)
					} label: {
						Label("LOWER", systemImage: "arrowtriangle.down.fill")
					}.buttonStyle(GrowingButton())
					Spacer()
					Button {
						pressed(upper: true)
					} label: {
						Label("HIGHER", systemImage: "arrowtriangle.up.fill")
					}.buttonStyle(GrowingButton())
					Spacer()
				}
				Spacer()
			}
		}.onAppear{
			highScore = UserDefaults.standard.integer(forKey: "HighScoreSearch")
			(minimum, maximum) = setupConnection(type: "Search")
			randomNumbers = getRandNum(minimum: minimum, maximum: maximum)
			fillArray()
			products.remove(at: 0)
			products.remove(at: 0)
		}
	}
}
