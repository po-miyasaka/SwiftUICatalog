//
//  GithubRepository.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/23.
//

import Combine
import Foundation
@MainActor
public class Repository: ObservableObject {
    public init() {
        
    }
    @Published  public var isLoading = false

    // for combine
    public var reposPublisher: AnyPublisher<[Repo], Never> { repos.eraseToAnyPublisher() }
    // for combine
    public var repos: CurrentValueSubject<[Repo], Never> = .init([])

    var currentQuery = ""
    var currentPage = 1

    var api: API = .init()
    var continuation: AsyncStream<[Repo]>.Continuation?
    public  lazy var stream = AsyncStream<[Repo]> { continuation in
        self.continuation = continuation
    }

    deinit {
        continuation?.finish()
    }

    // for async await
    public func search(query: String) async {
        if currentQuery != query {
            currentQuery = query
            currentPage = 0
        }
        await next()
    }

    // for async await
    public func next() async {
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
    public func search(query: String, completion: @escaping ([Repo]) -> Void) {
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
    public func search(query: String) {
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

public struct GithubSearchResult<T: Codable & Sendable>: Codable {
    public let items: [T]
    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<GithubSearchResult<T>.CodingKeys> = try decoder.container(keyedBy: GithubSearchResult<T>.CodingKeys.self)
        self.items = try container.decode([T].self, forKey: GithubSearchResult<T>.CodingKeys.items)
    }
    public init(items: [T]) {
        self.items = items
    }
}

public struct Repo: Codable, Identifiable, Equatable {
    public let id: Int
    public let name: String
    public let description: String?
    public let stargazers_count: Int
    public init(id: Int, name: String, description: String?, stargazers_count: Int) {
        self.id = id
        self.name = name
        self.description = description
        self.stargazers_count = stargazers_count
    }
}

public protocol Endpoint {
    associatedtype ResponseData: Decodable
    func urlRequest() throws -> URLRequest
    func result(data: Data) throws -> ResponseData
    var urlComponents: URLComponents { get }
}

public struct GithubEndpoint: Endpoint {
    public typealias ResponseData = GithubSearchResult<Repo>
    public let query: String
    public let pageSize = 20
    public let page: Int
    public let sort = "stars"

    public init(query: String, page: Int) {
        self.query = query
        self.page = page
    }
    
    public var urlComponents: URLComponents {
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

    public func urlRequest() throws -> URLRequest {
        guard let url = urlComponents.url else {
            throw NSError(domain: "Request", code: 400)
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        return urlRequest
    }

    public func result(data: Data) throws -> ResponseData {
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
