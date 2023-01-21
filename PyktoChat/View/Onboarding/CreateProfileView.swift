//
//  CreateProfileView.swift
//  PyktoChat
//
//  Created by Scott McNally on 13/01/2023.
//

import SwiftUI

struct CreateProfileView: View {
    @Binding var currentStep: OnboardingStep
    @State var firstName = ""
    @State var lastName = ""
    @State var isSaveButtonDisabled = false
    @State private var currentLine = Line()
    @State private var lines: [Line] = []
    @State var errorLabelVisible = false
    @State var errorMessage = ""
    
    var canvasArea: some View{
       return Canvas{ context, size in
           for line in lines{
               var path = Path()
               path.addLines(line.points)
               context.stroke(path, with: .color(line.color), lineWidth: line.lineWidth)
           }
               
       }.gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local).onChanged({ value in
               let newPoint = value.location
               currentLine.points.append(newPoint)
               self.lines.append(currentLine)
           })
           .onEnded({ value in
               self.currentLine = Line(points: [])
           })
       ).frame(width: 200,height: 200)
   }
    
    var body: some View {
        VStack{
            Text("Setup Profile")
                .font(Font.titleText1)
                .padding(.top, 52)
            Text("Just a few more things to get started")
                .font(Font.bodyParagraph)
                .padding(.top, 12)
            Text("Start off with a little picture to denote yourself")
                .font(Font.bodyParagraph)
                .padding(.top, 12)
            canvasArea.cornerRadius(200).overlay(RoundedRectangle(cornerRadius: 200).stroke(.blue, lineWidth: 4 ))
                .padding(.top, 15)
            Spacer()
            ZStack{
                Rectangle()
                    .foregroundColor(Color("inputField"))
                    .cornerRadius(8)
                    .frame(height: 46)
                TextField("First Name", text: $firstName).padding()
                    .foregroundColor(Color("secondaryText"))
//                    .placeholder(when: firstName.isEmpty) {
//                        Text("First Name")
//                            .foregroundColor(Color("secondaryText"))
//                    }
            }
            ZStack{
                Rectangle()
                    .foregroundColor(Color("inputField"))
                    .cornerRadius(8)
                    .frame(height: 46)
                TextField("Last Name", text: $lastName).padding()
                    .foregroundColor(Color("secondaryText"))
//                .placeholder(when: lastName.isEmpty) {
//                    Text("Last Name")
//                        .foregroundColor(Color("secondaryText"))
//                }
            }
            Text(errorMessage).foregroundColor(.red).font(Font.smallText)
                .padding(.top)
                .opacity(errorLabelVisible ? 1 : 0)
            Spacer()
            Button{
                errorLabelVisible = false
                guard !firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else{
                    errorMessage = "Please enter in first and last name"
                    errorLabelVisible = true
                    return
                }
                let renderer = ImageRenderer(content: canvasArea)
                let image = renderer.uiImage
                isSaveButtonDisabled = true
                DatabaseService().setUserProfile(firstName: firstName, lastName: lastName, profilePic: image) { isSuccess in
                    if isSuccess{
                        currentStep = .contacts
                            
                    }
                    else{
                        errorMessage = "Error occured, please try again"
                        errorLabelVisible = true
                    }
                    isSaveButtonDisabled = false

                }


            } label:{
                Text(isSaveButtonDisabled ? "Uploading..." : "Save")
            }
            .buttonStyle(OnboardingButtonStyle())
            .padding(.bottom, 87)
            .disabled(isSaveButtonDisabled)
        }
        .padding(.horizontal)
    }
}

struct CreateProfileView_Previews: PreviewProvider {
    static var previews: some View {
        CreateProfileView(currentStep: .constant(.profile))
    }
}
