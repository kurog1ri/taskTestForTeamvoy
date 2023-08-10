//
//  ViewModel.swift
//  task_test
//
//  Created by   Kosenko Mykola on 09.08.2023.
//

import Foundation

let getURL = "https://newsapi.org/v2/everything?q=bitcoin&apiKey=e34edcdf7238472ab6ddc773c5791407"

extension Date {
    func toString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

class ViewModel: ObservableObject {
    @Published var items = [Article]()
    @Published var sortingOption: SortingOption = .date
    @Published var searchKeyword = ""
    @Published var selectedTimeInterval: TimeIntervalOption = .allTime
    
    
    enum TimeIntervalOption: String, CaseIterable {
           case allTime = "All Time"
           case last24Hours = "Last 24 Hours"
           case last7Days = "Last 7 Days"
           
           var dateRange: ClosedRange<Date> {
               let today = Date()
               switch self {
               case .allTime:
                   return .init(uncheckedBounds: (lower: .distantPast, upper: .distantFuture))
               case .last24Hours:
                   return Calendar.current.date(byAdding: .hour, value: -24, to: today)!...today
               case .last7Days:
                   return Calendar.current.date(byAdding: .day, value: -7, to: today)!...today
               }
           }
       }
    
    enum SortingOption: String, CaseIterable {
        case date = "Date"
        case title = "Title"
        case author = "Author"
        case everything = "Everything"
        
        func sortFunction(article1: Article, article2: Article) -> Bool {
            switch self {
            case .date:
                return article1.publishedAt > article2.publishedAt
            case .title:
                return article1.title.localizedCompare(article2.title) == .orderedAscending
            case .author:
                return article1.author?.localizedCompare(article2.author ?? "") == .orderedAscending
            case .everything:
                return true // Всегда возвращает true, чтобы не изменять порядок
            }
        }
    }
    var articlesURL: URL? {
        guard !searchKeyword.isEmpty,
              let encodedKeyword = searchKeyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return nil
        }
        
        let fromDate = selectedTimeInterval.dateRange.lowerBound.toString(format: "yyyy-MM-dd")
        let toDate = selectedTimeInterval.dateRange.upperBound.toString(format: "yyyy-MM-dd")
        
        return URL(string: "https://newsapi.org/v2/everything?q=\(encodedKeyword)&from=\(fromDate)&to=\(toDate)&apiKey=e34edcdf7238472ab6ddc773c5791407")
    }
    
    func sortItems() {
        if sortingOption != .everything {
            items.sort(by: sortingOption.sortFunction)
        }
    }
    
    func loadData() {
        guard let url = URL(string: getURL) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(Response.self, from: data)
                    DispatchQueue.main.async {
                        self.items = response.articles
                    }
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                print("No data")
            }
        }.resume()
    }
    func searchArticles() {
        guard !searchKeyword.isEmpty,
              let encodedKeyword = searchKeyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://newsapi.org/v2/everything?q=\(encodedKeyword)&apiKey=e34edcdf7238472ab6ddc773c5791407") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                if let data = data {
                    let response = try JSONDecoder().decode(Response.self, from: data)
                    DispatchQueue.main.async {
                        self.items = response.articles
                    }
                } else {
                    print("No data")
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}
