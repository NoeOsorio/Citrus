//
//  AssistantVC.swift
//  Citrus
//
//  Created by Mauricio on 9/1/18.
//  Copyright © 2018 Noe Osorio. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import AVFoundation
import AssistantV1
import SpeechToTextV1
import TextToSpeechV1
import PersonalityInsightsV3

class AssistantVC: JSQMessagesViewController {
    
    var messages = [JSQMessage]()
    var incomingBubble: JSQMessagesBubbleImage!
    var outgoingBubble: JSQMessagesBubbleImage!
    
    var assistant: Assistant!
    var speechToText: SpeechToText!
    var textToSpeech: TextToSpeech!
    var personality: PersonalityInsights!
    
    var testText = """
    Thus, we in the free world are moving steadily toward unity and cooperation, in the teeth of that old Bolshevik prophecy, and at the very time when extraordinary rumbles of discord can be heard across the Iron Curtain. It is not free societies which bear within them the seeds of inevitable disunity.
    
        X. OUR BALANCE OF PAYMENTS
    
        On one special problem, of great concern to our friends, and to us, I am proud to give the Congress an encouraging report. Our efforts to safeguard the dollar are progressing. In the 11 months preceding last February 1, we suffered a net loss of nearly $2 billion in gold. In the 11 months that followed, the loss was just over half a billion dollars. And our deficit in our basic transactions with the rest of the world--trade, defense, foreign aid, and capital, excluding volatile short-term flows--has been reduced from $2 billion for 1960 to about one-third that amount for 1961. Speculative fever against the dollar is ending--and confidence in the dollar has been restored.
    
    We did not--and could not--achieve these gains through import restrictions, troop withdrawals, exchange controls, dollar devaluation or
    """
    var audioPlayer: AVAudioPlayer?
    var workspace = Credentials.AssistantWorkspace
    var context: Context?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        setupSender()
        setupWatsonServices()
        analyzePersonality()
        startAssistant()
    }
}

// MARK: Watson Services
extension AssistantVC {
    
    /// Instantiate the Watson services
    func setupWatsonServices() {
        assistant = Assistant(
            username: Credentials.AssistantUsername,
            password: Credentials.AssistantPassword,
            version: "2018-09-06"
            //"2017-05-26"
        )
        speechToText = SpeechToText(
            username: Credentials.SpeechToTextUsername,
            password: Credentials.SpeechToTextPassword
        )
        textToSpeech = TextToSpeech(
            username: Credentials.TextToSpeechUsername,
            password: Credentials.TextToSpeechPassword
        )
        personality = PersonalityInsights(
            username: Credentials.PersonalityUsername,
            password: Credentials.PersonalityPassword,
            version: "2018-09-06"
        )
        
        personality.serviceURL = "https://gateway.watsonplatform.net/personality-insights/api"
    }
    
