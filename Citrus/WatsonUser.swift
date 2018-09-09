//
//  User.swift
//  Citrus
//
//  Created by Mauricio on 9/5/18.
//  Copyright © 2018 Noe Osorio. All rights reserved.
//

import Foundation
import JSQMessagesViewController

enum WatsonUser: String {
    case me = "053496-4509-288"
    case watson = "053496-4509-289"
    
    static func getName(_ user: WatsonUser) -> String {
        switch user {
        case .me: return "Me"
        case .watson: return "Watson"
        }
    }
    
    static func getAvatar(_ id: String) -> JSQMessagesAvatarImage? {
        let user = WatsonUser(rawValue: id)!
        switch user {
        case .me: return nil
        case .watson: return avatarWatson
        }
    }
}

private let avatarWatson = JSQMessagesAvatarImageFactory.avatarImage(
    with: #imageLiteral(resourceName: "orange"),
    diameter: 24
)
