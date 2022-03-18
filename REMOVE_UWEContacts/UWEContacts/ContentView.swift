//
//  ContentView.swift
//  UWEContacts
//
//  Created by Charles Edwards on 11/02/2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        List(contacts) {
            contact in ContactRow(contact: contact)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ContactRow: View {
    let contact: Contact
    var body: some View {
        HStack {
            Image(contact.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 60)
                .clipped()
                .cornerRadius(50)
            
            VStack (alignment: .leading) {
                Text(contact.name)
                    .font(.system(size:21,weight:.medium, design:.default))
                Text(contact.phone)
            }
        }
    }
}

