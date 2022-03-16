import SwiftUI


extension Array {
	public subscript(circular index: Int) -> Element? {
		
		guard count > 0 else { return nil }
		
		let mod = index % count
		let offset = index >= 0 ? 0 : count
		let i = mod == 0 ? 0 : mod + offset
		
		return self[i]
	}
}

struct PickerRotateModifier: ViewModifier {
	let degrees: Double
	func body(content: Content) -> some View { content.rotationEffect(.degrees(degrees)) }
}

extension AnyTransition {
	static func rotate(degrees: Double) -> AnyTransition {
		return .modifier(
			active: PickerRotateModifier(degrees: degrees),
			identity: PickerRotateModifier(degrees: 0)
		)
	}
}
