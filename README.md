# 빡공단 - 스터디그룹을 위한 커뮤니티앱 

### ⭐️ 스크린샷

<table>
  <tr>
    <td>로그인</td>
    <td>스터디그룹 홈</td>
    <td>스터디그룹 목록</td>
    <td>채팅</td>
    <td>DM</td>
  </tr>
<tr line-height:0>
  <td><img src="https://github.com/user-attachments/assets/464c24b3-1ffb-4b24-8ccb-af9b212e32be" width="140" height="280"></td>
  <td><img src="https://github.com/user-attachments/assets/9c4e6417-c6c7-4fd8-8327-acdd0e6a73ff" width="140" height="280"></td>
  <td><img src="https://github.com/user-attachments/assets/edd6ba2f-8920-42fb-819d-64ae9a5e3851" width="140" height="280"></td>
  <td><img src="https://github.com/user-attachments/assets/a51f01de-2583-4b5b-a3b1-a6abf7c6d788" width="140" height="280"></td>
  <td><img src="https://github.com/user-attachments/assets/3c9a215a-5781-41c0-91c9-011977ae4dd7" width="140" height="280"></td>  
</tr>
</table>

---

### ✅ 개발환경

- iOS17+
- 1인 개발 | 2024.11.10 ~ 12.10

---

### 👩🏼‍💻 주요 기술

- UI : ```SwiftUI```, ```Kingfisher```
- Database : ```Realm```
- Network : ```Moya```, ```Alamofire```
- Architecture : ```TCA```, ```Modular Architecture```
- Design Pattern : ```Repository Pattern```, ```Router Pattern```, ```DTO```
- etc : ```Tuist```, ```SocketIO```, ```KakaoSDK```, ```Swift Concurrency```, ```Combine```, ```GCD```
- managing : ```Confluence```, ```Swagger```, ```Figma``` 

---

### 📚 주요 기능

- 스터디그룹 조회 및 관리
- 스터디그룹 및 1:1 채팅
- 카카오/애플 로그인

---

### 🧐 개발 포인트

- 각 기능별 간의 의존성 분리를 위한 모듈화를 위해 ```Tuist``` 활용
- 의존성 최소화를 위한 ```DTO``` 활용
- 코드의 가독성 및 스레드 폭발 방지를 위해 ```async/await```을 통한 네트워크 코드 구성
- 상태관리의 편의성 및 유지보수성 향상을 위한 ```TCA``` 활용
- 실시간 채팅 전송 및 조회를 위해 ```SocketIO``` 활용
- 네트워크 구조의 일관성을 위한 ```Router Pattern``` 활용 및 ```Moya TargetType``` 활용
- DB의 데이터 관리의 유지보수성 향상을 위한 ```Repository Pattern 활용```
- 여러 화면간의 데이터 공유를 위해 TCA의 ```Shared``` 활용
- Reducer 분리 후 하나의 전체 Reducer로 관리하기 위해 ```Scope``` 활용

---

### 🚨 트러블슈팅

**✓ Tuist를 활용한 모듈화**
<br>
<img src="https://github.com/user-attachments/assets/80c3f51b-95f3-4052-a6c9-3c426ccdaf09" width="640" height="480">
<br>

```Tuist를 이용하여 각 기능별 관심사를 분리```하는 모듈화 작업을 수행하였습니다. <br>

**모듈화를 통해 느낀 5가지 이점**
- 각 모듈이 하나의 책임만을 가진 독립성 확보, 이를통한 코드 수정 시 관련 모듈만의 수정을 통한 유지보수성 향상
- 모듈별 독립적인 Target을 생성, 수정 시 수정된 모듈만 재빌드되어 빌드 시간 감소
- 단위 테스트(Unit Test) 진행 시, 발생하는 문제가 다른 모듈까지 영향을 미치지않고 테스트 범위를 명확히 해줄 수 있다는 테스트 용이성
- Utils를 통한 외부 라이브러리 관리로 프로젝트 자체와 라이브러리 간 결합도 감소를 통한 유지보수성 향상
- 새로운 기능 추가 시, ```Feature_기능```과 같이 새로운 모듈을 통해 쉬운 프로젝트 확장

