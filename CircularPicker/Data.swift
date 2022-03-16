import Foundation


enum CountryCode: String {
	case RU, BY, CN, IN
}


let countriesData = [
	CircularPickerData(value: CountryCode.RU, title: "Russia"),
	CircularPickerData(value: CountryCode.BY, title: "Belarus"),
	CircularPickerData(value: CountryCode.CN, title: "China"),
	CircularPickerData(value: CountryCode.IN, title: "India"),
]


let countriesAndAirportsData: [CountryCode: [CircularPickerData<String>]] = [
	
	CountryCode.RU: [
		CircularPickerData(value: "SVO", title: "Moscow"),
		CircularPickerData(value: "LED", title: "Petersburg"),
		CircularPickerData(value: "AER", title: "Sochi"),
		CircularPickerData(value: "SVX", title: "Yekaterinburg"),
	],
	
	CountryCode.BY: [
		CircularPickerData(value: "MSQ", title: "Minsk"),
		CircularPickerData(value: "BQT", title: "Brest"),
		CircularPickerData(value: "GME", title: "Gomel"),
		CircularPickerData(value: "GNA", title: "Grodno"),
	],
	
	CountryCode.CN: [
		CircularPickerData(value: "PEK", title: "Beijing"),
		CircularPickerData(value: "CAN", title: "Guangzhou"),
		CircularPickerData(value: "HAK", title: "Haikou"),
		CircularPickerData(value: "SHA", title: "Shanghai"),
	],
	
	CountryCode.IN: [
		CircularPickerData(value: "DEL", title: "New Delhi"),
		CircularPickerData(value: "BOM", title: "Mumbai"),
		CircularPickerData(value: "BLR", title: "Bengaluru"),
		CircularPickerData(value: "HYD", title: "Hyderabad"),
	],
	
]
