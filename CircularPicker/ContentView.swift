import SwiftUI


struct ContentView: View {
	
	@ObservedObject private var countries: CircularPickerViewModel<CountryCode>
	@ObservedObject private var airports: CircularPickerViewModel<String>
	
	private let diameter: CGFloat = min(UIScreen.main.bounds.width, 550)
	private let offset: CGFloat = 70
	
	private let destinationOutMask = RadialGradient(
		gradient: Gradient(colors: [.black, .black.opacity(0)]),
		center: .top, startRadius: 100, endRadius: 300
	)
	
	init() {
		countries = CircularPickerViewModel(
			data: countriesData,
			diameter: diameter - offset,
			inertia: false,
			pcs: 7,
			kerning: 55,
			bend: true)
		
		airports = CircularPickerViewModel(
			data: countriesAndAirportsData[countriesData[0].value]!,
			diameter: diameter + offset,
			inertia: true,
			pcs: 9,
			kerning: 55,
			bend: true)
	}
	
	var body: some View {
		
		ZStack {
			
			Group {
				
				CircularPicker(vm: countries)
					.font(.custom("Menlo", size: 22))
				
				CircularPicker(vm: airports)
					.font(.custom("Menlo", size: 22))
				
			}
			.compositingGroup()
			.overlay(
				VStack {}
					.frame(width: diameter + offset * 2, height: diameter + offset * 2)
					.background(destinationOutMask)
					.blendMode(.destinationOut)
					.allowsHitTesting(false)
			)
			
			
			VStack {
				
				Text(countries.selected.rawValue)
					.font(.largeTitle .bold() .monospacedDigit())
				
				Text(airports.selected)
					.font(.title .bold() .monospacedDigit())
					.foregroundColor(.secondary)
				
			}
			.offset(y: -diameter / 2)
			
		}
		.compositingGroup()
		.onReceive(countries.$selected) { newCountry in
			if let data = countriesAndAirportsData[newCountry] {
				airports.data = data
				airports.toIndex(to: airports.data[0].value, from: countries.angleDelta * 8)
			}
		}
		
	}
	
	
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
