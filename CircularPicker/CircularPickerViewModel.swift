import SwiftUI


struct CircularPickerData<T> {
	let value: T
	let title: String
}


class CircularPickerViewModel<T>: ObservableObject where T: Equatable {
	
	// External vars
	var data: [CircularPickerData<T>] { didSet { self.id = UUID() } }
	var inertia: Bool
	var pcs: Int
	var diameter: CGFloat
	var kerning: CGFloat
	var bend: Bool
	
	// Internal vars
	@Published var selected: T
	@Published var angle: Double = 0.0
	
	var id: UUID = UUID()
	var croppedList: [String] = []
	var drag = false
	var index: Int = 0 { didSet {
		selected = data[index].value
		updateCroppedList()
	} }
	var circularIndex = 0
	var angleDelta: Double = 0.0
	var rotateDir: Double = 0
	var center = CGPoint.zero
	private var previousLocation = CGPoint.zero
	private var currentLocation = CGPoint.zero
	private var selectionFeedback: UISelectionFeedbackGenerator? = nil
	
	
	init(
		data: [CircularPickerData<T>],
		diameter: CGFloat,
		inertia: Bool? = nil,
		pcs: Int? = nil,
		kerning: CGFloat,
		bend: Bool? = nil
	) {
		self.data = data
		self.diameter = diameter
		self.inertia = inertia ?? true
		self.pcs = pcs ?? 12
		self.kerning = kerning
		self.bend = bend ?? true
		self.selected = data[0].value
		
		updateCroppedList()
		
		let displayLink = CADisplayLink(target: self, selector: #selector(onDisplayLink))
		displayLink.add(to: .current, forMode: RunLoop.Mode.default)
	}
	
	
	private var frameDuration: CFTimeInterval = 0
	@objc private func onDisplayLink(displayLink: CADisplayLink) {
		frameDuration = displayLink.targetTimestamp - displayLink.timestamp
		onFrame()
	}
	
	
	private func updateCroppedList() {
		var croppedArray = [String]()
		for i in 0 ... pcs / 2 { croppedArray.append(data[circular: index + i]!.title) }
		for i in (1 ... pcs / 2).reversed() { croppedArray.append(data[circular: index - i]!.title) }
		rotate(&croppedArray, circularIndex)
		croppedList = croppedArray
	}
	
	func onDrag(position: DragGesture.Value) {
		if !drag {
			drag = true
			previousLocation = position.location
			selectionFeedback = UISelectionFeedbackGenerator()
			selectionFeedback?.prepare()
		}
		currentLocation = position.location
	}
	
	
	func onDragEnded() {
		drag = false
		toFixedPosition()
	}
	
	
	private func onFrame() {
		if drag {
			angleDelta = angleBetween3Points(a: currentLocation, b: previousLocation, c: center)
			previousLocation = currentLocation
			onAngleDelta()
		} else if angleDelta != 0 {
			angleDelta -= angleDelta * frameDuration * 1.5
			onAngleDelta()
		}
	}
	
	
	private func onAngleDelta() {
		
		angle += angleDelta
		
		let bit = ((angle - 180 / Double(pcs)) / ((360 / Double(pcs)))).rounded(.up)
		if (bit.truncatingRemainder(dividingBy: 1) == 0 && Int(bit) != circularIndex){
			
			circularIndex = Int(bit)
			circularIndexToIndex()
			
			selectionFeedback?.selectionChanged()
			selectionFeedback?.prepare()
		}
		
		toFixedPosition()
	}
	
	
	private func circularIndexToIndex() {
		let mod = circularIndex % data.count
		let offset = circularIndex >= 0 ? 0 : data.count
		index = mod == 0 ? 0 : mod + offset
	}
	
	
	private func toFixedPosition() {
		if (angleDelta.magnitude < 0.3 || !inertia) && !drag {
			angleDelta = 0
			withAnimation(.spring(response: 0.65, dampingFraction: 0.65)) {
				angle = (360 / Double(pcs)) * Double(circularIndex)
			}
			selectionFeedback = nil
			UIImpactFeedbackGenerator(style: .soft).impactOccurred()
		}
	}
	
	
	func toIndex(to: T, from: Double = 0) {
		let closestIndex = data.firstIndex(where: { $0.value == to }) ?? 0
		circularIndex = closestIndex
		index = closestIndex
		rotateDir = from
		angleDelta = 0
		angle = (360 / Double(pcs)) * Double(circularIndex)
	}
	
}
