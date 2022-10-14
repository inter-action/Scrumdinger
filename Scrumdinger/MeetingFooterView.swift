//

import SwiftUI

struct MeetingFooterView: View {
    let speakers: [ScrumTimer.Speaker]
    var skipAction: ()->Void
    private var speakerNumber: Int? {
        guard let firstIndex = speakers.firstIndex(where: {!$0.isCompleted}) else {return nil}
        return firstIndex + 1
    }
    private var isLastSpeaker: Bool {
        return self.speakers.dropLast().allSatisfy {$0.isCompleted}
    }
    private var speakerText: String {
        guard let speakerNumber = speakerNumber else { return "No more speakers" }
        return "Speaker \(speakerNumber) of \(speakers.count)"
    }
    
    var body: some View {
        VStack {
            HStack {
                if isLastSpeaker {
                    Text("Last Speaker")
                } else {
                    Text(speakerText)
                    Spacer()
                    Button(action: skipAction){
                        Image(systemName: "forward.fill")
                    }
                    .accessibilityLabel("next speaker")
                }
            }
        }
        .padding([.horizontal, .bottom])
    }
}

struct MeetingFooterView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingFooterView(
            speakers: DailyScrum.sampleData[0].attendees.speakers,
            skipAction: {}
        ).previewLayout(.sizeThatFits)
    }
}
