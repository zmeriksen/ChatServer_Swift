//
//  UserAPI.swift
//  TechExPackageDescription
//
//  Created by Zach Eriksen on 9/13/17.
//

import Foundation

class UserAPI {
    
    static func toDictionary(users: [User]) -> [[String: Any]] {
        return users.map{ $0.asDictionary() }
    }
    
    static func allAsDictionary() throws -> [[String: Any]] {
        let all = try User.all()
        return toDictionary(users: all)
    }
    
    static func all() throws -> String {
        return try allAsDictionary().jsonEncodedString()
    }
    
    static func first() throws -> String {
        if let first = try User.first() {
            return try first.asDictionary().jsonEncodedString()
        } else {
            return try [].jsonEncodedString()
        }
    }
    
    static func matchingShort(_ matchingShort: String) throws -> User? {
        return try User.user(withHandle: matchingShort)
    }
    
    static func delete(handle: String) throws {
        let user = try User.user(withHandle: handle)
        try user.delete()
    }
    
    static func deleteFirst() throws -> String {
        guard let user = try User.first() else {
            return "No item to update"
        }
        try user.delete()
        return try all()
    }
    
    static func newUser(withHandle handle: String, room: String = "lobby", friends: [String] = []) throws -> [String: Any] {
        let user = User()
        user.handle = handle
        user.room = room
        user.friends = friends
		try user.create()
        return user.asDictionary()
    }
    
    static func newUser(withJSONRequest json: String?) throws -> String {
        guard let json = json,
            let dict = try json.jsonDecode() as? [String: Any],
            let handle = dict["handle"] as? String else {
                return "Invalid Params"
        }
        
        return try newUser(withHandle: handle).jsonEncodedString()
    }
    
    static func updateUser(withJSONRequest json: String?) throws -> String {
        guard let json = json,
            let dict = try json.jsonDecode() as? [String: Any],
            let handle = dict["handle"] as? String,
            let room = dict["room"] as? String,
            let friends = dict["friends"] as? [String] else {
                return "Invalid parameters"
        }
        let user = try User.user(withHandle: handle)
        user.room = room
        user.friends = friends
        try user.save()
        return try user.asDictionary().jsonEncodedString()
    }
    
//    static func currentRoom(withName name: String, forUserWithHandle handle: String) throws -> String{
//        let user = try User.user(withHandle: handle)
//        user.currentRoom = nam
//        return try user.asDictionary().jsonEncodedString()
//    }
}

