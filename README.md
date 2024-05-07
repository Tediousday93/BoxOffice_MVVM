# BoxOffice_MVVM

### ✧ 소개

영화진흥위원회 Open API, Daum 검색 API를 활용해 선택한 날짜의 일일 박스오피스 목록과 선택한 영화의 포스터 이미지 및 상세 정보를 확인할 수 있는 앱 </br>
(기존 BoxOffice의 리팩토링 프로젝트)

* 프로젝트 기간: 2024.02 ~ 2024.04 (약 2.5개월)

### 💻 개발환경

| 항목 | 사용기술 |
| :--------: | :--------: |
| Architecture | MVVM |
| UI | UIKit |
| Data Binding | Observer Pattern (Observable) |
| Network Layer | URLSession |
| ImageCache | NSCache, FileManager |

</br>

## 📝 목차
1. [타임라인](#-타임라인)
2. [프로젝트 구조](#-프로젝트-구조)
3. [실행화면](#-실행화면)
4. [트러블 슈팅](#-트러블-슈팅)
5. [고민했던 점](#-고민했던-점)
6. [참고 링크](#-참고-문서)

</br>

# 📆 타임라인

| <center>날짜</center> | <center>내용</center> |
| :--------: | -------- |
| 2024.02.13 ~ 2024.02.26 | NetworkLayer 구현 |
| 2024.02.27 ~ 2024.02.28 | OpenAPI Configuration, BoxOffice / ImageURLSearcher 구현 |
| 2024.03.01 ~ 2024.03.08 | ImageCache, CacheStorage 구현 |
| 2024.03.09 ~ 2024.03.11 | ImageProvider 구현 |
| 2024.03.11 ~ 2024.04.09 | NetworkLayer, Cache 리팩토링 및 Unit test 작성 |
| 2024.04.10 | ImageProvider 리팩토링 및 Unit test 작성 / Unit test 마무리 |
| 2024.04.11 | UI 구현 시작, Coordinator Pattern / Observer Pattern 적용 |
| 2024.04.11 ~ 2024.04.18 | DailyBoxOfficeView 구현 |
| 2024.04.18 ~ 2024.04.22 | MovieDetailsView, CalendarView 구현 |
| 2024.04.22 ~ 2024.04.23 | CollectionView Mode 변경 기능 구현 |


</br>

# 🪜 프로젝트 구조

## 💭 기존 프로젝트에서 해결하고 싶었던 문제

* Swift가 다중 패러다임 언어라는 장점을 잘 살리지 못했음(프로토콜 지향, 객체 지향적인 설계가 부족함)
* Model과 Contoroller의 분리가 명확하지 않고 Controller의 역할이 많음
    * ViewController에 Network 요청을 구성하는 로직이 있음
    * View에 전달할 데이터를 정제하는 로직이 포함되어 있음
* 특정 ViewController가 화면 전환을 위해 다른 ViewController와 의존 관계를 형성하고 있음
* 위 내용에 따라 ViewController 내부에 Model 객체 메서드를 호출하는 코드, View를 업데이트하는 코드 및 화면 전환 코드 등이 혼재되어 있어 가독성이 좋지 않음

</br>

## 💡 개선 사항

### Protocol을 적극적으로 활용해 프로토콜 지향, 객체 지향적으로 설계
* Protocol을 적극 활용함으로서 자연스럽게 객체지향의 SOLID 원칙을 더 잘 지킬 수 있게 되었음
* 특히 의존성 역전 원칙을 지키며 Testable한 코드를 작성할 수 있었음
* Core 기능들(Network, Cache)을 완전히 분리시킬 수 있었음

### ViewController 내부 코드의 가독성을 높이기 위해 MVVM 아키텍처와 Coordinator 패턴을 적용

* MVVM 아키텍처에서 ViewController는 View로 취급하므로 MVC에서 Controller로서 담당하던 역할을 ViewModel로 덜어낼 수 있었음(데이터 정제, View-Model 가교 역할)
* ViewController의 화면 전환 로직을 Coordinator로 분리, 이를 통해 ViewController가 다른 ViewController에 의존하는 코드가 제거됨
* 위 효과를 통해 ViewController에 View와 관련된 코드만 남게 되어 가독성이 증가되었음

</br>

## ✧ Data Binding

### Observable
서드 파티를 사용하지 않고 Data Binding을 진행하기 위해 프로퍼티 옵저버와 클로저를 활용해 `Observable` 타입을 정의
```swift
final class Observable<T> {
    private typealias Listener = (T) -> Void
    
    private var observers: [Listener]
    
    var value: T? {
        didSet {
            if value != nil { notifyObservers() }
        }
    }
    
    init(_ value: T? = nil) {
        self.value = value
        self.observers = []
    }
    
    func subscribe(listener: @escaping (T) -> Void) {
        observers.append(listener)
        if let value = value { listener(value) }
    }
    
    private func notifyObservers() {
        observers.forEach { listener in
            if let value = value { listener(value) }
        }
    }
}
```

</br>

## ✧ Network Layer
![BoxOffice_MVVM_NetworkLayer_UML](https://hackmd.io/_uploads/S1OxKuPZC.png)

* Network Layer는 외부에서 `APIConfigurationType` protocol을 채택한 타입을 통해 endpoint를 구성하고 `NetworkProvider`로 네트워크 요청을 보낼 수 있도록 설계

* `APIConfigurationType` 프로토콜 + 제네릭을 통한 값 타입 다형성 제공

* 모듈화 된 레이어는 아니지만 외부에서 사용할 타입은 `NetworkProvider`, `APIConfigurationType`, `NetworkSessionType`으로 한정

* `NetworkSessionType`은 `ImageProvider`와 같이 URL을 통한 네트워크 통신이 필요한 경우를 위해 외부에서 사용할 수 있도록 함

</br>

## ✧ Cache
![스크린샷 2024-04-25 오후 4.07.37](https://hackmd.io/_uploads/SJvFbFvZC.png)

### Cache Storage
* 다양한 타입을 저장할 수 있도록 Generic 타입으로 정의
* protocol을 통해 추상화하여 프로토콜을 타입으로 활용하는 경우, associatedtype으로 인해 boxed protocol type이 강제됨 -> ImageCache를 정의하기 위해선 associatedtype이 명확히 정해진 타입이 필요하므로 boxed protocol type을 활용할 수 없음
* Unit test에서 NSCache, FileManager가 실제로 잘 동작하는지 확인해볼 수 있기도 하다고 생각해 Storage 타입은 프로토콜을 따로 정의하지 않음

### 캐시 정책
* CacheExpiration 타입을 통해 설정 가능하도록 설계
* 메모리 캐싱 - 기본값 5분, 3분마다 타이머를 통해 만료된 캐시 제거, CacheObject 중첩 타입으로 만료 시간 관리
* 디스크 캐싱 - 기본값 7일, file attribute를 통한 만료 시간 관리
* 매우 많은 이미지를 다루지는 않기 때문에 cost 제한 설정x, count 제한만 설정

</br>

## ✧ Unit Test
* 비동기 코드를 테스트하기 위해 XCTestExpectation 활용

### Network
* 실제 네트워크 연결 여부에 관계 없이 빠른 테스트를 위해 test double 활용 (Mock URLProtocol)
* 별도로 정의한 APIConfigurationType 프로토콜을 채택한 타입과 NetworkProvider가 함께 동작하는 것을 테스트

### Cache
* DiskStorage에 저장할 타입의 제네릭 제약인 `DataConvertible` 프로토콜 테스트
* 각 Storage 타입의 제네릭 파라미터를 테스트하기 적절한 타입(Int, String)으로 설정하여 테스트 진행
* Mocking 없이 실제 `NSCache`와 `FileManager`를 통한 캐시 저장이 잘 이루어지는가를 테스트

### ImageProvider
* Cache / Loader 프로퍼티에 test double 활용 (MockImageCache, MockURLProtocol)

</br>

# 📱 실행화면

| 메인 화면 | 새로고침 | 날짜선택 |
| :--------: | :--------: | :---: |
| <img src="https://github.com/Tediousday93/BoxOffice_MVVM/blob/main/ScreenShot/BoxOfficeMVVM_main_screen.png?raw=true"> | <img src="https://github.com/Tediousday93/BoxOffice_MVVM/blob/main/ScreenShot/BoxOfficeMVVM_refreshControl.gif?raw=true"> | <img src="https://github.com/Tediousday93/BoxOffice_MVVM/blob/main/ScreenShot/BoxOfficeMVVM_selectDate.gif?raw=true"> |

| 화면 모드 변경 | 영화 상세 화면 | 이미지 캐싱 |
| :---: | :---: | :---: |
| <img src="https://github.com/Tediousday93/BoxOffice_MVVM/blob/main/ScreenShot/BoxOfficeMVVM_ChangeMode.gif?raw=true"> | <img src="https://github.com/Tediousday93/BoxOffice_MVVM/blob/main/ScreenShot/BoxOfficeMVVM_detail_screen.png?raw=true"> | <img src="https://github.com/Tediousday93/BoxOffice_MVVM/blob/main/ScreenShot/BoxOfficeMVVM_ImageCaching.gif?raw=true"> |


</br>

# 🚀 트러블 슈팅
## 1️⃣ Cache Storage 확장성
### 🔍 문제점
Unit Test를 진행하다 보니 캐시 만료기간이나 자동 삭제 관련된 코드가 전부 하드코딩되어 있어 테스트에서 짧은 시간을 직접 설정해줄 수 없었다.
추가로 DiskStorage의 경우, 외부에서 메서드를 호출할 때 저장할 타입을 Data 타입으로 변환해야만 했다.

```swift
final class InMemoryCacheStorage<T> {
    // implementation...
    
    func store(_ value: T, for key: String) {
        lock.lock()
        defer { lock.unlock() }
        
        let now = Date()
        let expiration = TimeInterval(60 * 5)
        let estimatedExpiration = now.addingTimeInterval(expiration)
        let cacheObject = CacheObject(value: value,
                                      expiration: estimatedExpiration)
        storage.setObject(cacheObject, forKey: key as NSString)
        keys.insert(key)
    }
}

final class OnDiskCacheStorage {
    // implementation...
    
    func store(value: Data, for key: String) throws {
        guard isStorageReady else {
            throw OnDiskCacheError.storageNotReady
        }
        
        if let limitExceedings = try exceedingCountLimitFileURLs() {
            try limitExceedings.forEach { fileURL in
                try removeValue(at: fileURL)
            }
        }
        
        let fileURL = directoryURL.appending(path: key)
        
        do {
            try value.write(to: fileURL)
        } catch {
            throw OnDiskCacheError.cannotCreateFile(url: fileURL, error: error)
        }
        
        let now = Date()
        let estimatedExpiration = TimeInterval(3600 * 24) * TimeInterval(7)
        let expirationDate = now.addingTimeInterval(estimatedExpiration)
        let attributes: [FileAttributeKey: Any] = [
            .creationDate: now as NSDate,
            .modificationDate: expirationDate as NSDate
        ]
        
        do {
            try fileManager.setAttributes(attributes, ofItemAtPath: fileURL.path)
        } catch {
            try? fileManager.removeItem(at: fileURL)
            throw OnDiskCacheError.cannotSetFileAttributes(
                filePath: fileURL.path,
                attributes: attributes,
                error: error
            )
        }
    }

}

```

* test case 작성 시, 빠른 테스트를 위해 만료기간을 짧게 설정할 수 있어야 함(추후 캐시 정책이 변경되어 만료기간을 재설정하기에도 좋음)
* 메모리 캐시와 디스크 캐시의 만료 기간 설정 방법에 차이가 있어 만료 기간을 설정하는 방법을 파라미터에 전달할 때 구분이 필요함
* DiskStorage가 Data 타입을 저장하는 것이 아니라 MemoryStorage처럼 다양한 타입을 저장할 수 있어야 함

</br>

### ⚒️ 해결방안
* `CacheExpiration`, `ExpirationExtending` 타입을 추가 정의하여 만료 기간 관련된 코드의 확장성, 가독성을 높임
* 새로 정의한 타입들을 각 Storage 객체의 이니셜라이저, 메서드 파라미터에 추가해 만료기간의 사용자 정의가 가능하도록 변경
* `DataConvertible` 프로토콜을 정의해 DiskStorage에 저장할 타입에 채택

결과로, 캐시 만료 기간을 사용자 정의할 수 있게 되었고 테스트 시 이전보다 짧은 기간을 설정할 수 있게 됨.
캐시를 활용하고 싶은 타입이 추가된다면 `DataConvertible` 프로토콜을 준수하게 하여 수월하게 추가 가능.

```swift
enum CacheExpiration: Equatable {
    case seconds(TimeInterval)
    
    case days(Int)
    
    func estimatedExpirationSince(_ date: Date) -> Date {
        switch self {
        case .seconds(let seconds):
            return date.addingTimeInterval(seconds)
        case .days(let days):
            let duration = TimeInterval(3600 * 24 * days)
            return date.addingTimeInterval(duration)
        }
    }
}

enum ExpirationExtending {
    case none
    
    case cacheTime
    
    case newExpiration(CacheExpiration)
}

protocol DataConvertible {
    func toData() throws -> Data
    
    static func fromData(_ data: Data) throws -> Self
    
    static var empty: Self { get }
}
```

▶︎ 개선 후

```swift
final class InMemoryCacheStorage<T> {
    convenience init(
        countLimit: Int,
        cacheExpiration: CacheExpiration = .seconds(300),
        cleanInterval: TimeInterval = 180
    ) {
        self.init(storage: .init(),
                  cacheExpiration: cacheExpiration,
                  cleanInterval: cleanInterval)
        storage.countLimit = countLimit
    }
    
    func store(_ value: T, for key: String, expiration: CacheExpiration? = nil {
        lock.lock()
        defer { lock.unlock() }
        
        let expiration = expiration ?? cacheExpiration
        let cacheObject = CacheObject(value: value,
                                      expiration: expiration)
        storage.setObject(cacheObject, forKey: key as NSString)
        keys.insert(key)
    }
}

final class OnDiskCacheStorage<T: DataConvertible> {
    convenience init(
        countLimit: Int,
        cacheExpiration: CacheExpiration = .days(7)
    ) throws {
        self.init(fileManager: .default,
                  countLimit: countLimit,
                  cacheExpiration: cacheExpiration,
                  creatingDirectory: false)
        
        try prepareDirectory()
    }
    
    func store(value: T, for key: String, expiration: CacheExpiration? = nil) throws {
        guard isStorageReady else {
            throw OnDiskCacheError.storageNotReady
        }
        
        if let limitExceedings = try exceedingCountLimitFileURLs() {
            try limitExceedings.forEach { fileURL in
                try removeData(at: fileURL)
            }
        }
        
        let fileURL = directoryURL.appending(path: key)
        let data = try value.toData()
        
        do {
            try data.write(to: fileURL)
        } catch {
            throw OnDiskCacheError.cannotCreateFile(url: fileURL, error: error)
        }
        
        let expiration = expiration ?? cacheExpiration
        let now = Date.now
        let estimatedExpiration = expiration.estimatedExpirationSince(now)
        let attributes: [FileAttributeKey: Any] = [
            .creationDate: now,
            .modificationDate: estimatedExpiration
        ]
        
        do {
            try fileManager.setAttributes(attributes, ofItemAtPath: fileURL.path())
        } catch {
            try? fileManager.removeItem(at: fileURL)
            throw OnDiskCacheError.cannotSetFileAttributes(
                filePath: fileURL.path,
                attributes: attributes,
                error: error
            )
        }
    }    
}
```

</br>
    
## 2️⃣ Network Layer - APIConfigurationType
### 🔍 문제점
`APIConfigurationType` 프로토콜에 associatedtype으로 JSONData를 디코딩할 타입을 알려주고 있다.

이 때, enum에 프로토콜을 채택해 baseURL이 같은 endpoint를 함께 관리하고 싶었으나 associatedtype을 특정하게 되면 설정된 타입과 매칭되지 않는 Response가 필요한 요청을 보냈을 때 오류가 발생하게 된다.

```swift
enum KobisAPI<Response: Decodable>: APIConfigurationType {
    case dailyBoxOffice(responseType: Response.Type, targetDate: String)
    case movieDetail(responseType: Response.Type, movieCode: String)
    // 제네릭에는 하나의 Response 타입만을 정해줄 수 있음
    // Response - DailyBoxOffice로 정해버리면 movieDetail 요청은 Decoding에 실패함
}
```

디코딩 타입을 강제하는 만큼 이러한 문제가 발생하는 것은 사용할 때 편의성에 좋지 않다고 생각했다.

### ⚒️ 해결방안
enum을 사용하지 않고 요청에 맞는 APIConfiguration을 struct로 각각 정의하기로 결정했다.

enum을 통해 baseURL이 같고 path가 다른 API를 case로 관리하는 것이 유용할 것 같다. 추후 Moya를 참고해보고 좋은 방법을 찾아보도록 하자.

</br>

## 3️⃣ Coordinator 메모리 누수
### 🔍 문제점
화면전환 로직을 전부 `Coordinator`에게 맡겨두었다.
`Coordinator`에는 parent - child 관계가 있고, child에 대한 참조를 parent에서 배열로 갖는다. 이 때, 새로운 화면을 띄운 다음 해당 화면을 `pop`/`dismiss` 하게 되면 Coordinator의 `deinit`이 호출되지 않았고, 인스턴스가 메모리에 그대로 남아있는 것을 확인했다.

### ⚒️ 해결방안
메모리 누수가 발생하는 `Coordinator`에 `finish()` 라는 메서드를 정의해 parent가 가지고 있는 참조를 제거할 수 있도록 했다.
```swift
final class MovieDetailsCoordinator: Coordinator {
    func finish() {
        parent?.removeFinishedChild(self)
    }
}
```

Coordinator의 역할은 자신이 관리하는 ViewController가 할당 해제되면 끝나는 것이기 때문에 ViewController의 deinit에서 coordinator의 finish를 호출하여 메모리 누수를 해결했다.
```swift
final class MovieDetailsViewController: UIViewController {    
    deinit {
        coordinator?.finish()
    }
}
```

</br>


# 💭 고민했던 점

## ✧ 성능 최적화

### static dispatch
상속 기능이 있는 class의 경우, 상속을 통한 overriding이 가능할 때 프로퍼티, 메서드 dispatch에 static dispatch 보다 성능상 손해가 있는 dynamic dispatch를 이용한다. 이를 최적화하기 위해 상속을 활용하지 않는 class에 대해 `final` 키워드, `private` 접근제어를 적극적으로 활용했다.

### AlertBuilder - struct vs class
`AlertBuilder` 를 정의할 때 struct와 class 중 어떤 것을 선택할지 고민했다.
AlertController를 선언적으로 설정하고 화면에 보여주기 위해 AlertBuilder에는 2개의 프로퍼티가 필요하다. 이를 Struct로 정의하면 아래와 같다.

```swift
struct AlertBuilder {
    private let alertController: UIAlertController
    
    private let presentingViewController: UIViewController
    
    init(
        alertStyle: UIAlertController.Style,
        presentingViewController: UIViewController
    ) {
        self.alertController = .init(title: nil, message: nil, preferredStyle: alertStyle)
        self.presentingViewController = presentingViewController
    }
}
```

Builder 패턴의 특성상 메서드에서 자기 자신을 반환해야 한다.
`Self`를 반환하면 AlertBuilder가 struct이므로 메모리 영역 중 stack 영역에 인스턴스가 할당된다. 이 때, Builder의 프로퍼티는 모두 class이기 때문에 heap 영역에 인스턴스가 할당된 상태이며 Builder의 인스턴스가 메모리에 할당될 때마다 참조 overhead가 발생하게 된다.

<img src="https://github.com/Tediousday93/BoxOffice_MVVM/blob/main/ScreenShot/AlertBuilder%EB%A9%94%EB%AA%A8%EB%A6%AC.001.jpeg?raw=true" width="550">

이러한 overhead를 줄이기 위해 Builder를 class로 정의하고 인스턴스를 하나로 유지하며 Self 반환 시 참조를 반환하도록 했다.

```swift
final class AlertBuilder {
    private let alertController: UIAlertController
    
    private let presentingViewController: UIViewController
    
    init(
        alertStyle: UIAlertController.Style,
        presentingViewController: UIViewController
    ) {
        self.alertController = .init(title: nil, message: nil, preferredStyle: alertStyle)
        self.presentingViewController = presentingViewController
    }
    
    func setTitle(_ title: String ) -> Self {
        alertController.title = title
        return self
    }
    
    // implementations...
}
```

</br>

## ✧ 중복 코드 줄이기
`OnDiskCacheStorage`는 `FileManager`를 활용해 샌드박스 내부 Caches 폴더에 캐시할 데이터를 저장한다.
캐시 만료기간은 생성된 파일의 `attributes`를 통해 관리하고 있다. 이를 활용하기 위해서는 URL 인스턴스에서 제공하는 메서드 `resourceValues(forKeys:)`를 이용해야 했다.
이에 따라 `OnDiskCacheStorage` 인스턴스 메서드 곳곳에 해당 메서드의 호출이 중복되었다.
중복된 코드로 인해 코드가 길어지고 Storage 설정 및 CRUD 외의 다른 기능이 늘어나 코드의 가독성이 떨어졌다.

이를 해결하기 위해 `FileMeta`라는 중첩 타입을 정의해 반복되는 코드를 줄이고 가독성을 높여주는 방향으로 리팩토링했다.
결과, `OnDiskCacheStorage`에서 만료 기간 설정 및 확인 기능이 `FileMeta`로 분리되고 메서드 내부 코드 가독성이 좋아졌다.

▶︎ FileMeta Nested Type
```swift
extension OnDiskCacheStorage {
    struct FileMeta {
        let url: URL
        let lastAccessDate: Date?
        let estimatedExpirationDate: Date?
        
        init(at url: URL, resourceKeys: Set<URLResourceKey>) throws {
            let resourceValues: URLResourceValues
            
            do {
                resourceValues = try url.resourceValues(forKeys: resourceKeys)
            } catch {
                throw OnDiskCacheError.invalidURLResource(
                    keys: resourceKeys, url: url, error: error
                )
            }
            
            self.init(
                url: url,
                lastAccessDate: resourceValues.creationDate,
                estimatedExpirationDate: resourceValues.contentModificationDate
            )
        }
        
        init(
            url: URL,
            lastAccessDate: Date?,
            estimatedExpirationDate: Date?
        ) {
            self.url = url
            self.lastAccessDate = lastAccessDate
            self.estimatedExpirationDate = estimatedExpirationDate
        }
        
        var isExpired: Bool {
            estimatedExpirationDate?.isPast(referenceDate: .now) ?? true
        }
        
        func extendExpiration(
            with fileManager: FileManager,
            extendingExpiration: ExpirationExtending
        ) {
            guard let lastAccessDate, let estimatedExpirationDate else {
                return
            }
            
            let accessDate = Date.now
            let expirationDate: Date
            
            switch extendingExpiration {
            case .cacheTime:
                let origianlExpiration: CacheExpiration = .seconds(
                    estimatedExpirationDate.timeIntervalSince(lastAccessDate)
                )
                expirationDate = origianlExpiration.estimatedExpirationSince(accessDate)
            case let .newExpiration(expiration):
                expirationDate = expiration.estimatedExpirationSince(accessDate)
            case .none:
                return
            }
            
            let attributes: [FileAttributeKey: Any] = [
                .creationDate: accessDate as NSDate,
                .modificationDate: expirationDate as NSDate
            ]
            
            try? fileManager.setAttributes(attributes, ofItemAtPath: url.path())
        }
    }
}
```

</br>

## ✧ Observable 복수 구독하기
처음 만들었던 Observable 타입은 Observer가 정의되어있지 않아 하나의 구독만 유지할 수 있었다.
```swift
final class Observable<T> {
    var value: T {
        didSet { self.listener?(value) }
    }
    
    private var listener: ((T) -> Void)?
    
    init(_ value: T) {
        self.value = value
    }
    
    func subscribe(listener: @escaping (T) -> Void) {
        listener(value)
        self.listener = listener
    }
}
```

하지만 DailyBoxOfficeViewModel의 currentDate에서 구독이 2회 필요하게 되었다.
1. currentDate 설정 시 navigation bar의 title을 업데이트
2. currentDate 설정 시 fetchDailyBoxOffice 메서드 호출

복수 구독이 가능하도록 Observable을 수정했다.
```swift
final class Observable<T> {
    private typealias Listener = (T) -> Void
    
    private var observers: [Listener]
    
    var value: T? {
        didSet {
            if value != nil { notifyObservers() }
        }
    }
    
    init(_ value: T? = nil) {
        self.value = value
        self.observers = []
    }
    
    func subscribe(listener: @escaping (T) -> Void) {
        observers.append(listener)
        if let value = value { listener(value) }
    }
    
    private func notifyObservers() {
        observers.forEach { listener in
            if let value = value { listener(value) }
        }
    }
}
```

</br>

## ✧ Unit test - Singleton 참조를 갖는 인스턴스의 setUp, tearDown
### 🔍 문제점
`OnDiskCacheStorage` 테스트 코드 작성 중 `setUp`, `tearDown`을 override 할 때 의문이 생겼다.
`FileManager.default` 싱글톤 인스턴스를 참조하는 프로퍼티를 갖는 `OnDiskCacheStorage`는 이니셜라이저에서 fileManager에 대한 의존성을 주입받는다.
따라서 테스트를 위해 innerStorage에 FileManager.default에 대한 참조를 할당하고 tearDown에서 nil을 할당하려고 했다.
```swift
class OnDiskCacheStorageTest: XCTestCase {
    var innerStorage: FileManager!
    var diskStorage: OnDiskCacheStorage<String>!
    
    override func setUpWithError() throws {
        innerStorage = .default
        diskStorage = .init(fileManager: innerStorage)
        try diskStorage.prepareDirectory()
        try diskStorage.removeExpired()
    }
    
    override func tearDownWithError() throws {
        try diskStorage.removeAll()
        diskStorage = nil
        innerStorage = nil
    }
}
```

이 때, 뭔가 어색함을 느꼈다. `FileManager.default`는 `FileManager`의 타입 프로퍼티 싱글톤 인스턴스로 lazy하게 생성되며 런타임에 생성 이후 할당이 해제되지 않는다. 따라서, tearDwon에서 innerStorage에 nil을 할당한다 해도 인스턴스가 해제되지 않을 것이다.

그렇다면 innerStorage를 tearDown해야할 필요가 있을까 라는 고민이 생겼다.

### ⚒️ 해결방안
diskStorage를 초기화하면 이니셜라이저 파라미터의 기본값으로 설정된 FileManager.default에 접근하여 1회 생성되므로 테스트가 끝나기 전까지는 default 인스턴스가 유지될 것이라고 생각했다. 왜냐하면 타입 프로퍼티로 생성된 싱글톤 인스턴스의 경우 프로그램이 종료되기 전까지는 메모리에서 해제할 방법이 없기 때문이다.

따라서 setUp, tearDown에서 참조 변수에 nil을 할당할 필요가 없다고 생각해 조금 더 간단히 작성할 수 있도록 수정했다.

innerStorage는 모든 테스트에 공통적으로 필요한 조건으로 생각해 XCTestCase의 타입 메서드인 setUp과 tearDown을 활용해볼 수도 있지만 어차피 tearDown에서 할당 해제할 수 없으므로 한 번 생성해주기만 하기로 결정했다.

```swift
class OnDiskCacheStorageTest: XCTestCase {
    let innerStorage = FileManager.default
    var diskStorage: OnDiskCacheStorage<String>!
    
    override func setUpWithError() throws {
        diskStorage = try .init(countLimit: 3, cacheExpiration: .seconds(5))
    }
    
    override func tearDownWithError() throws {
        try diskStorage.removeAll()
        diskStorage = nil
    }
}

```


</br>

---

# 📚 참고 문서
* [Apple Developer Documentation - URLProtocol](https://developer.apple.com/documentation/foundation/urlprotocol)
* [Apple Developer Documentation - DateComponents](https://developer.apple.com/documentation/foundation/datecomponents)
* [Apple Developer Documentation - Set Up and Tear Down State in Your Tests](https://developer.apple.com/documentation/xctest/xctestcase/set_up_and_tear_down_state_in_your_tests)
* [Notion - Coordinator Pattern 정리](https://heavy-rosehip-0fb.notion.site/Coordinator-Pattern-c002934b2c3d4635a033acdbeeb291e7)
* [KingFisher Github Library](https://github.com/onevcat/Kingfisher)
* [Mocking requests using URLProtocol](https://www.theinkedengineer.com/articles/mocking-requests-using-url-protocol)
* [서버없이 Networking Test 하기 with URLProtocol - 포프리](https://seob-p.tistory.com/18)
* [Testing network calls using URLProtocol - Artur Gruchata](https://arturgruchala.com/testing-network-calls-using/)
* [RxSwift - Observable](https://reactivex.io/documentation/observable.html)
* [RIP Tutorial - MVVM Without Reactive Programming](https://riptutorial.com/ios/example/27354/mvvm-without-reactive-programming)
* [stevencurtis(GitHub) Swift Coding - Two Way Binding](https://github.com/stevencurtis/SwiftCoding/tree/master/TwoWayBinding)
