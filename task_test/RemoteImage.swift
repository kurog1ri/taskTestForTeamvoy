//
//  RemoteImage.swift
//  task_test
//
//  Created by   Kosenko Mykola on 09.08.2023.
//

import SwiftUI
import Combine

struct RemoteImage: View {
    @ObservedObject private var imageLoader: ImageLoader
    @State private var image: UIImage?

    init(url: URL) {
        imageLoader = ImageLoader(url: url)
    }

    var body: some View {
        if let image = image {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            ProgressView()
                .onAppear(perform: loadImage)
        }
    }

    private func loadImage() {
        imageLoader.loadImage { loadedImage in
            image = loadedImage
        }
    }
}

class ImageLoader: ObservableObject {
    private var cancellable: AnyCancellable?
    private let url: URL
    @Published var image: UIImage?

    init(url: URL) {
        self.url = url
    }

    func loadImage(completion: @escaping (UIImage?) -> Void) {
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.image = $0
                completion($0)
            }
    }
}

