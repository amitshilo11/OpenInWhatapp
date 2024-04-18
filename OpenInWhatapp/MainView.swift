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
               LogoView()
               Spacer()
               PhoneNumberInputView(inputText: $inputText, 
                                    shouldPromptForPaste: $shouldPromptForPaste,
                                    onPaste: handlePaste)
               if !submittedText.isEmpty {
                   SubmittedTextView(submittedText: submittedText)
               }
               Spacer()
           }
           .padding()
       }
        .keyboardResponsive()
        .background(GradientBackground())
        .edgesIgnoringSafeArea(.all)
    }
    
    func submitText() {
          submittedText = inputText
          
          // Optionally, clear the text field
          inputText = ""
      }
    
    func handlePaste() {
        inputText = UIPasteboard.general.string ?? ""
        shouldPromptForPaste = false
    }

}

struct LogoView: View {
    var body: some View {
        Image("logo")
            .resizable()
            .scaledToFit()
            .frame(minWidth: 100, maxWidth: 200)
    }
}

struct PhoneNumberInputView: View {
    @Binding var inputText: String
    @Binding var shouldPromptForPaste: Bool
    var onPaste: () -> Void

    var body: some View {
        HStack {
            TextField("Phone number", text: $inputText)
                .padding()
                .keyboardType(.numberPad)
                .background(TextFieldBackground())
                .cornerRadius(10)
                .padding()
                .onTapGesture {
                    checkClipboardForPhoneNumber()
                }

            if shouldPromptForPaste {
                Button("Paste from Clipboard", action: onPaste)
                    .buttonStyle(PasteButtonStyle())
            }

            Button("Open", action: {
                openWhatsApp(number: inputText)
            })
            .buttonStyle(OpenButtonStyle())
        }
        
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

struct SubmittedTextView: View {
    let submittedText: String

    var body: some View {
        Text("Submitted text: \(submittedText)")
            .padding()
    }
}

struct TextFieldBackground: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .stroke(Color("green"), lineWidth: 4)
            .background(Color.white.opacity(0.5))
    }
}

struct PasteButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundColor(.white)
            .background(Color("green"))
            .cornerRadius(10)
    }
}

struct OpenButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundColor(.white)
            .background(Color("green"))
            .cornerRadius(10)
    }
}

struct GradientBackground: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color("primary"), Color("secondary")]), startPoint: .top, endPoint: .bottom)
    }
}

extension View {
    func keyboardResponsive() -> some View {
        self.modifier(KeyboardResponsiveModifier())
    }
}

#Preview {
    MainView()
}
