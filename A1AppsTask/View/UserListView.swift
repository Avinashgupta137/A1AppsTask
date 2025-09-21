//
//  UserListView.swift
//  A1AppsTask
//
//  Created by Avinash Gupta on 20/09/25.
//
import SwiftUI

struct InterviewDetailsView: View {
    @StateObject var vm = InterviewViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(vm.details) { detail in
                        InterviewCardView(user: detail)
                            .task {
                                await vm.loadMoreIfNeeded(currentItem: detail)
                            }
                    }
                    if vm.isLoading {
                        ProgressView()
                            .padding()
                    }
                }
                .padding()
            }
            .navigationTitle("Summer")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        print("Back tapped")
                    }) {
                        Image(systemName: "chevron.left")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        print("ellipsis")
                    }) {
                        Image(systemName: "ellipsis")
                    }
                }
            }
            .task {
                await vm.loadDetails(reset: true)
            }
            .refreshable {
                await vm.loadDetails(reset: true)
            }
        }
    }
}

struct InterviewCardView: View {
    let user: User
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .gray.opacity(0.2), radius: 8, x: 0, y: 4)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top, spacing: 12) {
                    AsyncImage(url: URL(string: user.image)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Color.gray.opacity(0.2)
                    }
                    .frame(width: 100, height: 130)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .offset(y: -25)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text(user.name)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text(user.email)
                            .font(.subheadline)
                            .overlay(
                                LinearGradient(colors: [.pink, .purple],
                                               startPoint: .leading,
                                               endPoint: .trailing)
                            )
                            .mask(
                                Text(user.email)
                                    .font(.subheadline)
                            )
    
                        HStack(alignment: .bottom) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Age: \(user.age)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text("DOB: \(user.dob)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text("$260")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                print("Tapped on \(user.name)")
                            }) {
                                Text("Shop")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                    .padding(.vertical, 6)
                                    .padding(.horizontal, 16)
                                    .background(
                                        LinearGradient(colors: [.pink, .purple],
                                                       startPoint: .leading,
                                                       endPoint: .trailing)
                                    )
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .padding(.top, 25)
    }
}
