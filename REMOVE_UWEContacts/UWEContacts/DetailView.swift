//
//  DetailView.swift
//  UWEContacts
//
//  Created by Charles Edwards on 11/02/2022.
//

import SwiftUI

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(contact: contacts[0])
    }
}

struct DetailView: View {
    let contact: Contact
    var body: some View {
        Form {
            Image(contact.imageName)
                .clipShape(Circle())
            HStack{ 
                Text("phone")
                Spacer()
                Text(contact.phone)
                    .foregroundColor(.gray)
                    .font(.callout)
            }
        }
    }
}
