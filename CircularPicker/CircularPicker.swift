import SwiftUI


struct CircularPicker<T>: View where T: Equatable {
	
	@ObservedObject var vm: CircularPickerViewModel<T>
	
	var body: some View {
		
		ZStack {
			
			let anglePerPcs: Double = 360.0 / Double(vm.pcs)
			let kerning: CGFloat = (vm.kerning / vm.diameter / 2) * 180 / .pi
			let trim: CGFloat = 0.5 / CGFloat(vm.pcs)
			
			GeometryReader { geometry in
				
				let _ = vm.center = CGPoint (x:geometry.frame(in:.local).midX, y:geometry.frame(in:.local).midY)
				
				ZStack {
					
					Circle()
						.stroke(lineWidth: 50)
						.frame(width: vm.diameter, height: vm.diameter)
						.opacity(vm.drag ? 0.12 : 0.04)
						.animation(.default, value: vm.drag)
					
					Group {
						
						ForEach (0 ..< vm.pcs, id: \.self) { itemIndex in
							
							let toHalfCount = CGFloat(vm.croppedList[itemIndex].count) / 2
							let fromHalfCount = CGFloat(vm.croppedList[circular: itemIndex + 1]!.count) / 2
							
							let to: CGFloat = (kerning * toHalfCount) / 360  + 0.007
							let from: CGFloat = (kerning * fromHalfCount) / 360  + 0.007
							
							let select = vm.croppedList[itemIndex] == vm.data[vm.index].title
							
							Group {
								
								Circle()
									.trim(from:0.25 - trim + from, to: 0.25 + trim - to)
									.stroke(lineWidth: 1)
									.frame(width: vm.diameter + 2.0, height: vm.diameter + 2.0)
									.rotationEffect(.degrees(-anglePerPcs / 2))
									.opacity(0.2)
								
								TextOnCircle(string: vm.croppedList[itemIndex], diameter: vm.diameter, kerning: vm.kerning, position: .bottom, bend: vm.bend)
									.opacity(select ? 1 : 0.3)
									.animation(.linear(duration: 0.15), value: select)
								
							}
							.rotationEffect(.degrees(-anglePerPcs * Double(itemIndex)))
							
						}
						
					}
					.id(vm.id)
					.rotationEffect(.degrees(vm.angle))
					.transition(
						.asymmetric(
							insertion: .rotate(degrees: -vm.rotateDir),
							removal:   .rotate(degrees: vm.rotateDir)
						)
							.combined(with: .opacity)
							.animation(.easeInOut(duration: 0.5))
					)
					
				}
				.contentShape(Circle().stroke(lineWidth: 80))
				.position(vm.center)
				.gesture(
					DragGesture(minimumDistance: 0, coordinateSpace: CoordinateSpace.global)
						.onChanged { value in
							vm.onDrag(position: value)
						}
						.onEnded { value in
							vm.onDragEnded()
						}
				)
				
			}
		}
	}
	
}
