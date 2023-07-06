//
//  SidebarView.swift
//  UltimatePortfolio
//
//  Created by mnameit on 06/07/23.
//

import SwiftUI

struct SidebarView: View {
    @EnvironmentObject var dataController: DataController
    let smartFilter: [Filter] = [.all, .recent]
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var tags: FetchedResults<Tag>
    
    var tagFilter: [Filter] {
        tags.map { tag in
            Filter(id: tag.id ?? UUID(), name: tag.name ?? "No Name", icon: "tag", tag: tag)
        }
    }
    
    var body: some View {
        List(selection: $dataController.selectedFilter) {
            Section("Smart Filer"){
                ForEach(smartFilter) { filter in
                    NavigationLink(value: filter) {
                        Label(filter.name, systemImage: filter.icon)
                    }
                    
                }
            }
            
            Section("Tags"){
                ForEach(tagFilter) { filter in
                    NavigationLink(value: filter) {
                        Label(filter.name, systemImage: filter.icon)
                    }
                }
            }
        }
        .toolbar {
            Button {
                dataController.deleteAll()
                dataController.createSampleData()
            } label: {
                Label("Add Sample", systemImage: "flame")
            }
        }
    }
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView()
            .environmentObject(DataController.preview)
    }
}
