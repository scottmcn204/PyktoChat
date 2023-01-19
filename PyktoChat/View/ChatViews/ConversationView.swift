//
//  ConversationView.swift
//  PyktoChat
//
//  Created by Scott McNally on 18/01/2023.
//

import SwiftUI

struct ConversationView: View {
    @Binding var isChatShowing: Bool
    @State var participants = [User]()
    @State private var currentLine = Line()
    @State private var lines: [Line] = []
    @State private var selectedColor: Color = .black
    @EnvironmentObject var chatViewModel: ChatViewModel
    @EnvironmentObject var contactsViewModel: ContactsViewModel

    
    
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
               self.currentLine = Line(points: [], color: selectedColor)
           })
       ).frame(width: 400,height: 200)
    }
    
    func undoDraw(lines: [Line]){
        if self.lines.count > 10{
            self.lines.removeLast(10)
        }
        else if self.lines.count > 0{
            self.lines.removeAll()
        }

    }
    
    func clearDraw(lines: [Line]){
        if self.lines.count > 0{
            self.lines.removeAll()
        }
    }
    
    var body: some View {
        ZStack {
            Color("background")
                .ignoresSafeArea()
            VStack {
                HStack {
                    Button{
                        isChatShowing = false
                    } label: {
                        Image(systemName: "chevron.backward.circle.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(Color(.lightGray))
                    }.padding(.leading, 10)
                    
                    Spacer()
                    if participants.count > 0{
                        Text((participants.first!.firstName ?? "" ) + " " + (participants.first!.lastName ?? ""))
                            .font(Font.titleText1)
                    }
                    
                    Spacer()
                    if participants.count > 0{
                        ProfilePicView(participant: participants.first!).padding(.trailing, 10)
                    }
                }
                .padding(.top)
                
                Divider()
                
                ScrollView{
                    VStack(spacing: 10) {
                        ForEach(chatViewModel.messages) { message in
                            let isFromUser = message.senderId == AuthViewModel.getLoggedInUserId()
                            DrawBubbleView(imageURL: message.imageURL, isFromUser: isFromUser )
                            
                        }
                        
                    }.padding(.top, 5)
                }.frame(width: 410)
            
                HStack{
                    Button{
                        clearDraw(lines: lines)
                    } label: {
                        Image(systemName: "x.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color(.lightGray))
                    } .padding(.leading, 10)
                    Button{
                        undoDraw(lines: lines)
                    } label: {
                        Image(systemName: "arrow.uturn.backward.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color(.lightGray))
                            
                    }
                    ColorPickerView(selectedColor: $selectedColor)
                        .onChange(of: selectedColor) { newColor in
                            currentLine.color = newColor
                        }
                    Spacer()
                    Button{
                        // send
                        let renderer = ImageRenderer(content: canvasArea)
                        let image = renderer.uiImage ?? UIImage()
                        chatViewModel.sendDrawing(drawing: image)
                        clearDraw(lines: lines)
                    } label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .resizable()
                            .frame(width: 45, height: 45)
                    } .padding(.trailing, 10)
                }
                
                ZStack {
                    VStack {
                        Spacer()
                        Rectangle()
                            .frame(width: 400, height: 1)
                            .padding(.top, 20)
                        Spacer()
                        Rectangle()
                            .frame(width: 400, height: 1)
                        Spacer()
                        Rectangle()
                            .frame(width: 400, height: 1)
                        Spacer()
                        Rectangle()
                            .frame(width: 400, height: 1)
                        Spacer()
                    }.foregroundColor(.blue)
                    canvasArea
                        .cornerRadius(25).overlay(RoundedRectangle(cornerRadius: 25).stroke(Color("inputFieldIcons"), lineWidth: 4 ))
                    .padding(.top, 15)
                }.frame(height: 200)
            }.padding(.horizontal, 30)
                .onAppear{
                    chatViewModel.getMessages()
                    let ids = chatViewModel.getParticipantIds()
                    self.participants = contactsViewModel.getParticipantsGivenIds(ids: ids)

                }
        }
    }
}

struct ConversationView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationView(isChatShowing: .constant(true)).environmentObject(ChatViewModel()).environmentObject(ContactsViewModel())
    }
}
