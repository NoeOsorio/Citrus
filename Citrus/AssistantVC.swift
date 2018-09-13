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
import DiscoveryV1

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
    var intents: [RuntimeIntent] = []
    var entities: [RuntimeEntity] = []
    
    var passages: [QueryPassages] = []
    var personality: PersonalityInsights!
    var personalityProfile: Profile!
    var discovery: Discovery!
    var band: Int = 0
    var testText = """
    Thus, we in the free world are moving steadily toward unity and cooperation, in the teeth of that old Bolshevik prophecy, and at the very time when extraordinary rumbles of discord can be heard across the Iron Curtain. It is not free societies which bear within them the seeds of inevitable disunity.
    
        X. OUR BALANCE OF PAYMENTS
    
        On one special problem, of great concern to our friends, and to us, I am proud to give the Congress an encouraging report. Our efforts to safeguard the dollar are progressing. In the 11 months preceding last February 1, we suffered a net loss of nearly $2 billion in gold. In the 11 months that followed, the loss was just over half a billion dollars. And our deficit in our basic transactions with the rest of the world--trade, defense, foreign aid, and capital, excluding volatile short-term flows--has been reduced from $2 billion for 1960 to about one-third that amount for 1961. Speculative fever against the dollar is ending--and confidence in the dollar has been restored.
    
    We did not--and could not--achieve these gains through import restrictions, troop withdrawals, exchange controls, dollar devaluation or
    """
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        setupSender()
        setupWatsonServices()
        startAssistant()
        //info.getDefault()
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
        discovery = Discovery(
            username: Credentials.DiscoveryUsername,
            password: Credentials.DiscoveryPassword,
            version: "2018-09-06"
        )
        personality.serviceURL = "https://gateway.watsonplatform.net/personality-insights/api"
        discovery.serviceURL = "https://gateway.watsonplatform.net/discovery/api"
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
    
    func analyzePersonality() {
        
        let failure = { (error: Error) in print (error) }
        personality.profile(text: testText, contentLanguage: "en", acceptLanguage: "es", consumptionPreferences: true, failure: failure) { profile in
            self.personalityProfile = profile
        }
    }
    
    func showResults(results: [QueryPassages]) {
        self.passages.removeAll()
        print("This is the showResults function with \(passages)")
        self.passages = results
        band = 1
    }
    
    func getRecommendations(materia: String) {
        var queryList: [String] = ["text:\"\(materia)\""]
        self.passages.removeAll()
        for category in personalityProfile.consumptionPreferences! {
            for preference in category.consumptionPreferences {
                print("\(preference.consumptionPreferenceID):\(preference.score)")
                
                if(preference.consumptionPreferenceID == "consumption_preferences_movie_historical" && preference.score == 1.0 && materia == "Historia") {
                    queryList.append("(text:\"\(materia)\",text:\"video\",text:\"historia\"")
                }
                
                if(preference.consumptionPreferenceID == "consumption_preferences_movie_documentary" && preference.score == 1.0) {
                    queryList.append("(text:\"\(materia)\"|(text:\"documental\"|text:\"video\"))")
                }
                
                if(preference.consumptionPreferenceID == "consumption_preferences_read_frequency" && preference.score == 1.0) {
                    queryList.append("(text:\"\(materia)\"|(text:\"no ficcion\"|text:\"articulo\"))")
                }
                
                if(preference.consumptionPreferenceID == "consumption_preferences_non_fiction" && preference.score == 1.0) {
                    queryList.append("(text:\"\(materia)\"|(text:\"no ficcion\"|text:\"articulo\"))")
                }
                
                if(preference.consumptionPreferenceID == "consumption_preferences_financial_investing" && preference.score == 1.0) {
                    queryList.append("(text:\"\(materia)\"|(text:\"finanzas\"|text:\"curso\"))")
                }
                
                if(preference.consumptionPreferenceID == "consumption_preferences_books_autobiographies" && preference.score == 1.0) {
                    queryList.append("(text:\"\(materia)\"|(text:\"autobiografia\"|text:\"articulo\"))")
                }
                
                if(preference.consumptionPreferenceID == "consumption_preferences_start_business" && preference.score == 1.0) {
                    queryList.append("(text:\"\(materia)\"|(text:\"negocios\"))")
                }
            }
        }
        let Preferencequery = queryList[Int(arc4random_uniform(UInt32(queryList.count)))]
        print("\nObteniendo recomendaciones con query: \(Preferencequery)\n")
        discovery.query(
            environmentID: "111d9266-b5a7-487a-9fca-8293b10243e7",
            collectionID: "5221bd92-9179-45c9-9b64-25c30f5e7277",
            query: Preferencequery,
            passages: true,
            failure: { (error) in
                print(error)
        }) { (queryResponse) in
            self.showResults(results: queryResponse.passages!)
        }
    }
    /// Present a conversation reply and speak it to the user
    func presentResponse(_ response: MessageResponse) {
        
        let text = response.output.text.joined()
        context = response.context // save context to continue conversation
        intents = response.intents
        entities = response.entities
        
        print("\n\nIn response with intents: \(response.intents)\n")
        print("In response with entities: \(response.entities)\n\n")
        analyzePersonality()
        
        if(response.intents != nil || response.entities != nil) {
            for intent in response.intents {
                if(intent.intent == "examen" || intent.intent == "Aprender") {
                    print("\nEl usuario tiene intención de aprender\n")
                    //print("\nPersonalidad: \(info.getPersonality())")

                    for entity in response.entities {
                        if(entity.entity == "materia") {
                            getRecommendations(materia: entity.value)
                        }
                        
                    }
                }
                else if(intent.intent == "aprender" || intent.intent == "Recomendacion") {
                    print("\nEl usuario quiere una recomendación\n")
                    //print("\nPersonalidad: \(info.getPersonality())")
                    
                    for entity in response.entities {
                        if(entity.entity == "materia") {
                            getRecommendations(materia: entity.value)
                        }
                    }
                }
            }
        }
        
        if !((UserDefaults.standard.value(forKey: "mute") as? Bool)!){
            // synthesize and speak the response
            textToSpeech.synthesize(text: text,
                                    accept: "audio/wav",
                                    voice: "es-LA_SofiaVoice",
                                    failure: failure) { audio in
                                        self.audioPlayer = try? AVAudioPlayer(data: audio)
                                        self.audioPlayer?.prepareToPlay()
                                        self.audioPlayer?.play()
            }
        }
        
        // create message
        if(self.passages != nil && band == 1) {
            print("\n In message with \(self.passages)\n")
            let Qresult = passages[Int(arc4random_uniform(UInt32(passages.count)))]
            print("\n\n Array of responses \(response.output.text)\n\n")
            let message = JSQMessage(
                senderId: WatsonUser.watson.rawValue,
                displayName: WatsonUser.getName(WatsonUser.watson),
                text: Qresult.passageText
            )
            
            // add message to chat window
            if let message = message {
                self.messages.append(message)
                DispatchQueue.main.async { self.finishSendingMessage() }
            }
            band = 0
        }
        
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

