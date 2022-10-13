//
//  ContentView.swift
//  Scrumdinger
//

//

import SwiftUI

struct MeetingsView: View {
    var body: some View {
        VStack {
            ProgressView(value: 5, total: 15)
            HStack(){
                VStack(alignment: .leading) {
                    Text("seconds elapsed")
                        .font(.caption)
                    Label("300", systemImage: "hourglass.bottomhalf.fill")
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("seconds remaining")
                        .font(.caption)
                    Label("600", systemImage: "hourglass.tophalf.fill")
                }
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Time remaining")
            .accessibilityValue("10 mins")
            Circle()
                .stroke(lineWidth: 24)
            HStack {
                Text("Speaker 1 of 3")
                Spacer()
                Button(action: {}){
                    Image(systemName: "forward.fill")
                }
                .accessibilityLabel("next speaker")
            }
        }.padding()
    }
}

struct MeetingView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingsView().previewDevice("iPhone 11")
    }
}
