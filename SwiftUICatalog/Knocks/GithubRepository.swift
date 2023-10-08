//
//  GithubRepository.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/23.
//

import Combine
import Foundation
@MainActor
class Repository: ObservableObject {
    @Published var isLoading = false

    // for combine
    var reposPublisher: AnyPublisher<[Repo], Never> { repos.eraseToAnyPublisher() }
    // for combine
    var repos: CurrentValueSubject<[Repo], Never> = .init([])

    var currentQuery = ""
    var currentPage = 1

    var api: API = .init()
    var continuation: AsyncStream<[Repo]>.Continuation?
    lazy var stream = AsyncStream<[Repo]> { continuation in
        self.continuation = continuation
    }

    deinit {
        continuation?.finish()
    }

    // for async await
    func search(query: String) async {
        if currentQuery != query {
            currentQuery = query
            currentPage = 0
        }
        await next()
    }

    // for async await
    func next() async {
        if isLoading {
            print("now loading")
            return
        }

        isLoading = true
        currentPage += 1
        do {
            let result = try await api.searchRepos(endpoint: GithubEndpoint(query: currentQuery, page: currentPage))
            continuation?.yield(result.items)
        } catch _ {
            print("fail")
            isLoading = false
            return
        }
        isLoading = false
    }

    // for closure
    func search(query: String, completion: @escaping ([Repo]) -> Void) {
        guard !isLoading else { return }
        isLoading = true

        if currentQuery != query {
            currentQuery = query
            currentPage = 0
        }
        currentPage += 1
        Task {
            do {
                let result = try await api.searchRepos(endpoint: GithubEndpoint(query: currentQuery, page: currentPage))
                completion(result.items)
            } catch _ {
                print("fail")
            }
            isLoading = false
        }
    }

    // for combine
    func search(query: String) {
        guard !isLoading else { return }
        isLoading = true

        if currentQuery != query {
            currentQuery = query
            currentPage = 0
            repos.send([])
        }
        currentPage += 1

        Task { [weak self] in
            do {
                let result = try await self?.api.searchRepos(endpoint: GithubEndpoint(query: self?.currentQuery ?? "", page: self?.currentPage ?? 0))
                self?.repos.send(result?.items ?? [])
            } catch _ {
                print("fail")
            }
            self?.isLoading = false
        }
    }
}

struct GithubSearchResult<T: Codable>: Codable {
    let items: [T]
}

struct Repo: Codable, Identifiable, Equatable {
    let id: Int
    let name: String
    let description: String?
    let stargazers_count: Int
}

protocol Endpoint {
    associatedtype ResponseData: Decodable
    func urlRequest() throws -> URLRequest
    func result(data: Data) throws -> ResponseData
    var urlComponents: URLComponents { get }
}

struct GithubEndpoint: Endpoint {
    typealias ResponseData = GithubSearchResult<Repo>
    let query: String
    let pageSize = 20
    let page: Int
    let sort = "stars"

    var urlComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.github.com"
        components.path = "/search/repositories"
        components.queryItems = [.init(name: "q", value: query),
                                 .init(name: "sort", value: sort),
                                 .init(name: "per_page", value: "\(pageSize)"),
                                 .init(name: "page", value: "\(page)")]
        return components
    }

    func urlRequest() throws -> URLRequest {
        guard let url = urlComponents.url else {
            throw NSError(domain: "Request", code: 400)
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        return urlRequest
    }

    func result(data: Data) throws -> ResponseData {
        let decoder = JSONDecoder()
        return try decoder.decode(ResponseData.self, from: data)
    }
}

struct API {
    func searchRepos<T: Endpoint>(endpoint: T) async throws -> T.ResponseData {
        let request: URLRequest
        do {
            request = try endpoint.urlRequest()
        } catch let e {
            print(e)
            throw e
        }

        let data: Data
        do {
            let (d, _) = try await URLSession.shared
                .data(for: request)
            data = d
        } catch let e {
            print(e)
            throw e
        }
        let result: T.ResponseData
        do {
            result = try endpoint.result(data: data)

        } catch let e {
            print(e)
            throw e
        }

        return result
    }
}
