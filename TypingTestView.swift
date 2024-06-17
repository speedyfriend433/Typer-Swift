import SwiftUI

struct TypingTestView: View {
    @State private var sentences = [
        "The quick brown fox jumps over the lazy dog.",
        "A journey of a thousand miles begins with a single step.",
        "To be or not to be, that is the question.",
        "All that glitters is not gold.",
        "A picture is worth a thousand words."
    ]
    @State private var sampleText = "The quick brown fox jumps over the lazy dog."
    @State private var userInput = ""
    @State private var startTime: Date?
    @State private var timeElapsed: Double = 0.0
    @State private var wordsPerMinute: Double = 0.0
    @State private var accuracy: Double = 100.0
    @State private var isTestActive = false
    @State private var isEditable = true
    @State private var timer: Timer?
    @State private var speedData: [CGPoint] = []
    @State private var accuracyData: [CGPoint] = []
    @State private var showResults = false
    
    var body: some View {
        VStack {
            Text("Typing Test")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 20)
            
            ScrollView {
                Text(sampleText)
                    .padding()
                    .font(.title2)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.bottom, 20)
            }
            
            TextField("Start typing here...", text: $userInput, onEditingChanged: { editing in
                if editing && self.userInput.isEmpty {
                    self.startTest()
                }
            }, onCommit: {
                self.endTest()
            })
                .disabled(!isEditable)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding(.bottom, 20)
            
            if isTestActive || !isEditable {
                Text("Time elapsed: \(timeElapsed, specifier: "%.2f") seconds")
                    .font(.headline)
                    .padding(.bottom, 10)
                Text("Words per minute: \(wordsPerMinute, specifier: "%.2f")")
                    .font(.headline)
                Text("Accuracy: \(accuracy, specifier: "%.2f")%")
                    .font(.headline)
                    .padding(.bottom, 20)
            }
            
            HStack {
                Button(action: resetTest) {
                    Text("Reset")
                        .font(.headline)
                        .padding()
                        .background(Color.red.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: loadRandomSentence) {
                    Text("Random")
                        .font(.headline)
                        .padding()
                        .background(Color.blue.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
        .background(Color(UIColor.systemTeal).opacity(0.1))
        .cornerRadius(10)
        .shadow(radius: 10)
        .onChange(of: userInput, perform: { _ in
            if isTestActive {
                updateStats()
            } else if !userInput.isEmpty && startTime == nil {
                startTest()
            }
        })
        .sheet(isPresented: $showResults) {
            ResultView(speedData: speedData, accuracyData: accuracyData, timeElapsed: timeElapsed, wordsPerMinute: wordsPerMinute, accuracy: accuracy)
        }
        .colorScheme(.light) // Force light mode to keep colors consistent
    }
    
    private func startTest() {
        userInput = ""
        startTime = Date()
        isTestActive = true
        isEditable = true
        speedData = []
        accuracyData = []
        startTimer()
    }
    
    private func endTest() {
        timer?.invalidate()
        isTestActive = false
        isEditable = false
        updateAccuracy()
        showResults = true
    }
    
    private func resetTest() {
        userInput = ""
        timeElapsed = 0.0
        wordsPerMinute = 0.0
        accuracy = 100.0
        isEditable = true
        isTestActive = false
        startTime = nil
        speedData = []
        accuracyData = []
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.updateStats()
        }
    }
    
    private func updateStats() {
        guard let start = startTime else { return }
        timeElapsed = Date().timeIntervalSince(start)
        let wordCount = userInput.split(separator: " ").count
        wordsPerMinute = Double(wordCount) / (timeElapsed / 60)
        speedData.append(CGPoint(x: timeElapsed, y: wordsPerMinute))
        updateAccuracy()
        accuracyData.append(CGPoint(x: timeElapsed, y: accuracy))
    }
    
    private func updateAccuracy() {
        let sampleWords = sampleText.split(separator: " ")
        let inputWords = userInput.split(separator: " ")
        let correctWords = zip(sampleWords, inputWords).filter { $0 == $1 }.count
        accuracy = (Double(correctWords) / Double(sampleWords.count)) * 100
    }
    
    private func loadRandomSentence() {
        sampleText = sentences.randomElement() ?? sampleText
        resetTest()
    }
}

struct ContentView: View {
    var body: some View {
        TypingTestView()
    }
}