**모듈화 고려사항**
- 모듈 간 영향 최소화
- 확장성 고려 

> **고민 지점(1) : NetworkKit과 Utils의 분리** <br>
이러한 설계 시, 가장 고민되는 지점은 NetworkKit과 Utils의 완전 분리였습니다.
Feature -> NetworkKit -> Utils의 방향을 Feature -> NetworkKit / Utils의 방향으로 구분지어 NetworkKit은 오로지 네트워크와 관련된 역할을 하도록 Moya와 Alamofire를 해당 모듈로의 분리를 고민했습니다. <br>
하지만 중앙집중적 관리 차원에서 Utils가 모든 라이브러리를 관리하도록 설계하였습니다. 

> **고민 지점(2) : Tuist의 Realm(Dynamic Library)를 찾지 못하는 문제** <br>
적용 중 발생했던 가장 큰 문제는 Realm을 Tuist로 적용해주었을 때, dynamic 형식으로만 불러오면서 앱을 실행하였을 때 라이브러리를 찾아오지못한다는 문제였습니다.
이는 Realm 10.49.3버전부터 Realm이 라이브러리를 dynamic 형태로만 제공하여 발생하는 문제로 Runpath Search Paths 같은 세부사항들을 수정해주었음에도 런타임 에러가 계속되었습니다. <br>
이러한 과정속에서 Tuist는 빌드 속도 최적화, 런타임 의존성 제거 등을 위해 기본적으로 정적 라이브러리를 선호한다는 사실을 알게되었고 Realm이 해당 버전부터 라이브러리를 동적으로만 제공하여 생기는 문제라고 판단하였습니다. <br>
결국 이를 해결하고자 Realm을 10.49.2으로 다운그레이드하여 적용해주었습니다. 

<br>

**✓ TCA를 활용한 상태 관리**
<br>
<table>
  <td><img src="https://github.com/user-attachments/assets/d4e03f88-f674-472d-aa7d-92189c07f7ca"></td>
  <td><img src="https://github.com/user-attachments/assets/fac2e927-837c-41e6-bc6d-6d83b38610d5"></td>
</table>
<br>
 
이전에는 ```SwiftUI```서도 ```MVVM```을 적용했습니다. 
<br>

하지만 저는 실제로 구현을 하면서 ```SwiftUI```가 기본적으로 제공하는 ```Data Binding```에 비해 ```SwiftUI + MVVM```구조는 되려 복잡도를 증가시킨다고 생각하였습니다.
그리하여 이번 프로젝트에서는 ```단방향 상태관리가 가능한 아키텍쳐인 TCA```를 사용해주었습니다.
이 때, 하나의 최상단 Store에서 Scope를 통해 하위 Reducer들과 연결해주면서 결국은 ```Feature Store```에서 모든 상태 관리가 가능한 중앙집중화 된 구조를 구축하였습니다.

**TCA를 통해 느낀 3가지 이점**
- 각 뷰마다 하나의 Reducer를 통한 상태관리가 이루어지지만 Scope를 통해 결국 하나의 Store로 이어지는 중앙집중적인 상태 관리
- effect를 통해 순차적인 이벤트 처리가 가능해 상태 변화의 흐름을 직관적으로 파악 가능 
- 각 기능 단위로 Reducer와 View의 분리를 통해 코드의 모듈화와 재사용성 향상

> **고민 지점 : 상위/하위뷰 간 Shared를 이용한 상태 공유** <br>
상위뷰와 하위뷰 모두에서 사용되는 데이터가 있을 때, 어느 한 곳에서 변화가 일어나면 다른 뷰에서도 해당 변화를 감지할 수 있도록 해주고 싶었습니다. <br>
이 때, Scope의 Action을 이용하는 방법도 있을 수 있지만 이는 결국 중복되는 코드가 발생할 수 있고 재사용성도 부족하다고 생각하였습니다. 그리하여 최근 추가된 Shared 프로퍼티를 이용해 하나의 상태를 각 Reducer가 공유함으로써 상위, 하위뷰 가릴 것 없이 일관되게 상태 변화를 감지해줄 수 있었고 이를 통해 중복 코드 제거 및 유지보수성을 향상시킬 수 있었습니다. 

