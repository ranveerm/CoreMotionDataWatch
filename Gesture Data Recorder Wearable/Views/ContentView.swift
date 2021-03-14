//
//  ContentView.swift
//  Gesture Data Recorder Wearable
//
//  Created by Ranveer M on 4/3/21.
//

import SwiftUI
import AVKit

struct ContentView: View {
    @EnvironmentObject var viewModel: ContentViewModel
    @EnvironmentObject var appWideInformation: AppWideInformation
    
    @State private var userID = ""
    
    @State private var activityType: ActivityType = .driveIt
    @State private var showInstructions = false
    
    @State private var numberOfActivitySessionsToRecord = 1
    
    var disableRecordingDevicePicker: Bool {
        !(appWideInformation.isWatchAvailable && appWideInformation.dataRecorder.isMotionProviderAvailable)
    }
    
    var body: some View {
        VStack {
            Text("Recorder Motion Data")
                .font(.title)
                .fontWeight(.bold)
                .padding()
                .padding(.top, 20)
            TextField("Enter UserID", text: $userID)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 200)
            
            Picker("", selection: $activityType) {
                ForEach(ActivityType.returnActivityToDisplay(), id: \.self) {
                    $0.returnActivityToDisplayView()
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.top).padding(.leading).padding(.trailing)
            
            Button("Instructions") {
                showInstructions = true
            }.padding(.bottom)
            
            HStack {
                Text("Sessions: ")
                Picker("", selection: $numberOfActivitySessionsToRecord) {
                    ForEach([1, 2, 3], id: \.self) {
                        Text(String($0))
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }.padding()
            
            HStack {
                Text("Recording device: ")
                Picker("", selection: Binding<MotionProviderType>(
                    get: { appWideInformation.dataRecorder.deviceMotionProvider?.motionProviderType ?? .phone
                    },
                    set: {
                        if $0 == .watch && !appWideInformation.isWatchAppRunningAndInTheForeground {
                            self.viewModel.showRequestToLaunchWatchApp()
                            return
                        }
                        appWideInformation.dataRecorder.setMotionProviderType($0)
                    }
                )) {
                    ForEach(MotionProviderType.allCases, id: \.self) {
                        Text($0.glyph)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .foregroundColor(disableRecordingDevicePicker ? .gray : .none)
            .disabled(disableRecordingDevicePicker)
            .padding()
            
            Button(action: {
                // TODO: consolidate below check with similar check during pre-recording check
                guard let motionProvider = viewModel.dataRecorder.deviceMotionProvider else {
                    viewModel.trigger(.unableToRecord(message: "Device motion data is unavailable"))
                    return
                }
                let recordingMetadata = RecordingMetadata(userID: userID, sessionID: Date.returnSessionID(), motionProviderType: motionProvider.motionProviderType, activityType: activityType, numberOfActivitySessionsToRecord: numberOfActivitySessionsToRecord)
                viewModel.trigger(.prepareToRecord(recordingMetadata: recordingMetadata))
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }) {
                Text("Start Recording")
                    .foregroundColor(.white)
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                    )
            }.disabled(userID.isEmpty && appWideInformation.dataRecorder.isMotionProviderAvailable)
            Spacer()
        }
        .disabled(viewModel.state.shouldPhoneUIBeDisabled())
        .alert(isPresented: $viewModel.showAlert) { viewModel.alert }
        .sheet(isPresented: $showInstructions) {
            VideoPlayer(player: AVPlayer(url:  Bundle.main.url(forResource: activityType.reutrnVideoFileName(), withExtension: "mov")!)) {
                VStack {
                    Spacer()
                    Text(activityType.description)
                        .font(.caption)
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.7))
                        .clipShape(Capsule())
                        .padding(50)
                }.padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ContentViewModel(dataRecorder: DataRecorder()))
    }
}
