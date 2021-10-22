//
//  SearchUseCase.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/22.
//

import Foundation
import RxSwift

struct SearchUseCase {
    private let provider: NetworkProvider<SearchService>
    
    init(_ provider: NetworkProvider<SearchService> = .init()) {
        self.provider = provider
    }
    
    func fetchSearchList(
        query: String,
        offset: Int = 0,
        limit: Int = 50,
        country: SearchService.CountryType = .KR
    ) -> Observable<[SearchModel.Result]> {
        return provider.request(
            SearchModel.self,
            target: .getSearchList(
                term: query,
                offset: offset,
                limit: limit,
                country: country
            )
            
        )
            .map({ $0.results })
            .asObservable()
    }
}
