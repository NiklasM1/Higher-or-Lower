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
	
	func getItem(type: product_type, id: Int, completion: @escaping (_ json: Any?, _ error: Error?)->()) {
		let json: [String: Any] = ["type": type.rawValue, "id": id]
		let jsonData = try? JSONSerialization.data(withJSONObject: json)
		
		let url = URL(string: "http://spacem.cc:6000/HigherOrLower.php")!
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.httpBody = jsonData
		
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			guard let data = data, error == nil else {
				completion(nil, error)
				return
			}
			let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
			if responseJSON is [String: Any] {
				let dataArray = responseJSON as! [String: Any]
				completion(dataArray, nil)
			}
		}
		
		task.resume()
	}
	
	func getRandNum(count: Int = 50) -> [Int] {
		var maximum = 10
		let group = DispatchGroup()
		
		group.enter()
		
		DispatchQueue.global().async {
			getItem(type: type, id: 0) { json, error in
				if error != nil {
					debugPrint(error?.localizedDescription ?? "No data")
				} else {
					let data = json as! [String: Any]
					maximum = Int(data["COUNT(*)"] as? String ?? "") ?? 0
				}
				group.leave()
			}
		}
		
		group.wait()
		
		var set = Set<Int>()
		while set.count < min(count, maximum-1) {
			set.insert(Int.random(in: 1...maximum))
		}
		return Array(set)
	}
	
	func fillArray() {
		let group = DispatchGroup()
		
		group.enter()
		
		DispatchQueue.global().async {
			getItem(type: type, id: randomNumbers.popLast()!) { json, error in
				if error != nil {
					debugPrint(error?.localizedDescription ?? "No data")
					products.append(Product(name: "error", value: 0))
				} else {
					let data = json as! [String: Any]
					
//					var id = Int(data["id"] as? String ?? "") ?? 0
					let name = data["name"] as? String ?? ""
					let value = Double(data["value"] as? String ?? "") ?? 0
					var picture = ""
					var source = ""
					
					if let pictureTemp = data["picture"] as? String {
						picture = pictureTemp
					}
					
					if let sourceTemp = data["source"] as? String {
						source = sourceTemp
					}
					
					debugPrint(name)
					products.append(Product(name: name, description: source, value: value, picture_string: picture, type: product_type.Empty))
				}
				group.leave()
			}
		}
		
		group.wait()
		
		if randomNumbers.count == 0 {
			randomNumbers = getRandNum()
		}
		
		if products.count <= 5 {
			fillArray()
		} else {
			for (index, x) in products.enumerated() {
				if x.name == "error" && products.count >= 3 { products.remove(at: index) }
			}
			for (index, x) in products.enumerated() {
				if x.name == "error" && products.count >= 3 { products.remove(at: index) }
			}
			for (index, x) in products.enumerated() {
				if x.name == "error" && products.count >= 3 { products.remove(at: index) }
			}
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
	@Environment(\.presentationMode) var presentationMode

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
					Spacer()
					
					Button {
						presentationMode.wrappedValue.dismiss()
					} label: {
						Label("", systemImage: "x.circle")
					}.padding().scaleEffect(1.3)
				}
				
				Spacer()
				
				HStack {
					Text("Score: \(score)").bold().padding()
					Spacer()
					Text("High Score: \(highScore)").bold().padding()
				}.padding()
			}
			
//			Texts
			VStack {
				Spacer()
				
				VStack {
					Text("\"\(products[0].name)\"")
						.font(Font.title2)
						.bold()
						.lineLimit(1)
						.padding()
					Text(texts[0][type_index])
						.font(Font.caption)
					if type == .Price {
						Text("\(Double(products[0].value), specifier: "%.2f")$")
							.font(Font.largeTitle)
							.bold()
							.padding(1)
							.foregroundColor(.yellow)
					} else {
						Text("\(Int(products[0].value))")
							.font(Font.largeTitle)
							.bold()
							.padding(1)
							.foregroundColor(.yellow)
					}
					
					Text(texts[1][type_index])
						.font(Font.caption)
				}
				
				Spacer()
				
				VStack {
					Text("\"\(products[1].name)\"")
						.font(Font.title2)
						.bold()
						.lineLimit(1)
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
			randomNumbers = getRandNum()
			fillArray()
		}
	}
}
