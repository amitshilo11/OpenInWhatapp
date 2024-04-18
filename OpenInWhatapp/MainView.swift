//
//  MainView.swift
//  OpenInWhatapp
//
//  Created by Amit Shilo on 06/04/2024.
//

import SwiftUI

struct MainView: View {
    @State private var inputText: String = ""
    @State private var submittedText: String = ""
    @State private var shouldPromptForPaste = false
    
    var body: some View {
        ZStack {
           Color.clear
           
           VStack {
               Spacer()
               
               Image("logo")
                   .resizable()
                   .scaledToFit()
                   .frame(minWidth: 100, maxWidth: 200)
               
               Spacer()
               
               HStack {
                   TextField("Phone number", text: $inputText)
                       .padding()
                       .background(
                           RoundedRectangle(cornerRadius: 10)
                               .stroke(Color("green"), lineWidth: 4)
                               .background(Color.white.opacity(0.5))
                       )
                       .cornerRadius(10)
//                       .keyboardType(.numberPad)
                       .padding()
                       .onTapGesture {
                                               checkClipboardForPhoneNumber()
                                           }

                   
                   if shouldPromptForPaste {
                     Button("Paste from Clipboard") {
                         inputText = UIPasteboard.general.string ?? ""
                         shouldPromptForPaste = false
                     }
                   }

                   
                   Button("Open") {
                       openWhatsApp(number: inputText)
                   }
//                   .frame(minWidth: 150, minHeight: 40)
                   .padding()
                   .foregroundColor(.white)
                   .background(Color("green"))
                   .cornerRadius(10)
               }
               
               if !submittedText.isEmpty {
                   Text("Submitted text: \(submittedText)")
                       .padding()
               }
               
               Spacer()
           }
           .padding()
       }
        .keyboardResponsive()
        .background(
                       LinearGradient(gradient: 
                                        Gradient(colors: [Color("primary"), Color("secondary")]), startPoint: .top, endPoint: .bottom)
                   )
       .edgesIgnoringSafeArea(.all)
    }
    
    func submitText() {
          submittedText = inputText
          
          // Optionally, clear the text field
          inputText = ""
      }
    
    func openWhatsApp(number: String) {
    
        let parsedNumber = parseNumber(number: number)
        let whatsappURL = URL(string: "https://wa.me/\(parsedNumber)")
        print("parsed number is: \(parsedNumber)")
        
        // Check if WhatsApp can be opened
        if let whatsappURL = whatsappURL, UIApplication.shared.canOpenURL(whatsappURL) {
            UIApplication.shared.open(whatsappURL)
        } else {
            print("Cannot open WhatsApp.")
        }
    }
    
    func parseNumber(number: String) -> String {
        if !number.hasPrefix("+") {
             return "+972" + number
        }
        else {
            return number
        }
    }
    
    func checkClipboardForPhoneNumber() {
           guard let clipboardText = UIPasteboard.general.string else {
               return
           }

           // Check if the clipboard text contains a phone number format
           let phoneNumberRegex = try? NSRegularExpression(pattern: "^\\+?[0-9]+$")
           if let regex = phoneNumberRegex, regex.numberOfMatches(in: clipboardText, range: NSRange(location: 0, length: clipboardText.count)) > 0 {
               shouldPromptForPaste = true
               print("found number in clipboard, activating shouldPromptForPaste")
           }
       }
}

#Preview {
    MainView()
}

extension View {
    func keyboardResponsive() -> some View {
        self.modifier(KeyboardResponsiveModifier())
    }
}
