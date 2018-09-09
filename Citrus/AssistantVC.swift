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

class AssistantVC: JSQMessagesViewController {
    
    var messages = [JSQMessage]()
    var incomingBubble: JSQMessagesBubbleImage!
    var outgoingBubble: JSQMessagesBubbleImage!
    
    var assistant: Assistant!
    var speechToText: SpeechToText!
    var textToSpeech: TextToSpeech!
   
    var audioPlayer: AVAudioPlayer?
    var workspace = Credentials.AssistantWorkspace
    var context: Context?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        setupSender()
        setupWatsonServices()
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

