//
//  DetailView.swift
//  task_test
//
//  Created by   Kosenko Mykola on 09.08.2023.
//

import SwiftUI

struct DetailView: View {
    let article: Article

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let imageUrl = URL(string: article.urlToImage ?? "") {
                    RemoteImage(url: imageUrl)
                        .aspectRatio(contentMode: .fit)
                }
                
                Text(article.title)
                    .font(.title)
                    .bold()
                    .padding(.horizontal)
                
                if let description = article.description {
                    Text(description)
                        .font(.body)
                        .padding(.horizontal)
                } else {
                    Text("No description available")
                        .font(.body)
                        .padding(.horizontal)
                }
                
                if let author = article.author {
                    Text("Author: \(author)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                }
                
                Text("Source: \(article.source.name)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                
                Text("Published At: \(article.publishedAt)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                
                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}




struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleArticle = Article(
            source: Source(id: "1", name: "Sample Source"),
            author: "John Doe",
            title: "Sample Article Title",
            description: "This is a sample article description.",
            url: "https://example.com/sample-article",
            urlToImage: "https://example.com/sample-image.jpg",
            publishedAt: "2023-08-09T12:34:56Z",
            content: "Sample article content."
        )
        
        return NavigationView {
            DetailView(article: sampleArticle)
        }
    }
}
