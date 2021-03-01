//
//  ActorSizeChartView.swift
//  Scene Me
//
//  Created by Vince Davis on 2/17/21.
//

import SwiftUI

struct ActorSizeChartView: View {
    
    @Binding var showSheet: Bool
    var actorId: String
    @ObservedObject var viewModel: ProjectViewModel
    
    @State var actorSize = ActorSize.preview()
    
    @State var isBodyExpanded = true
    @State var isMeasurementsExpanded = true
    @State var isMeasurementsUpperExpanded = true
    @State var isMeasurementsLowerExpanded = true
    
    @State var height = ""
    @State var weight: String = ""
    @State var hairColor: String = ""
    @State var eyeColor: String = ""
    @State var shoeSize: String = ""
    @State var suitSize: String = ""
    @State var shirtSize: String = ""
    @State var pantsSize: String = ""
    @State var skirtSize: String = ""
    @State var dressSize: String = ""
    @State var head: String = ""
    @State var headNotes: String = ""
    @State var neck: String = ""
    @State var neckNotes: String = ""
    @State var shoulderWidth: String = ""
    @State var shoulderWidthNotes: String = ""
    @State var bust: String = ""
    @State var bustNotes: String = ""
    @State var chest: String = ""
    @State var chestNotes: String = ""
    @State var upperArm: String = ""
    @State var upperArmNotes: String = ""
    @State var lowerArm: String = ""
    @State var lowerArmNotes: String = ""
    @State var neckToWaistFront: String = ""
    @State var neckToWaistFrontNotes: String = ""
    @State var neckToWaistBack: String = ""
    @State var neckToWaistBackNotes: String = ""
    @State var underArmSeam: String = ""
    @State var underArmSeamNotes: String = ""
    @State var neckToFloor: String = ""
    @State var neckToFloorNotes: String = ""
    @State var waist: String = ""
    @State var waistNotes: String = ""
    @State var hips: String = ""
    @State var hipsNotes: String = ""
    @State var waistKneecap: String = ""
    @State var waistKneecapNotes: String = ""
    @State var kneeToFloor: String = ""
    @State var kneeToFloorNotes: String = ""
    @State var legOuterSeam: String = ""
    @State var legOuterSeamNotes: String = ""
    @State var inseam: String = ""
    @State var inseamNotes: String = ""
    @State var other: String = ""
    @State var otherNotes: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                SlantedBackgroundView()
                    .zIndex(1.0)
                
                List {
                    Section {
                        DisclosureGroup(isExpanded: $isBodyExpanded) {
                            FormTextFieldView2(name: "Height", placeholder: "5'9\"", text: $height)
                            FormTextFieldView2(name: "Weight", placeholder: "159 lbs", text: $weight)
                            FormTextFieldView2(name: "Hair Color", placeholder: "Black", text: $hairColor)
                            FormTextFieldView2(name: "Eye Color", placeholder: "brown", text: $eyeColor)
                            FormTextFieldView2(name: "Shoe Size", placeholder: "11", text: $shoeSize)
                            FormTextFieldView2(name: "Suit Size", placeholder: "42", text: $suitSize)
                            FormTextFieldView2(name: "Shirt Size", placeholder: "Medium", text: $shirtSize)
                            FormTextFieldView2(name: "Pants Size", placeholder: "32", text: $pantsSize)
                            FormTextFieldView2(name: "Skirt Size", placeholder: "8", text: $skirtSize)
                            FormTextFieldView2(name: "Dress Size", placeholder: "6", text: $dressSize)
                                
                        } label: {
                            Text("Body")
                                .font(.headline)
                        }
                    }
                    
                    Section {
                        DisclosureGroup(isExpanded: $isMeasurementsExpanded) {
                            FormTextFieldView3(name: "Head", placeholder: "", text: $head, note: $headNotes)
                            FormTextFieldView3(name: "Neck/Collar", placeholder: "", text: $neck, note: $neckNotes)
                            FormTextFieldView3(name: "Shoulder Width", placeholder: "", text: $shoulderWidth, note: $shoulderWidthNotes)
                            FormTextFieldView3(name: "Bust", placeholder: "", text: $bust, note: $bustNotes)
                            FormTextFieldView3(name: "Chest", placeholder: "", text: $chest, note: $chestNotes)
                        } label: {
                            Text("Measurements - Main")
                                .font(.headline)
                        }
                    }
                        
                    Section {
                        DisclosureGroup(isExpanded: $isMeasurementsUpperExpanded) {
                            FormTextFieldView3(name: "Upper Arm", placeholder: "", text: $upperArm, note: $upperArmNotes)
                            FormTextFieldView3(name: "Lower Arm", placeholder: "", text: $lowerArm, note: $lowerArmNotes)
                            FormTextFieldView3(name: "Neck to Waist Front", placeholder: "", text: $neckToWaistFront, note: $neckToWaistFrontNotes)
                            FormTextFieldView3(name: "Neck to Waist Back", placeholder: "", text: $neckToWaistBack, note: $neckToWaistBackNotes)
                            FormTextFieldView3(name: "Underarm Seam", placeholder: "", text: $underArmSeam, note: $underArmSeamNotes)
                            FormTextFieldView3(name: "Neck to Floor", placeholder: "", text: $neckToFloor, note: $neckToFloorNotes)
                        } label: {
                            Text("Measurements - Upper")
                                .font(.headline)
                        }
                    }
                        
                    Section {
                        DisclosureGroup(isExpanded: $isMeasurementsLowerExpanded) {
                            FormTextFieldView3(name: "Waist", placeholder: "", text: $waist, note: $waistNotes)
                            FormTextFieldView3(name: "Hips (7\" below waist)", placeholder: "", text: $hips, note: $hipsNotes)
                            FormTextFieldView3(name: "Waist to Kneecap", placeholder: "", text: $waistKneecap, note: $waistKneecapNotes)
                            FormTextFieldView3(name: "Knee to Floor", placeholder: "", text: $kneeToFloor, note: $kneeToFloorNotes)
                            FormTextFieldView3(name: "Leg Outer Seam", placeholder: "", text: $legOuterSeam, note: $legOuterSeamNotes)
                            FormTextFieldView3(name: "Inseam (inside leg)", placeholder: "", text: $inseam, note: $inseamNotes)
                            FormTextFieldView3(name: "Other", placeholder: "", text: $other, note: $otherNotes)
                        } label: {
                            Text("Measurements - Lower")
                                .font(.headline)
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .zIndex(2.0)
            }
            .navigationTitle("Sizes")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button("Cancel", action: { showSheet = false}),
                                trailing: Button("Save", action: { save() })
            )
            .onAppear {
                guard let newActorSize = viewModel.currentActorSize else { return }
                
                update(size: newActorSize)
            }
        }
    }
}

