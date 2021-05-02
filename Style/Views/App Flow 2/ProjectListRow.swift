//
//  ProjectListRow.swift
//  Scene Me
//
//  Created by Vince Davis on 4/30/21.
//

import SwiftUI

struct Project2 {
    var name: String
    var description: String
    var startDate: Date
    var endDate: Date
    var image: String
    var scriptUrl: String
    
    var createdBy: String
    var createdDate: Date
    var modifiedBy: String
    var modifiedDate: Date
    
    static var preview: Project2 {
        let imageUrl = "https://m.media-amazon.com/images/M/MV5BNGVjNWI4ZGUtNzE0MS00YTJmLWE0ZDctN2ZiYTk2YmI3NTYyXkEyXkFqcGdeQXVyMTkxNjUyNQ@@._V1_.jpg"
        
        let scriptUrl = ""
        
        return Project2(name: "Big Fifty",
                        description: "BET Movie movie",
                        startDate: Date.createFrom("04-27-2021"),
                        endDate: Date.createFrom("05-30-2021"),
                        image: imageUrl,
                        scriptUrl: scriptUrl,
                        createdBy: "Vince",
                        createdDate: Date.createFrom("05-30-2021"),
                        modifiedBy: "Angelique",
                        modifiedDate: Date.createFrom("05-30-2021"))
    }
}

struct ProjectListRow: View {
    var project: Project2
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ProjectListRow_Previews: PreviewProvider {
    static var previews: some View {
        ProjectListRow(project: Project2.preview)
    }
}
