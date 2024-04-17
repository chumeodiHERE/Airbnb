//
//  CardDetailView.swift
//  Airbnb
//
//  Created by Gia Huy on 14/02/2024.
//

import SwiftUI
import MapKit
struct CardDetailView: View {
    
    let model: AirbnbListing
    @Environment(\.dismiss) var dismiss
    @State private var amenitiesParterm: [amenitiesListing] = [.wifi, .kitchen, .pets_allowed, .washer]
    @StateObject var detailvm = CardDetailViewModel()
    @EnvironmentObject var authVm: AuthenticationViewModel
    @State private var warningNoTLoginAlert = false
    @State private var status: Bool = false
    
    
    var body: some View {
        ScrollView {
            ZStack(alignment: .topLeading) {
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
                .tabViewStyle(.page)
                
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left.circle.fill")
                            .font(.system(size: 35))
                            .foregroundStyle(.white)
                    }
                    .padding(30)
                    .padding(.top, 15)
                    
                    Spacer()
                    
                    Button {
                        switch authVm.authenticationState {
                        case .unauthenticated, .authenticating:
                            warningNoTLoginAlert = true
                        case .authenticated:
                            Task {
                                if await detailvm.checkItemExistinFavorList(id: model.id) == true {
                                    status.toggle()
                                    await detailvm.delItemFromFavorList(id: model.id)
                                } else {
                                    detailvm.addItemToFavorList(item: model)
                                    status.toggle()
                                }
                            }
                        }
                    } label: {
                        Image(systemName: status ==  true ? "heart.fill" : "heart")
                            .font(.system(size: 35))
                            .foregroundStyle(.white)
                    }
                    .alert(isPresented: $warningNoTLoginAlert) {
                        Alert(title: Text("⚠️ Important"), message: Text("You are not logged in"), dismissButton: .default(Text("Got it!")))
                    }
                    .padding(30)
                    .padding(.top, 15)
                }
                
            }
            
            
            VStack(alignment: .leading, spacing: 8) {
                Text(model.name ?? "")
                    .font(.title)
                    .fontWeight(.semibold)
                
                VStack(alignment: .leading) {
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                        
                        Text(String(format: "%.2f", model.reviews_rating ?? 5))
                        
                        Text("-")
                        
                        Text("\(model.number_of_reviews ?? 0) reviews")
                            .underline()
                            .fontWeight(.semibold)
                    }
                    .foregroundStyle(.black)
                    
                    Text(model.state ?? "")
                }
                .font(.caption)
            }
            .padding(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Hosted by \(model.host_name ?? "")")
                        .font(.headline)
                        .frame(width: 250, alignment: .leading)
                    
                    HStack(spacing: 2) {
                        Text("\(model.guests ?? 1) guest -")
                        Text("\(model.beds ?? 1) beds -")
                        Text("\(model.bedrooms ?? 1) bedrooms -")
                        Text("\(model.baths ?? 1) bathrooms")
                    }
                    .font(.caption)
                }
                .frame(width: 300, alignment: .leading)
                
                Spacer()
                
                Image("imgNotFound")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 75, height: 75)
                    .clipShape(Circle())
            }
            .padding()
            
            Divider()
            
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 12) {
                    Image(systemName: "medal")
                    
                    VStack(alignment: .leading) {
                        Text("Super hot")
                            .font(.footnote)
                            .fontWeight(.semibold)
                        Text("Superhosts are experienced, highly rated Hosts.")
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                    Spacer()
                }
                
                HStack(spacing: 12) {
                    Image(systemName: "door.right.hand.open")
                    
                    VStack(alignment: .leading) {
                        Text("Self check-in")
                            .font(.footnote)
                            .fontWeight(.semibold)
                        Text("Check yourself in with the lockbox.")
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                    Spacer()
                }
            }
            .padding()
            
            Divider()
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Where you'll sleep")
                    .font(.headline)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(1..<((model.bedrooms ?? 1) + 1)) { bedroom in
                            VStack {
                                Image(systemName: "bed.double")
                                
                                Text("Bedroom \(bedroom)")
                            }
                            .frame(width: 150, height: 100)
                            .overlay {
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(lineWidth: 1.0)
                                    .foregroundStyle(.gray)
                            }
                        }
                    }
                }
                .scrollTargetBehavior(.paging)
            }
            .padding()
            
            Divider()
            
            VStack(alignment: .leading, spacing: 16) {
                Text("What this place offers")
                    .font(.headline)
                
                ForEach(model.amenities ?? [], id: \.self) { amenity in
                    ForEach(amenitiesParterm) { element in
                        if amenity == element.title {
                            HStack {
                                Image(systemName: element.imgName)
                                    .frame(width: 32)
                                
                                Text(amenity)
                                    .font(.footnote)
                                
                                Spacer()
                            }
                        }
                    }
                }
            }
            .padding()
            
            Divider()
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Where you’ll be")
                    .font(.headline)
                
                Map() {
                    Marker(model.name ?? "", systemImage: "house.lodge.circle.fill", coordinate: CLLocationCoordinate2D(latitude: model.lat ?? 0.0001, longitude: model.lon ?? 0.0001))
                        .tint(.blue)
                }
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding()
        }
        .onAppear(perform: {
            switch authVm.authenticationState {
            case .unauthenticated, .authenticating:
                status = false
            case .authenticated:
                Task {
                    if await detailvm.checkItemExistinFavorList(id: model.id) == true {
                        status.toggle()
                    }
                }
            }
        })
        .toolbar(.hidden, for: .tabBar)
        .ignoresSafeArea()
        .padding(.bottom, 80)
        .overlay(alignment: .bottom) {
            VStack {
                Divider()
                    .padding(.bottom)
                
                HStack {
                    
                    VStack(alignment: .leading) {
                        Text("$\(model.price ?? 0)")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Text("Total before taxes")
                            .font(.footnote)
                        Text("Day number")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .underline()
                    }
                    
                    Spacer()
                    
                    Button {
                        
                        
                    } label: {
                        Text("Reserve")
                            .foregroundStyle(.white)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .frame(width: 140, height: 40)
                            .background(.pink)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                }
                .padding(.horizontal, 40)
            }
            .background(.white)
        }
    }
}
