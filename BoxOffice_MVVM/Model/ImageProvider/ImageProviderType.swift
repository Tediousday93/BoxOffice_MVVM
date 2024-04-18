//
//  ImageProviderType.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/03/08.
//

import Foundation
import UIKit.UIImage

protocol ImageProviderType {
    func fetchImage(
        from url: URL,
        completion: @escaping (Result<UIImage, Error>) -> Void
    )
}
