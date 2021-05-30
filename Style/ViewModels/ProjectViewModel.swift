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
    
    @Published var notes: [Note] = []
    @Published var currentNote: Note?
    
    @Published var actorLooks: [ActorLook] = []
    @Published var currentActorLook: ActorLook?
    
    @Published var projectImages: [ProjectImage] = []
    
    @Published var sceneContinuities: [SceneContinuity] = []
    
    @Published var messages: [ProjectMessage] = []
    
    @Published var currentActorSize: ActorSize?
    
    @Published var showSceneDetails: Bool = false
    
    var didChange = PassthroughSubject<Void, Never>()
    var message = PassthroughSubject<String, Never>()

    var loading = PassthroughSubject<Bool, Never>()
    
    private var database = Firestore.firestore()
    private var storage = Storage.storage().reference()

    func fetchProjects(uid: String) {
        database.collection("projects")
            //.whereField("admins", arrayContainsAny: [uid])
            .order(by: "name", descending: false)
            .addSnapshotListener { (querySnapshot, error) in
          guard let documents = querySnapshot?.documents else {
            print("No Projects")
            return
          }
            
            self.projects = documents.compactMap { queryDocumentSnapshot -> Project? in
                return try? queryDocumentSnapshot.data(as: Project.self)
            }
            .filter { $0.admins.contains(uid) }
        }
    }
    
    func fetchProjectImagess(projectId: String) {
        database.collection("projectImages")
            .whereField("projectId", isEqualTo: projectId)
            .addSnapshotListener { (querySnapshot, error) in
          guard let documents = querySnapshot?.documents else {
            print("No Project Images")
            return
          }
            
            self.projectImages = documents.compactMap { queryDocumentSnapshot -> ProjectImage? in
                return try? queryDocumentSnapshot.data(as: ProjectImage.self)
            }
            //.filter { $0.admins.contains(uid) }
        }
    }
    
    func fetchProjectMessages(projectId: String, uid: String) {
        database.collection("projectMessages")
            .whereField("projectId", isEqualTo: projectId)
            .addSnapshotListener { (querySnapshot, error) in
          guard let documents = querySnapshot?.documents else {
            print("No Project Messages")
            return
          }
            
            self.messages = documents.compactMap { queryDocumentSnapshot -> ProjectMessage? in
                return try? queryDocumentSnapshot.data(as: ProjectMessage.self)
            }
            .filter { $0.to == uid }
        }
    }
    
    func fetchSceneContinuities(projectId: String) {
        database.collection("sceneContinuities")
            .whereField("projectId", isEqualTo: projectId)
            .addSnapshotListener { (querySnapshot, error) in
          guard let documents = querySnapshot?.documents else {
            print("No Project Images")
            return
          }
            
            self.sceneContinuities = documents.compactMap { queryDocumentSnapshot -> SceneContinuity? in
                return try? queryDocumentSnapshot.data(as: SceneContinuity.self)
            }
            //.filter { $0.admins.contains(uid) }
        }
    }
    
    func fetchUser(for uid: String) {
        database.collection("users")
            .whereField("uid", isEqualTo: uid)
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
                print("found user \(String(describing: self.currentUser?.image))")
        }
    }
    
    func fetchUsers(exclude uid: String) {
        database.collection("users")
            .whereField("uid", isNotEqualTo: uid)
            .getDocuments() { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
              print("No users")
              return
            }
      
                self.users = documents.compactMap { queryDocumentSnapshot -> ProjectUser? in
                return try? queryDocumentSnapshot.data(as: ProjectUser.self)
            }
        }
    }
    
    func fetchActors(for projectId: String) {
        database.collection("actors")
            .whereField("projectId", isEqualTo: projectId)
            .getDocuments() { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
              print("No documents")
              return
            }
      
            self.actors = documents.compactMap { queryDocumentSnapshot -> Actor? in
                return try? queryDocumentSnapshot.data(as: Actor.self)
            }.sorted {
                $0.screenName < $1.screenName
            }
        }
    }
    
    func fetchScenes(for projectId: String) {
        database.collection("scenes")
            .whereField("projectId", isEqualTo: projectId)
            .order(by: "number", descending: false)
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
        
        return scenesForActor.sorted {
            $0.number < $1.number
        }
    }
    
    func fetchSceneActors(for sceneActorId: String) {
        database.collection("sceneActors")
            .whereField("sceneActorId", isEqualTo: sceneActorId)
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
    
    func fetchNotes(for actorId: String) {
        database.collection("notes")
            .whereField("actorId", isEqualTo: actorId)
            .getDocuments() { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
              print("No Notes")
              return
            }
      
            self.notes = documents.compactMap { queryDocumentSnapshot -> Note? in
                return try? queryDocumentSnapshot.data(as: Note.self)
            }
        }
    }
    
    func fetchActorLooks(for actorId: String) {
        database.collection("actorLooks")
            .whereField("actorId", isEqualTo: actorId)
            .getDocuments() { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
              print("No Actor Looks")
              return
            }
      
            self.actorLooks = documents.compactMap { queryDocumentSnapshot -> ActorLook? in
                return try? queryDocumentSnapshot.data(as: ActorLook.self)
            }
        }
    }
    
    func fetchActorSize(for actorId: String) {
        database.collection("actorSizes")
            .whereField("actorId", isEqualTo: actorId)
            .getDocuments() { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
              print("No Actor Sizes")
              return
            }
      
            self.currentActorSize = documents.compactMap { queryDocumentSnapshot -> ActorSize? in
                return try? queryDocumentSnapshot.data(as: ActorSize.self)
            }.first
                
                //completion(self.currentActorSize)
        }
    }

    func add(object: FirebaseObjectable, completion: @escaping (String) -> ()) {
        var ref: DocumentReference? = nil
        ref = database.collection(object.objectName).addDocument(data: object.dict) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                self.didChange.send()
                self.message.send(object.successMessage)
                completion(ref!.documentID)
            }
        }
    }
    
    func delete(object: FirebaseObjectable, completion: @escaping (String) -> ()) {
        let ref = database.collection(object.objectName).document(object.objectId!)
        
        ref.delete(completion: { err in
            if let error = err {
                print("error updating time: \(error.localizedDescription)")
            } else {
                completion("deleted")
            }
        })
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
        let _ = storageRef.putData(data, metadata: nil) { (metadata, error) in
          guard let _ = metadata else {
            print("Error uploading data to path: \(path)")
            completion(nil)
            return
          }
          // Metadata contains file metadata such as size, content-type.
          //let size = metadata.size
          // You can also access to download URL after upload.
            storageRef.downloadURL { (url, error) in
            guard let _ = url else {
              completion(nil)
              return
            }
            completion(url)
          }
        }
    }
    
    func fetchactorImageDetails(for image: String, completion: @escaping (ActorImage?) -> Void) {
        database.collection("images").whereField("image", isEqualTo: image)
            .getDocuments() { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
              print("No documents")
                completion(nil)
              return
            }
                do {
                    let image = try documents.first?.data(as: ActorImage.self)
                    completion(image)
                } catch let err {
                    print("doc error \(err.localizedDescription)")
                }
        }
    }
    
    func save(pdfScenes: [PDFScene], with name: String, user: String, completion: @escaping () -> Void) {
        let project = Project(id: nil,
                              name: name,
                              image: "",
                              admins: [user],
                              readOnlyUsers: [],
                              creatorId: user,
                              dateCreated: Date(),
                              lastUser: user,
                              lastUpdated: Date(),
                              createdTime: nil)
        
        var ref: DocumentReference? = nil
        ref = database.collection(project.objectName).addDocument(data: project.dict) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                for pdfScene in pdfScenes {
                    let scene = MovieScene(id: nil, projectId: ref!.documentID, name: pdfScene.text, number: Int(pdfScene.number) ?? 0, actors: [], images: [], createdTime: nil)
                    self.add(object: scene) { _ in }
                }
                completion()
            }
        }
    }
    
