import SwiftUI

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
			Menu()
//			searches(type: product_type.Search)
        }
    }
}

struct GrowingButton: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.padding()
			.background(Color.blue)
			.foregroundColor(.white)
			.clipShape(Capsule())
			.scaleEffect(configuration.isPressed ? 1.2 : 1)
			.animation(.easeOut(duration: 0.2), value: configuration.isPressed)
	}
}
