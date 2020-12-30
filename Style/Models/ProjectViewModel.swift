//
//  ProjectViewModel.swift
//  Style
//
//  Created by Vince Davis on 12/14/20.
//

import Foundation
import SwiftUI
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

class ProjectViewModel: ObservableObject {
    
    @Published var projects: [Project] = []
    @Published var currentProject: Project?
    
    @Published var users: [ProjectUser] = []
    @Published var currentUser: ProjectUser?
    
    @Published var actors: [Actor] = []
    @Published var currentActor: Actor?
    @Published var currentActorImages: [String] = []
    
    @Published var scenes: [MovieScene] = []
    @Published var currentScene: MovieScene?
    
    @Published var sceneActors: [SceneActor] = []
    @Published var currentSceneActor: SceneActor?
    
    var didChange = PassthroughSubject<Void, Never>()
    
    private var database = Firestore.firestore()
    private var storage = Storage.storage().reference()

    func fetchProjects() {
        database.collection("projects").addSnapshotListener { (querySnapshot, error) in
          guard let documents = querySnapshot?.documents else {
            print("No documents")
            return
          }
            
            self.projects = documents.compactMap { queryDocumentSnapshot -> Project? in
              return try? queryDocumentSnapshot.data(as: Project.self)
            }
        }
    }
    
    func fetchUser(for uid: String) {
        database.collection("users").whereField("uid", isEqualTo: uid)
            .getDocuments() { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
              print("No users")
              return
            }
      
                let fbUsers: [ProjectUser] = documents.compactMap { queryDocumentSnapshot -> ProjectUser? in
                return try? queryDocumentSnapshot.data(as: ProjectUser.self)
            }
                self.currentUser = fbUsers.first
                self.didChange.send()
                print("found user \(self.currentUser?.image)")
        }
    }
    
    func fetchActors(for projectId: String) {
        database.collection("actors").whereField("projectId", isEqualTo: projectId)
            .getDocuments() { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
              print("No documents")
              return
            }
      
            self.actors = documents.compactMap { queryDocumentSnapshot -> Actor? in
                return try? queryDocumentSnapshot.data(as: Actor.self)
            }
        }
    }
    
    func fetchScenes(for projectId: String) {
        database.collection("scenes").whereField("projectId", isEqualTo: projectId)
            .getDocuments() { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
              print("No documents")
              return
            }
      
            self.scenes = documents.compactMap { queryDocumentSnapshot -> MovieScene? in
                return try? queryDocumentSnapshot.data(as: MovieScene.self)
            }
        }
    }
    
    func filterScene(for actorId: String) -> [MovieScene] {
        var scenesForActor: [MovieScene] = []
        
        for scene in scenes where scene.actors.contains(actorId) {
            scenesForActor.append(scene)
        }
        
        return scenesForActor
    }
    
    func fetchSceneActors(for sceneActorId: String) {
        database.collection("sceneActors").whereField("sceneActorId", isEqualTo: sceneActorId)
            .getDocuments() { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
              print("No documents")
              return
            }
      
            self.sceneActors = documents.compactMap { queryDocumentSnapshot -> SceneActor? in
                return try? queryDocumentSnapshot.data(as: SceneActor.self)
            }
        }
    }
    
    func getActors(for scene: MovieScene) -> [Actor] {
        var sceneActors: [Actor] = []
        
        for actor in self.actors where scene.actors.contains(actor.id ?? "") {
            sceneActors.append(actor)
        }
        
        return sceneActors
    }
    
//    func fetch() {
//        database.collection("play").document("rcBFMvHqNC4YXGp2PkvH")
//            .addSnapshotListener { snapshot, error in
//                guard let doc = snapshot else {
//                    print("no play found")
//                    return
//                }
//
//                do {
//                    self.currentPlay = try doc.data(as: Play.self)
//                    print("play \(self.currentPlay?.teama.count)")
//                } catch let err {
//                    print("doc error \(err.localizedDescription)")
//                }
//
//
//        }
//        db.collecti
//    }
    
    func add(object: FirebaseObjectable) {
        var ref: DocumentReference? = nil
        ref = database.collection(object.objectName).addDocument(data: object.dict) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                self.didChange.send()
            }
        }
    }
    
    func update(object: FirebaseObjectable, with dict: [String: Any]) {
        let ref = database.collection(object.objectName).document(object.objectId!)
        
        ref.updateData(dict) { err in
            if let error = err {
                print("error updating time: \(error.localizedDescription)")
            }
        }
    }
    
    func upload(data: Data, to path: String, completion: @escaping (URL?) -> Void) {
        // Data in memory
        //let data = Data()

        // Create a reference to the file you want to upload
        let storageRef = storage.child(path)

        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = storageRef.putData(data, metadata: nil) { (metadata, error) in
          guard let metadata = metadata else {
            print("Error uploading data to path: \(path)")
            completion(nil)
            return
          }
          // Metadata contains file metadata such as size, content-type.
          let size = metadata.size
          // You can also access to download URL after upload.
            storageRef.downloadURL { (url, error) in
            guard let downloadURL = url else {
              completion(nil)
              return
            }
            completion(url)
          }
        }
    }
    
    func getActorImages() {
        self.currentActorImages = []
        let actorImageRef = storage.child("images/actors/\(currentActor?.id ?? "")/gallery")
        actorImageRef.listAll { (result, error) in
            if let err = error {
                print("Image count error \(err.localizedDescription)")
                return
            }
            print("Image count \(result.items.count)")
            for item in result.items {
                item.downloadURL { url, error in
                    if let imageUrl = url {
                        self.currentActorImages.append(imageUrl.absoluteString)
                    }
                }
            }
        }
    }
    
    func upload(urlPath: URL, to path: String, completion: @escaping (URL?) -> Void) {
        // File located on disk
        //let localFile = URL(string: url)!

        // Create a reference to the file you want to upload
        let riversRef = storage.child(path)

        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = riversRef.putFile(from: urlPath, metadata: nil) { metadata, error in
          guard let metadata = metadata else {
            print("Error uploading url \(urlPath.absoluteString) to path: \(path)")
            completion(nil)
            return
          }
          // Metadata contains file metadata such as size, content-type.
          let size = metadata.size
          // You can also access to download URL after upload.
          riversRef.downloadURL { (url, error) in
            guard let downloadURL = url else {
                completion(nil)
              return
            }
            completion(url)
          }
        }
    }
    
}