//    func getAllImages() {
//        //var totalSize: Int64 = 0
//        //var fileCount = 0
//        let storageRef = storage.child("images")
//        storageRef.listAll { (result, error) in
//            if let err = error {
//                print("Image count error \(err.localizedDescription)")
//                return
//            }
//            print("Image count \(result.prefixes)")
//            for item in result.prefixes {
//                print("item is \(item.fullPath)")
//            }
//            for item in result.items {
//                item.getMetadata { metaData, error in
//                    if error != nil {
//                        print(error?.localizedDescription)
//                    } else {
//                        totalSize += metaData!.size
//
//                        fileCount += 1
//
//                       // Once all the files have been counted, print out the total size
//                        if fileCount == result.items.count {
//                            print("The total file size is: \(self.format(bytes: Double(totalSize)))")
//                       }
//                    }
//                }
//            }
//        }
//    }
    
    func getActorImages(section: Int, completion: @escaping () -> Void) {
        loading.send(true)
        self.currentActorImages = []
        var tempList: [String] = []
        
        var totalSize: Int64 = 0
        var fileCount = 0
        
        let actorImageRef = storage.child("images/actors/\(currentActor?.id ?? "")/gallery/\(section)")
        actorImageRef.listAll { (result, error) in
            if let err = error {
                print("Image count error \(err.localizedDescription)")
                return
            }
            print("Image count \(result.items.count)")
            if result.items.count == 0 {
                self.loading.send(false)
                return
            }
            for item in result.items {
                item.getMetadata { metaData, error in
                    if let err = error {
                        print(err.localizedDescription)
                    } else {
//                        totalSize += metaData!.size
//
//                        fileCount += 1
//
//                       // Once all the files have been counted, print out the total size
//                        if fileCount == result.items.count {
//                            print("The total file size is: \(self.format(bytes: Double(totalSize)))")
//                       }
                    }
                }
                
                item.downloadURL { url, error in
                    if let imageUrl = url {
                        tempList.append(imageUrl.absoluteString)
                        if tempList.count == result.items.count {
                            self.currentActorImages = tempList
                            self.loading.send(false)
                            completion()
                        }
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
        let _ = riversRef.putFile(from: urlPath, metadata: nil) { metadata, error in
          guard let _ = metadata else {
            print("Error uploading url \(urlPath.absoluteString) to path: \(path)")
            completion(nil)
            return
          }
          // Metadata contains file metadata such as size, content-type.
          //let size = metadata.size
          // You can also access to download URL after upload.
          riversRef.downloadURL { (url, error) in
            guard let _ = url else {
                completion(nil)
              return
            }
            completion(url)
          }
        }
    }
}

/// Helper Methods
extension ProjectViewModel {
    func format(bytes: Double) -> String {
        guard bytes > 0 else {
            return "0 bytes"
        }

        // Adapted from http://stackoverflow.com/a/18650828
        let suffixes = ["bytes", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"]
        let k: Double = 1000
        let i = floor(log(bytes) / log(k))

        // Format number with thousands separator and everything below 1 GB with no decimal places.
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = i < 3 ? 0 : 1
        numberFormatter.numberStyle = .decimal

        let numberString = numberFormatter.string(from: NSNumber(value: bytes / pow(k, i))) ?? "Unknown"
        let suffix = suffixes[Int(i)]
        return "\(numberString) \(suffix)"
    }
}

/// Preview
extension ProjectViewModel {
    static func preview() -> ProjectViewModel {
        let vm: ProjectViewModel = ProjectViewModel()
        
        vm.projects = [Project.preview(), Project.preview()]
        vm.currentProject = Project.preview()
        
        vm.actors = [Actor.preview(), Actor.preview()]
        vm.currentActor = Actor.preview()
        
        vm.scenes = [MovieScene.preview(), MovieScene.preview()]
        vm.currentScene = MovieScene.preview()
        
        vm.messages = [ProjectMessage.preview()]
        
        return vm
    }
}

struct SceneContinuity: Identifiable, Codable, FirebaseObjectable {
    @DocumentID var id: String?
    var projectId: String
    var scene1: String
    var scene2: String
    
    @ServerTimestamp var createdTime: Timestamp?
    
    enum CodingKeys: String, CodingKey {
        case id
        case projectId
        case scene1
        case scene2
    }
    
    var objectName: String {
        return "sceneContinuities"
    }
    
    var objectId: String? {
        return id
    }
    
    var dict: [String: Any] {
        return [
            "projectId": projectId,
            "scene1": scene1,
            "scene2": scene2,
        ]
    }
    
    var successMessage: String {
        return "Scene Continuity added"
    }
}

struct ActorImage: Identifiable, Codable, FirebaseObjectable {
    @DocumentID var id: String?
    var actorId: String
    var name: String
    var top: String
    var bottom: String
    var shoes: String
    var accessories: String
    var notes: String
    var image: String
    
    @ServerTimestamp var createdTime: Timestamp?
    
    enum CodingKeys: String, CodingKey {
        case id
        case actorId
        case name
        case top
        case bottom
        case shoes
        case accessories
        case notes
        case image
    }
    
    var objectName: String {
        return "images"
    }
    
    var objectId: String? {
        return id
    }
    
    var dict: [String: Any] {
        return [
            "actorId": actorId,
            "name": name,
            "top": top,
            "bottom": bottom,
            "shoes": shoes,
            "accessories": accessories,
            "notes": notes,
            "image": image
        ]
    }
    
    var successMessage: String {
        return "Image Details added"
    }
}

struct ProjectImage: Identifiable, Codable, FirebaseObjectable {
    @DocumentID var id: String?
    var projectId: String
    var actorIds: [String]
    var sceneIds: [String]
    var deptId: Int
    var notes: String
    var image: String
    
    @ServerTimestamp var createdTime: Timestamp?
    
    enum CodingKeys: String, CodingKey {
        case id
        case projectId
        case actorIds
        case sceneIds
        case deptId
        case notes
        case image
    }
    
    var objectName: String {
        return "projectImages"
    }
    
    var objectId: String? {
        return id
    }
    
    var dict: [String: Any] {
        return [
            "projectId": projectId,
            "actorIds": actorIds,
            "sceneIds": sceneIds,
            "deptId": deptId,
            "notes": notes,
            "image": image
        ]
    }
    
    var successMessage: String {
        return "Project Image(s) added"
    }
}

struct ProjectMessage: Identifiable, Codable, FirebaseObjectable {
    @DocumentID var id: String?
    var projectId: String
    var messageId: String
    var from: String
    var to: String
    var title: String
    var text: String
    var image: String
    var read: Bool
    var created: Date
    var createdBy: String
    
    @ServerTimestamp var createdTime: Timestamp?
    
    enum CodingKeys: String, CodingKey {
        case id
        case projectId
        case messageId
        case from
        case to
        case title
        case text
        case image
        case read
        case created
        case createdBy
    }
    
    var objectName: String {
        return "projectMessages"
    }
    
    var objectId: String? {
        return id
    }
    
    var dict: [String: Any] {
        return [
            "projectId": projectId,
            "messageId": messageId,
            "from": from,
            "to": to,
            "title": title,
            "text": text,
            "image": image,
            "read": read,
            "created": created,
            "createdBy": createdBy
        ]
    }
    
    var successMessage: String {
        return "Project Message added"
    }
    
    static func preview() -> ProjectMessage {
        return ProjectMessage(id: nil,
                              projectId: "1111",
                              messageId: "1111",
                              from: "Vince Davis",
                              to: "1111",
                              title: "Cool Title",
                              text: "This is my demo text. this needs to be a couple of lines long so that I can see if it will cut off like I think it should.",
                              image: "",
                              read: false,
                              created: Date(),
                              createdBy: "1111",
                              createdTime: nil)
    }
}
