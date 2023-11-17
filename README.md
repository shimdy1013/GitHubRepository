## GitHub Repository App
작업 툴 : Swift, Xcode, SnapKit, OpenAPI, RxSwift
#### 앱 소개
* GitHub의 Repository를 키워드로 검색
* Repository를 브라우저로 여는 기능을 구현
#### 실행 화면
![GitHubRepo](https://github.com/shimdy1013/GitHubRepository/assets/79740101/92ed8382-b640-4f3d-a077-1ab8f2a1625a)
#### 코드 : 네트워크 통신, 디코딩 메소드
```
func searchRepository(query: String) -> Single<Result<SearchRepository, SearchNetworkError>> {
        guard let url = api.searchBlog(query: query).url else {
            return .just(.failure(.invalidURL))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return session.rx.data(request: request as URLRequest)
            .asSingle()
            .map { data in
                do {
                    let repoData = try JSONDecoder().decode(SearchRepository.self, from: data)
                    return .success(repoData)
                } catch {
                    return .failure(.invalidJSON)
                }
            }
            .catch { _ in
                .just(.failure(.networkError))
            }
    }
```
