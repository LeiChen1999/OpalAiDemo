//
//  ScanViewModel.swift
//  OpalAiDemo
//
//  Created by Lei Chen on 5/15/23.
//

import Foundation
import Combine

struct Scan: Identifiable, Decodable {
    var id = UUID()
    let title: String
    let description: String
    let image: String
    var createdAt: String
    let user: User

    private enum CodingKeys: String, CodingKey {
        case title, description, image, createdAt, user
    }
}


struct User: Decodable {
    let name: String
}

struct Response: Decodable {
    let data: [Scan]
}

class ScanViewModel: ObservableObject {
    @Published var scans = [Scan]()
    
    private var currentPage = 0
    private let urls = ["https://mocki.io/v1/896514eb-bf94-435b-bc51-1a139dfad75e", "https://mocki.io/v1/ff2c7e95-746e-43d2-86dd-0499a946d255"]
    private var cancellables = Set<AnyCancellable>()

    init() {
        fetchScans()
    }

    func fetchScans() {
        if currentPage < urls.count {
            let url = urls[currentPage]
            URLSession.shared.dataTaskPublisher(for: URL(string: url)!)
                .map { $0.data }
                .decode(type: Response.self, decoder: JSONDecoder())
                .replaceError(with: Response(data: []))
                .receive(on: DispatchQueue.main)
                .sink { [weak self] response in
                    self?.scans = response.data
                    self?.processCreatedAt()
                }
                .store(in: &cancellables)
        }
    }
    
    func nextPage() {
        currentPage += 1
        fetchScans()
    }
    
    func firstPage() {
        currentPage = 0
        fetchScans()
    }
    
    private func processCreatedAt() {
        for index in 0..<scans.count {
            let scan = scans[index]
            let formattedDate = formatCreatedAt(dateString: scan.createdAt)
            scans[index].createdAt = formattedDate
        }
    }
    
    private func formatCreatedAt(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return dateFormatter.string(from: date)
        }
        
        return dateString
    }
}

