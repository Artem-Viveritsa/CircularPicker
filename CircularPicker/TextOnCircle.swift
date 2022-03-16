import SwiftUI


enum TextOnCirclePosition {
	case top, bottom
}

struct TextOnCircle: View {
	
	var string: String = "Text on circle"
	var diameter: CGFloat = 300
	var kerning: CGFloat = 50
	var position: TextOnCirclePosition = .top
	var bend: Bool = true
	
	
	var body: some View {
		
		let charArray = string.map { String($0) }
		let angularOffset = Double(kerning / diameter / 2) * 180 / .pi
		let positionMultiplier: Int = position == .top ? -1 : 1
		
		if bend {
			ZStack {
				
				ForEach (charArray.indices, id: \.self) {charIndex in
					
					Text (charArray[charIndex])
						.offset(y: CGFloat(positionMultiplier) * diameter / 2)
						.rotationEffect(.degrees(Double(positionMultiplier * -charIndex) * angularOffset))
					
				}
				.rotationEffect(.degrees(Double(positionMultiplier * charArray.count - 1) * angularOffset / 2))
			}
		} else {
			Text (string)
				.offset(y: CGFloat(positionMultiplier) * diameter / 2)
		}
	}
}

struct TextOnCircle_Previews: PreviewProvider {
	static var previews: some View {
		TextOnCircle()
	}
}
