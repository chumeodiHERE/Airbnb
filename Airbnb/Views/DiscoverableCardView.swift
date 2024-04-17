//
//  DiscoverableCardView.swift
//  Airbnb
//
//  Created by Gia Huy on 14/02/2024.
//

import SwiftUI

struct DiscoverableCardView: View {
    let model: AirbnbListing    
    var body: some View {
        VStack {
            TabView {
                ForEach(model.images ?? [], id: \.self) { img in
                    AsyncImage(url: URL(string: img)) {image in
                        image.resizable()
                        image.aspectRatio(contentMode: .fill)
                    } placeholder: {
                        ProgressView()
                    }
                }
            }
            .frame(height: 320)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .tabViewStyle(.page)
            
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(model.name ?? "")
                        .fontWeight(.semibold)
                        .foregroundStyle(.black)
                    Text(model.updated_date ?? "")
                        .foregroundStyle(.gray)
                    Text("$\(model.price ?? 0) / night")
                        .fontWeight(.semibold)
                        .foregroundStyle(.black)
                }
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                    Text(String(format: "%.2f", model.reviews_rating ?? 5))
                }
                .foregroundStyle(.black)
            }
        }
        .padding()
    }
}
