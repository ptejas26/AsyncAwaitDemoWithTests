//
//  ViewModel.swift
//  AsyncAwaitDemo
//
//  Created by Apple on 14/01/23.
//

import UIKit

class ViewModel {
    enum FetchError: Error {
        case badURL
        case badID
        case badImage
    }

    func thumbnailURLRequest(with url:String) -> URLRequest? {
        guard
            let url = URL(string: url) else {
            return nil
        }
        let urlRequest = URLRequest(url: url)
        return urlRequest
    }

    func fetchThumbnailWithAsyncAwait(with imageURL: String) async throws -> UIImage {
        guard let request = thumbnailURLRequest(with: imageURL) else { throw FetchError.badURL }
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw FetchError.badID }
        let maybeImage = UIImage(data: data)
        guard
            let thumbnail = await maybeImage?.byPreparingThumbnail(ofSize: CGSize(width: 100, height: 100)) else {
            throw FetchError.badImage
        }
        return thumbnail
    }
    
    func fetchThumbnail(from url: String, completion: @escaping (Result<UIImage,Error>) -> ()) {
        let thumbnailRequest = thumbnailURLRequest(with: url)!
        guard let url = URL(string: url) else {
            completion(.failure(FetchError.badID))
            return
        }
        URLSession.shared.dataTask(with: url) { responseData, urlResponse, error in
            if let error = error {
                completion(.failure(error))
            } else if (urlResponse as? HTTPURLResponse)?.statusCode != 200 {
                completion(.failure(FetchError.badID))
            } else {
                completion(.failure(FetchError.badImage))
//                guard let image = UIImage(data: responseData!) else {
//                    
//                    return
//                }
//                image.prepareThumbnail(of: CGSize(width: 40, height: 40)) { thumbnail in
//                    guard let thumbnail = thumbnail else {
//                        completion(.failure(FetchError.badImage))
//                        return
//                    }
//                    completion(.success(thumbnail))
//                }
            }
        }.resume()
    }
}