extension ActorSizeChartView {
    func save() {
        var isNew = false
        
        if viewModel.currentActorSize == nil {
            isNew = true
        }
        
        actorSize.actorId = actorId
        actorSize.height = height
        actorSize.weight = weight
        actorSize.hairColor = hairColor
        actorSize.eyeColor = eyeColor
        actorSize.shoeSize = shoeSize
        actorSize.suitSize = suitSize
        actorSize.shirtSize = shirtSize
        actorSize.pantsSize = pantsSize
        actorSize.skirtSize = skirtSize
        actorSize.dressSize = dressSize
        actorSize.head = head
        actorSize.headNotes = headNotes
        actorSize.neck = neck
        actorSize.shoulderWidth = shoulderWidth
        actorSize.shoulderWidthNotes = shoulderWidthNotes
        actorSize.bust = bust
        actorSize.bustNotes = bustNotes
        actorSize.chest = chest
        actorSize.chestNotes = chestNotes
        actorSize.upperArm = upperArm
        actorSize.upperArmNotes = upperArmNotes
        actorSize.lowerArm = lowerArm
        actorSize.lowerArmNotes = lowerArmNotes
        actorSize.neckToWaistFront = neckToWaistFront
        actorSize.neckToWaistFrontNotes = neckToWaistFrontNotes
        actorSize.neckToWaistBack = neckToWaistBack
        actorSize.neckToWaistBackNotes = neckToWaistBackNotes
        actorSize.underArmSeam = underArmSeam
        actorSize.underArmSeamNotes = underArmSeamNotes
        actorSize.neckToFloor = neckToFloor
        actorSize.neckToFloorNotes = neckToFloorNotes
        actorSize.waist = waist
        actorSize.waistNotes = waistNotes
        actorSize.hips = hips
        actorSize.hipsNotes = hipsNotes
        actorSize.waistKneecap = waistKneecap
        actorSize.waistKneecapNotes = waistKneecap
        actorSize.kneeToFloor = kneeToFloor
        actorSize.kneeToFloorNotes = kneeToFloorNotes
        actorSize.legOuterSeam = legOuterSeam
        actorSize.legOuterSeamNotes = legOuterSeamNotes
        actorSize.inseam = inseam
        actorSize.inseamNotes = inseamNotes
        actorSize.other = other
        actorSize.otherNotes = otherNotes
        
        if isNew {
            viewModel.add(object: actorSize)
        } else {
            viewModel.update(object: actorSize, with: actorSize.dict)
        }
        
        viewModel.fetchActorSize(for: actorId)
        showSheet = false
    }
    
    func update(size: ActorSize) {
        actorSize = size
        
        height = size.height
        weight = size.weight
        hairColor = size.hairColor
        eyeColor = size.eyeColor
        shoeSize = size.shoeSize
        suitSize = size.suitSize
        shirtSize = size.shirtSize
        pantsSize = size.pantsSize
        skirtSize = size.skirtSize
        dressSize = size.dressSize
        head = size.head
        headNotes = size.headNotes
        neck = size.neck
        neckNotes = size.neckNotes
        shoulderWidth = size.shoulderWidth
        shoulderWidthNotes = size.shoulderWidth
        bust = size.bust
        bustNotes = size.bustNotes
        chest = size.chest
        chestNotes = size.chestNotes
        upperArm = size.upperArm
        upperArmNotes = size.upperArmNotes
        lowerArm = size.lowerArm
        lowerArmNotes = size.lowerArmNotes
        neckToWaistFront = size.neckToWaistFront
        neckToWaistFrontNotes = size.neckToWaistFrontNotes
        neckToWaistBack = size.neckToWaistBack
        neckToWaistBackNotes = size.neckToWaistBackNotes
        underArmSeam = size.underArmSeam
        underArmSeamNotes = size.underArmSeamNotes
        neckToFloor = size.neckToFloor
        neckToFloorNotes = size.neckToFloorNotes
        waist = size.waist
        waistNotes = size.waistNotes
        hips = size.hips
        hipsNotes = size.hipsNotes
        waistKneecap = size.waistKneecap
        waistKneecapNotes = size.waistKneecap
        kneeToFloor = size.kneeToFloor
        kneeToFloorNotes = size.kneeToFloorNotes
        legOuterSeam = size.legOuterSeam
        legOuterSeamNotes = size.legOuterSeamNotes
        inseam = size.inseam
        inseamNotes = size.inseamNotes
        other = size.other
        otherNotes = size.otherNotes
    }
}

struct ActorSizeChartView_Previews: PreviewProvider {
    static var previews: some View {
        ActorSizeChartView(showSheet: .constant(true), actorId: "12345", viewModel: ProjectViewModel.preview())
    }
}
