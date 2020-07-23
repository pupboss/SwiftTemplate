//
//  NewsModel.swift
//  MeltdownPlatform
//
//  Created by Jie Li on 29/6/20.
//  Copyright © 2020 Meltdown Research. All rights reserved.
//

import Foundation

struct NewsModel: Codable {
    let sourceName: String
    let author: String?
    let title: String
    let description: String?
    let url: String
    let imageUrl: String?
    let country: String
    let category: String
    let publishedAt: Date
}
