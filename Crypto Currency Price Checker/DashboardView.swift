//
//  DashboardView.swift
//  Crypto Currency Price Checker
//
//  Created by Charles Edwards on 06/05/2022.
//

import Foundation
import SwiftUI

extension String {

   func widthOfString(usingFont font: UIFont) -> CGFloat {
       let fontAttributes = [NSAttributedString.Key.font: font]
       let size = self.size(withAttributes: fontAttributes)
       return size.width
   }

   func heightOfString(usingFont font: UIFont) -> CGFloat {
       let fontAttributes = [NSAttributedString.Key.font: font]
       let size = self.size(withAttributes: fontAttributes)
       return size.height
   }

   func sizeOfString(usingFont font: UIFont) -> CGSize {
       let fontAttributes = [NSAttributedString.Key.font: font]
       return self.size(withAttributes: fontAttributes)
   }
}
//
//extension String {
//   func widthOfString(usingFont font: UIFont) -> CGFloat {
//        let fontAttributes = [NSAttributedString.Key.font: font]
//        let size = self.size(withAttributes: fontAttributes)
//        return size.width
//    }
//}

struct MarqueeText : View {
@State var text = ""
@State private var animate = false
    private let animationOne = Animation.linear(duration: 10).speed(0.05).repeatForever(autoreverses: false) //.delay(2.5)

var body : some View {
    let stringWidth = text.widthOfString(usingFont: UIFont.systemFont(ofSize: 15))
    return ZStack {
            GeometryReader { geometry in
                Text(self.text).lineLimit(1)
                    .font(.subheadline)
                    .offset(x: self.animate ? -stringWidth * 1.5 : 0)
                    .animation(self.animationOne)
                    .onAppear() {
                        if geometry.size.width < stringWidth {
                             self.animate = true
                        }
                }
                .fixedSize(horizontal: true, vertical: false)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                
                Text(self.text).lineLimit(1)
                    .font(.subheadline)
                    .offset(x: self.animate ? 0 : stringWidth * 1.5)
                    .animation(self.animationOne)
                    .fixedSize(horizontal: true, vertical: false)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
            }
        }
}
    
}
    
//extension String {
//
//   func widthOfString(usingFont font: UIFont) -> CGFloat {
//       let fontAttributes = [NSAttributedString.Key.font: font]
//       let size = self.size(withAttributes: fontAttributes)
//       return size.width
//   }
//
//   func heightOfString(usingFont font: UIFont) -> CGFloat {
//       let fontAttributes = [NSAttributedString.Key.font: font]
//       let size = self.size(withAttributes: fontAttributes)
//       return size.height
//   }
//
//   func sizeOfString(usingFont font: UIFont) -> CGSize {
//       let fontAttributes = [NSAttributedString.Key.font: font]
//       return self.size(withAttributes: fontAttributes)
//   }
//}

struct DashboardView: View {
    
    @ObservedObject var viewModel: CCPCViewModel
    @EnvironmentObject var favorites: Favorites
    
    @State var text = "What the fuck did you just fucking say about me, you little bitch? I'll have you know I graduated top of my class in the Navy Seals, and I've been involved in numerous secret raids on Al-Quaeda, and I have over 300 confirmed kills. I am trained in gorilla warfare and I'm the top sniper in the entire US armed forces. You are nothing to me but just another target. I will wipe you the fuck out with precision the likes of which has never been seen before on this Earth, mark my fucking words. You think you can get away with saying that shit to me over the Internet? Think again, fucker. As we speak I am contacting my secret network of spies across the USA and your IP is being traced right now so you better prepare for the storm, maggot. The storm that wipes out the pathetic little thing you call your life. You're fucking dead, kid. I can be anywhere, anytime, and I can kill you in over seven hundred ways, and that's just with my bare hands. Not only am I extensively trained in unarmed combat, but I have access to the entire arsenal of the United States Marine Corps and I will use it to its full extent to wipe your miserable ass off the face of the continent, you little shit. If only you could have known what unholy retribution your little clever comment was about to bring down upon you, maybe you would have held your fucking tongue. But you couldn't, you didn't, and now you're paying the price, you goddamn idiot. I will shit fury all over you and you will drown in it. You're fucking dead, kiddo."
    
    init(viewModel: CCPCViewModel)
    {
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        let stringWidth = text.widthOfString(usingFont: UIFont.systemFont(ofSize: 15))

        
        VStack (alignment: .leading) {
                MarqueeText(text: text)
        }
            //.frame(width: 230, height: 30)
        .frame(maxWidth: .infinity, maxHeight: 30, alignment: .top)
        .clipShape(RoundedRectangle(cornerRadius: 0, style: .continuous))
        .background(Color.yellow)
        .foregroundColor(Color.black)
        
        //.navigationBarTitle("Crypto Dashboard")
        
//        // Vstack
//        VStack(alignment: .leading) {
//
//            //ScrollView{
//
//            // NOTE: Removing these 2 vstacks fixes the safe area being ignored????
////                VStack(spacing: 20) {
////                    Text("Top Cryptos")
////                    Text("IMPLEMENT_TOP_CRYPTOS")
////                }
////                .frame(maxWidth: .infinity)
////
////                VStack(spacing: 20) {
////                    Text("Gainers & Losers")
////                    Text("IMPLEMENT_GAINERS_&_LOOSERS")
////                }
////                .frame(maxWidth: .infinity)
//
//                VStack(spacing: 20) {
//                    Text("News")
//                    ScrollView {
//                        ForEach((1...10), id: \.self) { i in
//                            HStack {
//                                AsyncImage(
//                                    url:URL(string:"https://ichef.bbci.co.uk/news/1024/branded_news/1257B/production/_118713157_gettyimages-897291236.jpg"),
//                                    content: { image in
//                                        image.resizable()
//                                            .aspectRatio(contentMode: .fit)
//                                            .frame(maxHeight: 100)
//                                    },
//                                    placeholder: {
//                                        //ProgressView()
//                                        Image("nosign")
//                                    }
//                                )
//                                .cornerRadius(10)
//                                //.padding(.all, 5)
//                                //.frame(maxWidth: 100, maxHeight: 100)
//                                .frame(width: 100, height: 100)
//                                //.aspectRatio(contentMode: .fit)
//
//                                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut quis nunc in ligula pretium varius. Integer velit nulla, posuere in tempor vel, viverra vel ante. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce interdum in sapien sit amet pharetra. Sed sed risus sed diam commodo tristique et non est. Aenean nec dapibus quam. Vivamus convallis ipsum sed arcu egestas mattis placerat ut elit.")
//                                .padding()
//                                .font(.system(size: 12))
//                                .overlay(
//                                        RoundedRectangle(cornerRadius: 0)
//                                            .stroke(Color.gray, lineWidth: 1)
//                                        )
//                            }
//                        }
//                    }
//                }
//                //.frame(maxWidth: .infinity)//, maxHeight: 400)
//                //.background(Color.gray)
//
//            //}
//            //.frame(maxWidth: .infinity)
//            //.background(Color.gray)
//
//
//        }
//        .navigationBarTitle("Crypto Dashboard") // define navigation view title
        
    }
    
}
