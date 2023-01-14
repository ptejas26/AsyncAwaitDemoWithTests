//
//  ViewController.swift
//  AsyncAwaitDemo
//
//  Created by Apple on 09/01/23.
//

import UIKit
import ClockKit

public class ViewController: UIViewController {
    
    @IBOutlet weak var imageView1: UIImageView!
    
    private let imageURL: String = "https://m.media-amazon.com/images/I/518d2cX0dhL._AC_UY436_QL65_.jpg"
    let viewModel = ViewModel()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
//        self.viewModel.fetchThumbnail(from: imageURL) { result in
//
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let image):
//                    self.imageView1.image = image
//                    break
//                case .failure(let error):
//                    print("Error at \(error)")
//                    break
//                }
//            }
//        }
        
        Task {
            do {
                let image = try await self.viewModel.fetchThumbnailWithAsyncAwait(with: self.imageURL)
                DispatchQueue.main.async {
                    self.imageView1.image = image
                }
            } catch {
                print(error)
            }
        }
    }
}
