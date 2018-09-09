//
//  PersonalityVC.swift
//  Citrus
//
//  Created by Mauricio on 9/6/18.
//  Copyright © 2018 Noe Osorio. All rights reserved.
//

import UIKit
import PersonalityInsightsV3
import DiscoveryV1
import Charts
import Foundation

class PersonalityVC: UIViewController {
    
    @IBOutlet weak var bars: BarChartView!
    var personality: PersonalityInsights!
    var discovery: Discovery!
    
    var testText = """
    Thus, we in the free world are moving steadily toward unity and cooperation, in the teeth of that old Bolshevik prophecy, and at the very time when extraordinary rumbles of discord can be heard across the Iron Curtain. It is not free societies which bear within them the seeds of inevitable disunity.
    
        X. OUR BALANCE OF PAYMENTS
    
        On one special problem, of great concern to our friends, and to us, I am proud to give the Congress an encouraging report. Our efforts to safeguard the dollar are progressing. In the 11 months preceding last February 1, we suffered a net loss of nearly $2 billion in gold. In the 11 months that followed, the loss was just over half a billion dollars. And our deficit in our basic transactions with the rest of the world--trade, defense, foreign aid, and capital, excluding volatile short-term flows--has been reduced from $2 billion for 1960 to about one-third that amount for 1961. Speculative fever against the dollar is ending--and confidence in the dollar has been restored.
    
    We did not--and could not--achieve these gains through import restrictions, troop withdrawals, exchange controls, dollar devaluation or
    """

    override func viewDidLoad() {
        super.viewDidLoad()
        setupWatsonServices()
        //analyzePersonality()
        getRecommendations()
    }

    func setupWatsonServices() {
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
    
    
   func analyzePersonality() {
    
        let failure = { (error: Error) in print (error) }
        personality.profile(text: testText, contentLanguage: "en", acceptLanguage: "es", consumptionPreferences: true, failure: failure) { profile in
            self.renderCharts(personalityProfile: profile)
        }
    }
    
    func getRecommendations() {
        //let failure = { (error: Error) in print (failure) }
        //"111d9266-b5a7-487a-9fca-8293b10243e7", collectionID: "51e662ec-9ae3-41f1-ad37-fce07fb0df10"
        discovery.query(
            environmentID: "111d9266-b5a7-487a-9fca-8293b10243e7",
            collectionID: "51e662ec-9ae3-41f1-ad37-fce07fb0df10",
            naturalLanguageQuery: "Español",
            passages: true,
            failure: { (error) in
                print(error)
        }) { (queryResponse) in
            print("\nResults:\n")
            print(queryResponse.results)
            print("\nPassages:\n")
            print(queryResponse.passages)
        }
    }
    
    func renderCharts(personalityProfile: Profile!) {
        
    }
}
