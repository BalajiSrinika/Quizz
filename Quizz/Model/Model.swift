//
//  Model.swift
//  Quizz
//
//  Created by Balaji Pandian on 31/07/20.
//  Copyright © 2020 Balaji Pandian. All rights reserved.
//

import Foundation


// MARK: - Quizz
struct Quizz: Codable {
    let responseCode: Int
    let results: [Result]

    enum CodingKeys: String, CodingKey {
        case responseCode = "response_code"
        case results
    }
}

// MARK: - Result
struct Result: Codable {
    let category: Category
    let type: TypeEnum
    let question: String
    
   // let difficulty: Difficulty
    let correctAnswer: String
    var incorrectAnswers: [String]
    var selectedIndex = -1
    var selectedAnswer: String = ""
    var isCorrect: Bool!

    enum CodingKeys: String, CodingKey {
        case category, type, question
        case correctAnswer = "correct_answer"
        case incorrectAnswers = "incorrect_answers"
    }
}

enum Category: String, Codable {
    case generalKnowledge = "General Knowledge"
    case scienceNature = "Science & Nature"
}

enum CorrectAnswer: Codable {
    case integer(Int)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(CorrectAnswer.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for CorrectAnswer"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

enum Difficulty: String, Codable {
    case easy = "easy"
}

enum TypeEnum: String, Codable {
    case multiple = "multiple"
}

