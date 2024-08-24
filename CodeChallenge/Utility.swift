//
//  Utility.swift
//  Code Challenge
//
//  Created by Youngjoon Kim on 8/24/24.
//

import Foundation

func formatDate(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "M.d.yyyy"
    return date.formatted(date: .complete, time: .omitted)
    // return formatter.string(from: date)
}
