//
//  TranslatorDependencies.swift
//  Data
//
//  Created by Bao Nguyen on 13/2/25.
//

protocol TranslatorDependencies {
    var userTranslator: UserTranslator { get }
}

final class DefaultTranslatorDependencies: TranslatorDependencies {
    lazy var userTranslator: UserTranslator = {
        DefaultUserTranslator()
    }()
}
