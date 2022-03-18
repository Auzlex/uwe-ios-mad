//
//  Contact.swift
//  UWEContacts
//
//  Created by Charles Edwards on 11/02/2022.
//

import Foundation
import SwiftUI

struct Contact : Identifiable
{
    let id = UUID()
    let imageName : String
    let name: String
    let phone: String
    let email: String
    let role: String
}

let contacts = [
    Contact(
        imageName: "Lloyd_S",
        name: "Lloyd Savickas",
        phone: "+4411732 87478",
        email: "1loyd.savickas@uwe.ac.uk",
        role: "Programme Leader for BSc Games Technology"
    ),
    Contact(
        imageName: "Larry_B",
        name: "Larry Bull",
        phone: "+4411732 83161",
        email: "Larry. Bull@uwe .ac. uk",
        role:"Professor Artificial Intelligence "
    ),
    Contact(
        imageName: "Mic_P",
        name: "Mic Palmer",
        phone: "+4411732 85511",
        email: "Mic. Palmer@uwe.ac.uk",
        role:"Programme Leader for Digital Media"
    ),
    Contact(
        imageName: "Delia_F",
        name: "Delia Fairburn",
        phone: "+4411732 83343",
        email: "delia.fairburn@uwe.ac.uk",
        role: "Associate Head of Department - Student Experience"
    ),
    Contact (
        imageName: "Tim_B",
        name: "Tim Brails ford ",
        phone: "+4411732 86827",
        email: "Tim. Brailsford@uwe . ac. uk",
        role: "Head of Department"
    ),
    Contact(
        imageName: "Simon_S",
        name: "Simon Scarle",
        phone: "+4411732 85512",
        email: "Simon. Scarle@uwe. ac .uk",
        role:"Program Leader for MSc Commercial Games Development "
    )
            
]
