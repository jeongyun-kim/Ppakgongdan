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

- UI : SwiftUI, Kingfisher
- Database : Realm
- Network : Moya, Alamofire
- Design Pattern: TCA, Repository Pattern, DTO
- etc: Tuist, SocketIO, KakaoSDK, Swift Concurrency, Combine, GCD

---

### 📚 주요 기능

- 스터디그룹 조회 및 관리
- 스터디그룹 및 1:1 채팅
- 카카오/애플 로그인

---

### 🧐 개발 포인트

- 각 기능별 간의 의존성 분리를 위한 모듈화를 위해 Tuist 활용
- 실시간 채팅 전송 및 조회를 위해 SocketIO 활용
- 의존성 최소화를 위한 DTO 활용
- 코드의 가독성 및 스레드 폭발 방지를 위해 async/await을 통한 네트워크 코드 구성
- 상태관리의 편의성 및 유지보수성 향상을 위한 TCA 활용
- 네트워크 구조의 일관성을 위한 Router Pattern 활용 및 Moya TargetType 활용
- DB의 데이터 관리의 유지보수성 향상을 위한 Repository Pattern 활용
- 여러 화면간의 데이터 공유를 위해 TCA의 Shared 활용
- Reducer 분리 후 하나의 전체 Reducer로 관리하기 위해 Scope 활용

---

### 🚨 트러블슈팅

**✓ Tuist를 활용한 모듈화**
<br>
<img src="https://github.com/user-attachments/assets/80c3f51b-95f3-4052-a6c9-3c426ccdaf09" width="640" height="480">
<br>

이번 프로젝트에서 처음으로 Tuist를 이용하여 각 기능별 관심사를 분리하는 모듈화 작업을 수행하였습니다. <br>
이러한 모듈화 작업을 통해 얻을 수 있는 이점은 총 5가지였습니다.
- 각 모듈이 하나의 책임만을 가진 독립성 확보, 이를통한 코드 수정 시 관련 모듈만의 수정을 통한 유지보수성 향상
- 모듈별 독립적인 Target을 생성, 수정 시 수정된 모듈만 재빌드되어 빌드 시간 감소
- 단위 테스트(Unit Test) 진행 시, 발생하는 문제가 다른 모듈까지 영향을 미치지않고 테스트 범위를 명확히 해줄 수 있다는 테스트 용이성
- Utils를 통한 외부 라이브러리 관리로 프로젝트 자체와 라이브러리 간 결합도 감소를 통한 유지보수성 향상
- 새로운 기능 추가 시, 'Feature_기능'과 같이 새로운 모듈을 통해 쉬운 프로젝트 확장 

이러한 설계 시, 가장 고민되는 지점은 NetworkKit과 Utils의 완전 분리였습니다.
Feature -> NetworkKit -> Utils의 방향을 Feature -> NetworkKit / Utils의 방향으로 구분지어 NetworkKit은 오로지 네트워크와 관련된 역할을 하도록 Moya와 Alamofire를 해당 모듈로의 분리를 고민했습니다.
하지만 중앙집중 관리적 차원에서 Utils가 모든 라이브러리를 관리하도록 설계하였습니다. 

또한 적용 중 발생했던 가장 큰 문제는 Realm을 Tuist로 적용해주었을 때, dynamic 형식으로만 불러오면서 앱을 실행하였을 때 라이브러리를 찾아오지못한다는 문제였습니다.
이는 Realm 10.49.3버전부터 Realm이 라이브러리를 dynamic 형태로만 제공하여 발생하는 문제로 Runpath Search Paths 같은 세부사항들을 수정해주었음에도 런타임 에러가 계속되었습니다.
이러한 과정속에서 Tuist는 빌드 속도 최적화, 런타임 의존성 제거 등을 위해 기본적으로 정적 라이브러리를 선호하한다는 사실을 알게되었고 Realm이 해당 버전부터 라이브러리를 동적으로만 제공하여 생기는 문제라고 판단하였습니다.
결국 이를 해결하고자 Realm을 10.49.2으로 다운그레이드해주어야 했습니다. 

---


### 👏 회고

**- 제목**
<br>

<br>

