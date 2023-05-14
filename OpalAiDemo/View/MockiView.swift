//
//  MockiView.swift
//  OpalAiDemo
//
//  Created by Lei Chen on 5/13/23.
//

import SwiftUI
import Combine

struct MockiView: View {
    @ObservedObject var viewModel = ScanViewModel()
    private var count : Int = 0
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.scans) { scan in
                    NavigationLink(destination: ARScanView()) {
                        VStack(alignment: .leading) {
                            Text(scan.title)
                                .font(.title)
                                .padding(5)
                            Text("Description: " + scan.description)
                                .padding(5)
                            AsyncImage(urlString: scan.image)
                                .padding(10)
                            Text("Created at: " + scan.createdAt)
                                .padding(5)
                            Text("Created by: " + scan.user.name)
                                .padding(5)
                        }
                        .padding(10)
                    }
                    HStack{}
                        .onAppear{perform:
                        if scan.id == viewModel.scans.last?.id {
                            viewModel.nextPage()
                        }}
                        .listRowSeparator(.hidden)
                }
                .navigationTitle("Scans")
            }
        }
    }
}