    /// Present an error message
    func failure(error: Error) {
        let alert = UIAlertController(
            title: "Watson Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    /// Start a new conversation
    func startAssistant() {
        assistant.message(
            workspaceID: workspace,
            failure: failure,
            success: presentResponse
        )
    }
    
    /// Present a conversation reply and speak it to the user
    func presentResponse(_ response: MessageResponse) {
        let text = response.output.text.joined()
        context = response.context // save context to continue conversation
        
        // synthesize and speak the response
        textToSpeech.synthesize(text: text,
                                accept: "audio/wav",
                                voice: "es-LA_SofiaVoice",
                                failure: failure) { audio in
            self.audioPlayer = try? AVAudioPlayer(data: audio)
            self.audioPlayer?.prepareToPlay()
            self.audioPlayer?.play()
        }
        
        // create message
        let message = JSQMessage(
            senderId: WatsonUser.watson.rawValue,
            displayName: WatsonUser.getName(WatsonUser.watson),
            text: text
        )
        
        // add message to chat window
        if let message = message {
            self.messages.append(message)
            DispatchQueue.main.async { self.finishSendingMessage() }
        }
    }
    
    func analyzePersonality() {
        let failure = { (error: Error) in print (error) }
        personality.profile(text: testText, failure: failure) { profile in
                print(profile)
            }
    }
    
    /// Start transcribing microphone audio
    @objc func startTranscribing() {
        audioPlayer?.stop()
        var settings = RecognitionSettings(contentType: "audio/ogg;codecs=opus")
        var accumulator = SpeechRecognitionResultsAccumulator()
        settings.interimResults = true
        speechToText.recognizeMicrophone(settings: settings,
                                         model: "es-ES_BroadbandModel",
                                         failure: failure) { results in
            accumulator.add(results: results)
            self.inputToolbar.contentView.textView.text = accumulator.bestTranscript
            self.inputToolbar.toggleSendButtonEnabled()
        }
    }
    
    /// Stop transcribing microphone audio
    @objc func stopTranscribing() {
        speechToText.stopRecognizeMicrophone()
    }
}

// MARK: Configuration
extension AssistantVC {
    
    func setupInterface() {
        // bubbles
        let factory = JSQMessagesBubbleImageFactory()
        let incomingColor = UIColor(red:0.95, green:0.61, blue:0.16, alpha:1.0)
        let outgoingColor = UIColor(red:0.14, green:0.40, blue:0.61, alpha:1.0)
        incomingBubble = factory!.incomingMessagesBubbleImage(with: incomingColor)
        outgoingBubble = factory!.outgoingMessagesBubbleImage(with: outgoingColor)
        
        // avatars
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        // microphone button
        let microphoneButton = UIButton(type: .custom)
        microphoneButton.setImage(#imageLiteral(resourceName: "microphone-hollow"), for: .normal)
        microphoneButton.setImage(#imageLiteral(resourceName: "microphone"), for: .highlighted)
        microphoneButton.addTarget(self, action: #selector(startTranscribing), for: .touchDown)
        microphoneButton.addTarget(self, action: #selector(stopTranscribing), for: .touchUpInside)
        microphoneButton.addTarget(self, action: #selector(stopTranscribing), for: .touchUpOutside)
        inputToolbar.contentView.leftBarButtonItem = microphoneButton
    }
    
    func setupSender() {
        senderId = WatsonUser.me.rawValue
        senderDisplayName = WatsonUser.getName(WatsonUser.me)
    }
    
    override func didPressSend(
        _ button: UIButton!,
        withMessageText text: String!,
        senderId: String!,
        senderDisplayName: String!,
        date: Date!)
    {
        let message = JSQMessage(
            senderId: WatsonUser.me.rawValue,
            senderDisplayName: WatsonUser.getName(WatsonUser.me),
            date: date,
            text: text
        )
        
        if let message = message {
            self.messages.append(message)
            self.finishSendingMessage(animated: true)
        }
        
        // send text to conversation service
        let input = InputData(text: text)
        let request = MessageRequest(input: input, context: context)
        assistant.message(
            workspaceID: workspace,
            request: request,
            failure: failure,
            success: presentResponse
        )
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        // required by super class
    }
}

// MARK: Collection View Data Source
extension AssistantVC {
    
    override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int)
        -> Int
    {
        return messages.count
    }
    
    override func collectionView(
        _ collectionView: JSQMessagesCollectionView!,
        messageDataForItemAt indexPath: IndexPath!)
        -> JSQMessageData!
    {
        return messages[indexPath.item]
    }
    
    override func collectionView(
        _ collectionView: JSQMessagesCollectionView!,
        messageBubbleImageDataForItemAt indexPath: IndexPath!)
        -> JSQMessageBubbleImageDataSource!
    {
        let message = messages[indexPath.item]
        let isOutgoing = (message.senderId == senderId)
        let bubble = (isOutgoing) ? outgoingBubble : incomingBubble
        return bubble
    }
    
    override func collectionView(
        _ collectionView: JSQMessagesCollectionView!,
        avatarImageDataForItemAt indexPath: IndexPath!)
        -> JSQMessageAvatarImageDataSource!
    {
        let message = messages[indexPath.item]
        return WatsonUser.getAvatar(message.senderId)
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell
    {
        let cell = super.collectionView(
            collectionView,
            cellForItemAt: indexPath
        )
        let jsqCell = cell as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        let isOutgoing = (message.senderId == senderId)
        jsqCell.textView.textColor = (isOutgoing) ? .white : .black
        return jsqCell
    }
}

