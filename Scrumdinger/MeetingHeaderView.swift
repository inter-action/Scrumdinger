//

import Foundation
import SwiftUI


struct MeetingHeaderView: View {
    let secondsElapsed: Int
    let secondsRemaining: Int
    let theme: Theme
    
    private var totalSeconds: Int {
        return secondsElapsed + secondsRemaining
    }
    
    private var progress: Double {
        guard totalSeconds > 0 else {return 0}
        return Double(secondsElapsed) / Double(totalSeconds)
    }
    
    private var minutesRemaining: Int {
        secondsRemaining / 60
    }
    
    var body: some View {
        ProgressView(value: progress)
            .progressViewStyle(ScrumProgressViewStyle(theme: theme))
        HStack(){
            VStack(alignment: .leading) {
                Text("seconds elapsed")
                    .font(.caption)
                Label("\(secondsElapsed)", systemImage: "hourglass.bottomhalf.fill")
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("seconds remaining")
                    .font(.caption)
                Label("\(secondsRemaining)", systemImage: "hourglass.tophalf.fill")
                    .labelStyle(.trailingIcon)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Time remaining")
        .accessibilityValue("\(minutesRemaining) mins")
        .padding([.top, .horizontal])
        
    }
}

struct MeetingHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingHeaderView(
            secondsElapsed: 60, secondsRemaining: 180, theme: DailyScrum.sampleData[0].theme
        ).previewLayout(.sizeThatFits)
    }
}
