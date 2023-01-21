//
//  ConversationView.swift
//  PyktoChat
//
//  Created by Scott McNally on 18/01/2023.
//

import SwiftUI

struct ConversationView: View {
    @Binding var isChatShowing: Bool
    @State var isEmptyCanvas : Bool
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
                self.isEmptyCanvas = false
               let newPoint = value.location
               currentLine.points.append(newPoint)
               self.lines.append(currentLine)
           })
           .onEnded({ value in
               self.currentLine = Line(points: [], color: selectedColor)
           })
       ).frame(width: 370,height: 200)
    }
    
    func undoDraw(lines: [Line]){
        if self.lines.count > 10{
            self.lines.removeLast(10)
        }
        else if self.lines.count > 0{
            self.lines.removeAll()
            self.isEmptyCanvas = true
        }

    }
    
    func clearDraw(lines: [Line]){
        if self.lines.count > 0{
            self.lines.removeAll()
            self.isEmptyCanvas = true
        }
    }
    
    var body: some View {
        ZStack {
            Color(.green)
                .opacity(0.2)
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
                
                ZStack {
                    Color(.gray)
                        .opacity(0.3)
                    ScrollViewReader{ proxy in
                        ScrollView{
                            VStack(spacing: 10) {
                                ForEach(Array(chatViewModel.messages.enumerated()), id: \.element) { index, message in
                                    let isFromUser = message.senderId == AuthViewModel.getLoggedInUserId()
                                    DrawBubbleView(imageURL: message.imageURL, isFromUser: isFromUser )
                                        .padding(.bottom, 5)
                                        .id(index)
                                    
                                    
                                }
                                
                            }
                        }.frame(maxWidth: .infinity)
                            .onChange(of: chatViewModel.messages.count) { newCount in
                                withAnimation {
                                    proxy.scrollTo(newCount-1)
                                }
                            }
                    }
                }.cornerRadius(25)
                
            
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
                            .foregroundColor(isEmptyCanvas ? Color("drawingOuter") : .red )
                    } .padding(.trailing, 10)
                        .disabled(isEmptyCanvas)
                }.padding([.bottom, .top], 1)
                
                ZStack() {
                    Rectangle()
                        .frame(width: 370, height: 200)
                        .foregroundColor(.white)
                        .cornerRadius(25)
                    VStack {
                        Spacer()
                        Rectangle()
                            .frame(width: 370, height: 1)
                            //.padding()
                        Spacer()
                        Rectangle()
                            .frame(width: 370, height: 1)
                        Spacer()
                        Rectangle()
                            .frame(width: 370, height: 1)
                        Spacer()
                        Rectangle()
                            .frame(width: 370, height: 1)
                        Spacer()
                    }.foregroundColor(Color("drawingOuter"))

                    canvasArea
                        .cornerRadius(25).overlay(RoundedRectangle(cornerRadius: 25).stroke(Color("drawingOuter"), lineWidth: 4 ))
                    
                    
                }.frame(height: 200)
                    .padding(.bottom, 10)

                
            }.padding(.horizontal, 30)
                .onAppear{
                    
                    chatViewModel.getMessages()
                    let ids = chatViewModel.getParticipantIds()
                    self.participants = contactsViewModel.getParticipantsGivenIds(ids: ids)

                }
                .onDisappear{
                    chatViewModel.conversationViewClean()
                }
        }
    }
}

struct ConversationView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationView(isChatShowing: .constant(true), isEmptyCanvas: true).environmentObject(ChatViewModel()).environmentObject(ContactsViewModel())
    }
}
