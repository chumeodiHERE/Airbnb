//
//  SearchView.swift
//  Airbnb
//
//  Created by Gia Huy on 17/02/2024.
//

import SwiftUI

struct SearchView: View {
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Where for")
                    .font(.footnote)
                    .fontWeight(.semibold)
                Text("Any where - Any week - Any guets")
                    .font(.footnote)
                    .foregroundStyle(.gray)
            }
            
            Spacer()
            
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .foregroundStyle(.black)
            })
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .overlay {
            Capsule()
                .stroke(lineWidth: 0.5)
                .foregroundStyle(.gray)
                .shadow(color: .black.opacity(0.4), radius: 2)
        }
        .padding()
    }
}

#Preview {
    SearchView()
}
