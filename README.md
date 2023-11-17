## GitHub Repository App
작업 툴 : Swift, Xcode, SnapKit, OpenAPI, RxSwift
#### 앱 소개
* GitHub의 Repository를 키워드로 검색
* Repository를 브라우저로 여는 기능을 구현
#### 실행 화면
![GitHubRepo](https://github.com/shimdy1013/GitHubRepository/assets/79740101/92ed8382-b640-4f3d-a077-1ab8f2a1625a)
####
```
        let repoResult = searchBar.shouldLoadResult
            .flatMapLatest { query in
                SearchRepositoryNetwork().searchRepository(query: query)
            }
            .share() 
        
        let repoValue = repoResult
            .compactMap { result -> SearchRepository? in
                guard case .success(let value) = result else {
                    return nil
                }
                return value
            }
        
        let cellData = repoValue
            .map { data -> [SearchRepositoryCellData] in
                return data.items
                    .map { item in
                        let avatarURL = URL(string: item.owner?.avatarURL ?? "")
                        return SearchRepositoryCellData(avatarURL: avatarURL, fullName: item.fullName, description: item.description, language: item.language, stargazersCount: item.stargazersCount, updatedAt: item.updatedAt)
                    }
            }
```
