import SwiftUI

struct searches: View {
	init(type: product_type) {
		self.type = type
		
		switch type {
			case .Views:
				self.type_index = 0
			case .Price:
				self.type_index = 1
			case .Search:
				self.type_index = 2
			case .Empty:
				self.type_index = 3
		}
	}
	
	func fillArray() {
		products.append(getProduct(table_type: type, index: randomNumbers.popLast()!))
		
		if randomNumbers.count <= 0 {
			randomNumbers = getRandNum(minimum: minimum, maximum: maximum)
		}
		
		if products.count <= 3 {
			fillArray()
		}
	}
	
	func pressed(higher: Bool) {
		if (higher && products[0].value <= products[1].value) ||
			(!higher && products[0].value >= products[1].value) {
			products.remove(at: 0)
			fillArray()
			score += 1
			return
		}
		
		products.remove(at: 0)
		fillArray()
		
		highScore = max(highScore, score)
		UserDefaults.standard.set(highScore, forKey: "HS\(type.rawValue)")
		score = 0
		return
	}
	
	@State private var randomNumbers: [Int] = [0]
	@State private var score: Int = 0
	@State private var highScore: Int = 0
	@State private var products: [Product] = products_empty

	var type: product_type
	var type_index: Int
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
					.onTapGesture { pressed(higher: false) }
				Rectangle()
					.size(width: bounds.width, height: bounds.height / 2)
					.foregroundColor(.red)
					.ignoresSafeArea()
					.opacity(0.2)
					.onTapGesture { pressed(higher: true) }
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
					Text(texts[0][type_index])
						.font(Font.caption)
					Text("\(Int(products[0].value))")
						.font(Font.largeTitle)
						.bold()
						.padding(1)
						.foregroundColor(.yellow)
					Text(texts[1][type_index])
						.font(Font.caption)
				}
				
				Spacer()
				
				VStack {
					Text("\"\(products[1].name)\"")
						.font(Font.title2)
						.bold()
						.padding()
					Text(texts[0][type_index])
						.font(Font.caption)
					Text("???")
						.font(Font.largeTitle)
						.bold()
						.padding(1)
						.foregroundColor(.yellow)
					Text(texts[1][type_index])
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
						pressed(higher: false)
					} label: {
						Label("LOWER", systemImage: "arrowtriangle.down.fill")
					}.buttonStyle(GrowingButton())
					Spacer()
					Button {
						pressed(higher: true)
					} label: {
						Label("HIGHER", systemImage: "arrowtriangle.up.fill")
					}.buttonStyle(GrowingButton())
					Spacer()
				}
				Spacer()
			}
		}.onAppear{
			highScore = UserDefaults.standard.integer(forKey: "HighScoreSearch")
			(minimum, maximum) = setupConnection(table_type: type)
			randomNumbers = getRandNum(minimum: minimum, maximum: maximum)
			fillArray()
			products.remove(at: 0)
			products.remove(at: 0)
		}
	}
}
