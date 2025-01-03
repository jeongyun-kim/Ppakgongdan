# 빡공단 - 스터디그룹을 위한 커뮤니티앱 

### ⭐️ 스크린샷

<table>
<tr line-height:0>
  <td><img src="" width="150" height="280"></td>
  <td><img src="" width="150" height="280"></td>
  <td><img src="" width="150" height="280"></td>
  <td><img src="" width="150" height="280"></td>
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
- 네트워크 구조의 일관성을 위한 Router Pattern 활용 및 Moya TargetType 활용
- 네트워크 통신 결과 데이터와 뷰에 보여지는 데이터 간의 의존성 분리를 위한 DTO 활용
- 코드의 가독성 및 스레드 폭발 방지를 위해 async/await을 통한 네트워크 코드 구성
- 단방향적 특징을 통한 상태관리의 편의성 및 유지보수성을 위해 TCA 활용
- 여러 화면간의 데이터 공유를 위해 TCA의 Shared 활용
- Reducer 분리 후 하나의 전체 Reducer로 관리하기 위해 Scope 활용

---

### 🚨 트러블슈팅

**✓ 제목**

**- 문제점**
<br>

**- 해결**
<br>

```swift

```

---


### 👏 회고

**- 제목**
<br>

<br>

