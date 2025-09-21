//
//  UserViewModel.swift
//  A1AppsTask
//
//  Created by Avinash Gupta on 20/09/25.
//

import SwiftUI

@MainActor
class InterviewViewModel: ObservableObject {
    @Published var details: [User] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    private var allDetails: [User] = []
    private var currentPage = 1
    private let pageSize = 10
    
    func loadDetails(reset: Bool = false) async {
        if reset {
            currentPage = 1
            details.removeAll()
            allDetails.removeAll()
        }
        
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        
        do {
            let fetched = try await APIService.shared.fetchInterviewDetails()
            allDetails = fetched
            let endIndex = min(pageSize, allDetails.count)
            details = Array(allDetails[..<endIndex])
            
        } catch {
            errorMessage = "Failed to fetch: \(error)"
            print("Error fetching interview details:", error)
        }
        
        isLoading = false
    }
    
    func loadMoreIfNeeded(currentItem item: User?) async {
        guard let item = item else { return }
        guard let itemIndex = details.firstIndex(where: { $0.id == item.id }) else { return }
        
        let thresholdIndex = details.index(details.endIndex, offsetBy: -3)
        if itemIndex >= thresholdIndex {
            await loadNextPage()
        }
    }
    
    private func loadNextPage() async {
        guard !isLoading else { return }
        
        let startIndex = currentPage * pageSize
        let endIndex = min(startIndex + pageSize, allDetails.count)
        guard startIndex < allDetails.count else { return }
        isLoading = true
        try? await Task.sleep(nanoseconds: 500_000_000)
        let nextPage = Array(allDetails[startIndex..<endIndex])
        details.append(contentsOf: nextPage)
        currentPage += 1
        isLoading = false
    }
}
