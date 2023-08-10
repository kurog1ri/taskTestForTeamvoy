//
//  ContentView.swift
//  task_test
//
//  Created by   Kosenko Mykola on 09.08.2023.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search articles", text: $viewModel.searchKeyword)
                    .padding(.horizontal)
                Button("Search") {
                    viewModel.searchArticles()
                }
                
                Picker("Sort By", selection: $viewModel.sortingOption) {
                    ForEach(ViewModel.SortingOption.allCases, id: \.self) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                Picker("Time Interval", selection: $viewModel.selectedTimeInterval) {
                    ForEach(ViewModel.TimeIntervalOption.allCases, id: \.self) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .onChange(of: viewModel.selectedTimeInterval) { _ in
                                   viewModel.loadData()
                               }
                
                List(viewModel.items, id: \.title) { item in
                    NavigationLink(destination: DetailView(article: item)) {
                        VStack(alignment: .leading) {
                            Text(item.title)
                                .font(.headline)
                            Text(item.description ?? "")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .onAppear(perform: {
                    viewModel.loadData()
                    viewModel.sortItems()
                })
                .onChange(of: viewModel.sortingOption) { _ in
                    viewModel.sortItems()
                }
                .navigationBarTitle("Articles")
            }
        }
        .preferredColorScheme(.dark)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
