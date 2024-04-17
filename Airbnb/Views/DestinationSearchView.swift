//
//  DestinationSearchView.swift
//  Airbnb
//
//  Created by Gia Huy on 13/04/2024.
//

import SwiftUI

enum DestinationSearchOption {
    case location
    case guests
}

struct DestinationSearchView: View {
    
    @Binding var show: Bool
    @ObservedObject var vm: DiscoverableViewModel
    @State private var selectOption: DestinationSearchOption = .location
    @State private var guestsNumber = 0
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    withAnimation(.snappy) {
                        show.toggle()
                    }
                } label: {
                    Image(systemName: "xmark.circle")
                        .imageScale(.large)
                        .foregroundStyle(.black)
                }
                
                Spacer()
                
                if vm.searchContext.isEmpty == false {
                    Button {
                        vm.searchContext = ""
                        vm.searchPlaceLocation()
                    } label: {
                        Text("Clear")
                            .foregroundStyle(.black)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                }
            }
            .padding()
            
            
            VStack(alignment: .leading) {
                
                if selectOption == .location {
                    Text("Where to?")
                        .font(.title2)
                        .fontWeight(.semibold)
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .imageScale(.small)
                        TextField("Search for any place name", text: $vm.searchContext)
                            .font(.subheadline)
                            .onSubmit {
                                vm.searchPlaceLocation()
                                show.toggle()
                            }
                    }
                    .frame(height: 40)
                    .padding(.horizontal)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: 1.0)
                            .foregroundStyle(.gray)
                    }
                } else {
                    CollapsePickerView(title: "Where", description: "Add place name")
                }
                
            }
            .padding()
            .frame(height: selectOption == .location ? 120 : 60)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding()
            .shadow(radius: 10)
            .onTapGesture {
                withAnimation(.snappy) {
                    selectOption = .location
                }
            }
            
            VStack {
                if selectOption == .guests {
                    VStack(alignment: .leading) {
                        Text("Who's coming?")
                            .font(.title)
                            .fontWeight(.semibold)
                        VStack {
                            Stepper {
                                Text("\(self.guestsNumber) Adults")
                            } onIncrement: {
                                self.guestsNumber += 1
                            } onDecrement: {
                                self.guestsNumber -= 1
                            }
                        }
                    }
                    .padding()
                    .frame(height: selectOption == .guests ? 120 : 60)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding()
                    .shadow(radius: 10)
                } else {
                    VStack(alignment: .leading) {
                        CollapsePickerView(title: "Who", description: "Add guests")
                    }
                    .padding()
                    .frame(height: selectOption == .guests ? 120 : 60)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding()
                    .shadow(radius: 10)
                    .onTapGesture {
                        withAnimation(.snappy) {
                            selectOption = .guests
                        }
                    }
                }
            }
        }
        Spacer()
    }
}

#Preview {
    DestinationSearchView(show: .constant(false), vm: DiscoverableViewModel())
}

struct CollapsePickerView: View {
    let title: String
    let description: String
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .foregroundStyle(.gray)
                Spacer()
                Text(description)
            }
            .fontWeight(.semibold)
            .font(.subheadline)
        }
    }
}