<br>

**✓ SocketIO를 통한 실시간 채팅 구현**
<img src="https://github.com/user-attachments/assets/33e44684-fe83-4714-a272-b97bb4c9e8d4" width="80%"/>
<br>

**실시간 채팅 반영 과정**
1. 채팅뷰가 보여지는 경우, Realm 내 해당 채팅ID로 저장된 채팅방 데이터가 이는지 확인 <br>
2. 있다면 마지막 조회날짜이후로 서버 내 채팅내역 가져오기 -> 4 <br>
3. 없다면 해당 채팅방이 만들어진 날짜를 기준으로 모든 채팅내역 가져오기 -> 4 <br>
4. 뷰에 가져온 채팅내역 반영 후, Socket 연결 <br>
5. SocketService 내 chatPublisher를 통해 새로운 채팅이 생길 때마다, 새로운 채팅 뷰에 추가  <br>
6. 뷰가 화면에서 사라질 때, Socket 연결 해제 <br>

> **고민 지점 : 실시간으로 받아오는 채팅을 뷰에 반영해주기** <br>
SocketIO를 통해 통신이 구축되었을 때, 매번 실시간으로 이뤄지는 채팅을 받아오기 위해 Combine의 Subject를 이용해주었습니다. 이 때, 소켓통신이 DM, Channel 두곳에서 이뤄지기에 두 개의 Publisher를 구성할까 고민하였으나 중복코드를 제거하기 위해 any Equtable을 통해 반환되는 데이터값이 Equatable을 채택하고 있음을 binding과정에서도 중복되는 코드를 줄이려 노력하였습니다.
```swift
// 실시간 채널을 받아 내보내는 Publisher
public let chatPublisher = CurrentValueSubject<(any Equatable)?, Never>(nil)

// binding
public func bindChat(completionHandler: @escaping (any Equatable) -> Void) {
    chatPublisher
        .receive(on: DispatchQueue.main)
        .compactMap { $0 }
        .sink { value in
            completionHandler(value)
        }
        .store(in: &subscriptions)
}

// 소켓 연결 및 실시간 채팅 받아오기 
.onAppear {
  store.send(.connectSocket)

  SocketService.shared.bindChat { value in
    // any Equatable을 통한 타입 캐스팅 필요 
     guard let chat = value as? ChannelChatting else { return }
     store.send(.appendChat(chat))
  }
}
```
> 해당 코드에서의 문제점은 타입 캐스팅이라고 생각합니다. 날아오는 데이터가 Equatable을 채택하고 있기는하지만 해당 값이 어떠한 데이터 타입을 가지고 있는지 확인해주어야한다는 점에서 휴먼 에러가 발생할 수도 있는 여지가 있다고 생각합니다. 또한, 이처럼 작은 단위가 아닌 큰 단위의 프로젝트를 구성하게 되면 런타임 에러 등 다양한 문제가 발생할 여지가 있다고 생각합니다. 그렇기 때문에 추후에는 너무 중복되는 코드에 대해서만 생각하지말고 다른 관점으로도 생각하여 Generic 등을 활용해볼 수 있을 것 같습니다.  

---


### 👏 회고

**- 단순한 모듈화의 아쉬움**
<br>
이번 프로젝트에서는 Tuist에 대한 이해와 적용을 바탕으로 하여 단순하게 기능 또는 화면을 기준으로 하여 모듈화를 진행해보았습니다.
하지만 이러한 경우, 공통 모듈(NetworkKit, Utils)가 너무 비대해질 수 있고 추후에 수정이 빈번히 일어나게 된다면 다른 모듈들에서도 영향을 모두 받을 수 있다는 문제가 있습니다.
그리하여 이후 프로젝트에는 Test까지 추가하여 모듈 간 의존성을 최소화 한 MicroFeature 형태의 모듈화를 진행해보고 싶습니다.

<br>