extension ProjectViewModel {
    
}

protocol FirebaseObjectable {
    //init?(dict:[String:AnyObject])
    var objectName: String {  get }
    var objectId: String? { get }
    var dict: [String: Any] { get }
}

struct Project: Identifiable, Codable, FirebaseObjectable {
    @DocumentID var id: String?
    var name: String
    var image: String
    
    @ServerTimestamp var createdTime: Timestamp?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image
    }
    
    var objectName: String {
        return "projects"
    }
    
    var objectId: String? {
        return id
    }
    
    var dict: [String: Any] {
        return [
                "name": name,
                "image": image
        ]
    }
    
    static func dummy1() -> Project {
        return Project(id: "asdasda", name: "BET Movie", image: "bet")
    }
    
    static func dummy2() -> Project {
        return Project(id: "asdasdawer", name: "UMC TV Show", image: "umc")
    }
}

struct ProjectUser: Identifiable, Codable, FirebaseObjectable {
    @DocumentID var id: String?
    var uid: String
    var firstName: String
    var lastName: String
    var phone: String
    var title: String
    var image: String
    
    @ServerTimestamp var createdTime: Timestamp?
    
    enum CodingKeys: String, CodingKey {
        case id
        case uid
        case firstName
        case lastName
        case phone
        case title
        case image
    }
    
    var objectName: String {
        return "users"
    }
    
    var objectId: String? {
        return id
    }
    
    var dict: [String: Any] {
        return [
            "uid": uid,
            "firstName": firstName,
            "lastName": lastName,
            "phone": phone,
            "title": title,
            "image": image,
        ]
    }
    
//    static func dummy1() -> ProjectUser {
//        return ProjectUser(id: "asdasda", name: "Angelique", title: "Designer")
//    }
//
//    static func dummy2() -> ProjectUser {
//        return ProjectUser(id: "asdasdawqewq", name: "Kwasi", title: "Producer")
//    }
}

struct Actor: Identifiable, Codable, FirebaseObjectable {
    @DocumentID var id: String?
    var projectId: String
    var realName: String
    var screenName: String
    var image: String
    var clothesSize: Int
    var images: [String]
    
    @ServerTimestamp var createdTime: Timestamp?
    
    enum CodingKeys: String, CodingKey {
        case id
        case projectId
        case realName
        case screenName
        case image
        case clothesSize
        case images
    }
    
    var objectName: String {
        return "actors"
    }
    
    var objectId: String? {
        return id
    }
    
    var dict: [String: Any] {
        return [
            "projectId": projectId,
            "realName": realName,
            "screenName": screenName,
            "image": image,
            "clothesSize": clothesSize,
            "images": images
        ]
    }
    
//    static func dummyActor() -> Actor {
//        return Actor(id: "denzel", projectId: "sadasdsad", realName: "Denzel Washington", screenName: "Alonzo Harris", image: "denzel", clothesSize: 32)
//    }
//    
//    static func dummyActor2() -> Actor {
//        return Actor(id: "viola", projectId: "dasdasdas", realName: "Voila Davis", screenName: "Rose Maxine", image: "viola", clothesSize: 6)
//    }
}

struct MovieScene: Identifiable, Codable, FirebaseObjectable {
    @DocumentID var id: String?
    var projectId: String
    var name: String
    var actors: [String]
    
    @ServerTimestamp var createdTime: Timestamp?
    
    enum CodingKeys: String, CodingKey {
        case id
        case projectId
        case name
        case actors
    }
    
    var objectName: String {
        return "scenes"
    }
    
    var objectId: String? {
        return id
    }
    
    var dict: [String: Any] {
        return [
            "projectId": projectId,
            "name": name,
            "actors": actors
        ]
    }
    
    static func dummyScene() -> MovieScene {
        return MovieScene(id: UUID().uuidString, projectId: "adsdad", name: "Scene 1", actors: ["dsfsdfds", "sadasdsad"])
    }
    
    static func dummyScene2() -> MovieScene {
        return MovieScene(id: UUID().uuidString, projectId: "sdfsdds", name: "Scene 2", actors: ["aasdsadsa"])
    }
}

struct SceneActor: Identifiable, Codable, FirebaseObjectable {
    @DocumentID var id: String?
    var sceneActorId: String
    var name: String
    var top: String
    var bottom: String
    var shoes: String
    var accessories: String
    var notes: String
    var beforeLook: Bool
    var image: String
    
    @ServerTimestamp var createdTime: Timestamp?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case sceneActorId
        case top
        case bottom
        case shoes
        case accessories
        case notes
        case beforeLook
        case image
    }
    
    var objectName: String {
        return "sceneActors"
    }
    
    var objectId: String? {
        return id
    }
    
    var dict: [String: Any] {
        return [
            "sceneActorId": sceneActorId,
            "name": name,
            "top": top,
            "bottom": bottom,
            "shoes": shoes,
            "accessories": accessories,
            "notes": notes,
            "beforeLook": beforeLook,
            "image": image
        ]
    }
}
