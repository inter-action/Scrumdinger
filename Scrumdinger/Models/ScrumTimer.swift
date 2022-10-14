//
import Foundation


//extension DailyScrum {
//    /// A new `ScrumTimer` using the meeting length and attendees in the `DailyScrum`.
//    var timer: ScrumTimer {
//        ScrumTimer(lengthInMinutes: lengthInMinutes, attendees: attendees)
//    }
//}

extension Array where Element == Attendee {
    var speakers: [ScrumTimer.Speaker] {
        if isEmpty {
            return [ScrumTimer.Speaker(name: "Speaker 1", isCompleted: false)]
        } else {
            return map { ScrumTimer.Speaker(name: $0.name, isCompleted: false) }
        }
    }
}


/// Keeps time for a daily scrum meeting. Keep track of the total meeting time, the time for each speaker, and the name of the current speaker.
class ScrumTimer: ObservableObject {
    /// A struct to keep track of meeting attendees during a meeting.
    struct Speaker: Identifiable {
        /// The attendee name.
        let name: String
        /// True if the attendee has completed their turn to speak.
        var isCompleted: Bool
        /// Id for Identifiable conformance.
        let id = UUID()
    }
    // m: create variable just to update is just not that good.
    // even I got that it's due to performance concern
    /// The name of the meeting attendee who is speaking.
    @Published var activeSpeaker = ""
    /// The number of seconds since the beginning of the meeting.
    @Published var secondsElapsed = 0
    /// The number of seconds until all attendees have had a turn to speak.
    @Published var secondsRemaining = 0
    
    /// All meeting attendees, listed in the order they will speak.
    private(set) var speakers: [Speaker] = []
    /// The scrum meeting length.
    private(set) var lengthInMinutes: Int = 0
    
    var speakerChangedAction: (()-> Void)?
    
    private var timer: Timer?
    private var timerStopped = false
    private var frequency: TimeInterval {
        1.0 / 60
    }
    private var lengthInSeconds: Int {
        lengthInMinutes * 60
    }
    private var secondsPerSpeaker: Int {
        lengthInSeconds / speakers.count
    }
    
    private var secondsElapsedForSpeaker = 0
    private var speakerIndex = 0
    private var speakerText: String {
        "Speaker \(speakerIndex + 1)" + speakers[speakerIndex].name
    }
    
    private var startDate: Date?
    
    /**
     Initialize a new timer. Initializing a time with no arguments creates a ScrumTimer with no attendees and zero length.
     Use `startScrum()` to start the timer.
     
     - Parameters:
     - lengthInMinutes: The meeting length.
     -  attendees: A list of attendees for the meeting.
     */
    init(lengthInMinutes: Int = 0, attendees: [Attendee] = []) {
        self.lengthInMinutes = lengthInMinutes
        self.speakers = attendees.speakers
        secondsRemaining = lengthInSeconds
        activeSpeaker = speakerText
    }
    
    private func changeToSpeaker(at: Int) {
        timer?.invalidate()
        
        if at > 0 {
            let preIndex = at - 1
            speakers[preIndex].isCompleted = true
        }
        secondsElapsedForSpeaker = 0
        guard at < speakers.count else {return}
        speakerIndex = at
        // publish ui changes
        activeSpeaker = speakerText
        secondsElapsed = at * secondsPerSpeaker
        secondsRemaining = lengthInSeconds - secondsElapsed
        
        startDate = Date()
        timer = Timer.scheduledTimer(withTimeInterval: self.frequency, repeats: true) { [weak self] timer in
            if let self = self, let startDate = self.startDate {
                let secondesElapsed = Date().timeIntervalSince1970 - startDate.timeIntervalSince1970
                self.update(elapsed: Int(secondesElapsed))
            }
        }
    }
    
    private func update(elapsed: Int) {
        secondsElapsedForSpeaker = elapsed
        self.secondsElapsed = speakerIndex * secondsPerSpeaker + elapsed
//        guard elapsed < secondsPerSpeaker else {
//            return
//        }
        self.secondsRemaining = max(lengthInSeconds - self.secondsElapsed, 0)
        print("remaining: \(self.secondsRemaining)")
        
        if self.secondsRemaining <= 0 {
            return self.stopScrum()
        }
        
        if timerStopped {return}
        
        if elapsed >= secondsPerSpeaker {
            self.changeToSpeaker(at: self.speakerIndex + 1)
            // option chain call
            self.speakerChangedAction?()
        }
    }
    
    /**
     Reset the timer with a new meeting length and new attendees.
     
     - Parameters:
         - lengthInMinutes: The meeting length.
         - attendees: The name of each attendee.
     */
    func reset(lengthInMinutes: Int, attendees: [Attendee]) {
        self.lengthInMinutes = lengthInMinutes
        self.speakers = attendees.speakers
//        self.timerStopped = false
        secondsRemaining = lengthInSeconds
        activeSpeaker = speakerText
    }
    
    /// Start the timer.
    func startScrum() {
        changeToSpeaker(at: 0)
    }
    
    /// Stop the timer.
    func stopScrum() {
        timer?.invalidate()
        timer = nil
        timerStopped = true
    }
    
    /// Advance the timer to the next speaker.
    func skipSpeaker() {
        changeToSpeaker(at: speakerIndex + 1)
    }
}

extension DailyScrum {
    /// A new `ScrumTimer` using the meeting length and attendees in the `DailyScrum`.
    var timer: ScrumTimer {
        ScrumTimer(lengthInMinutes: lengthInMinutes, attendees: attendees)
    }
}
