# GithubSearchApp

GitHub 유저 검색 API를 활용한 iOS 어플리케이션.

## Description
- 최소 타겟 : iOS 13.0
- Portrait 모드만 지원
- MVVM - Input/Output 패턴 적용
- Storyboard를 활용하지 않고 코드로만 UI 구성
- SwiftLint 적용으로 코드 컨벤션 확립
- 라이트 모드/다크 모드 대응
- Pagination 구현
- [개발 공수](https://maze-mozzarella-6e5.notion.site/6ba9d82a6950406092d5785e30ac2da3)

## Feature
* API 뷰
  + 유저 실시간 검색 기능
  + 즐겨찾기 추가/제거
  + 페이지네이션
  + 액티비티 인디케이터
* Local 뷰
  + 즐겨찾기 유저 실시간 검색 기능
  + 검색어 색깔 변환
  + 즐겨찾기 유저 이름 앞글자 기준 Section Header
  + 즐겨찾기 유저 제거
  
## Getting Started

### Skill

    Swift, RxSwift, RxCocoa
    MVVM + Input/Output
    UIKit, AutoLayout
    Moya, SnapKit, Kingfisher, Toast, Tapman
    Realm, SwiftLint

### Issue

#### 1. 사용자 이름으로 검색어 제한
* 분명히 사용자 이름으로 API를 호출했음에도 Response 중에서 일부 데이터는 검색한 쿼리값에 전혀 상관 없는 데이터가 날아왔다. 
* 원인을 파악해보니 사용자 이름과 사용자의 아이디 중에서 하나만 검색어와 일치해도 Response 데이터에 추가되는 것이었다. 예를 들어 나의 깃허브 계정은 Ethan Park 이면서 Daltonicc인데, 검색어에 Ethan을 입력해도 Response 데이터에 Daltonicc이 있었다. 
* 따로 Parameter로 제한할 수 있는 옵션이 없었기에, 사용자가 직접 처리해줘야했다.

```swift

// 전체 리스트에 추가하기 전, 사용자 이름에 검색어가 정말 포함되어 있는지 확인해주는 로직을 추가했다.

private func checkSearchUserName(query: String, name: String) -> Bool {
    let check = name.contains(query)
    return check
}

private func appendData(query: String ,searchItem: [UserItem]) {
    for i in searchItem {
        let check = checkSearchUserName(query: query, name: i.userName)
        if check {
            totalSearchItem.append(i)
        }
    }
}
```

#### 2. 로컬 뷰의 즐겨찾기 유저 제거 로직
* API 뷰의 경우 따로 Section이 없어서 즐겨찾기 제거를 하려는 셀의 row 값만 delegate패턴으로 전달해주면 됐다. 그러나 로컬 뷰의 경우 별도의 Section이 구현되어 있어 row값을 넘기는 걸로는 해당 데이터를 특정 짓고 제거하는 것이 불가능했다.
* Response 데이터에는 유저마다 고유한 ID값이 있는데, row값 대신에 ID값을 delegate패턴으로 전달해줬고 해당 값으로 DB에서 필터링하여 데이터를 찾고 제거했다.

```swift
private func checkUserIDAndDeleteFromDatabase(userID: String) {
    let filterItem = favoriteUserList.filter("userId = '\(userID)'")[0]
    RealmManager.shared.deleteObjectData(object: filterItem)
}
```

#### 3. 낮은 버전에서 얼럿 호출시 발생하는 런타임 에러
* 로컬 뷰에 있는 유저의 Star버튼을 누르면 즐겨찾기 제거 alert이 나오게끔 구현했다. 그러나 iOS 13.0에서만 alert이 뜨지 않고 런타임 에러가 발생했다. 
* 임시로 다음과 같이 14.0 미만 버전에서는 얼럿 없이 바로 삭제하게끔 조치했지만, 추후에 대응 필요.

```swift

func didTapFavoriteButton(row: Int, userID: String) {
    if #available(iOS 14.0, *) {
        removeAlert { [weak self] _ in
            guard let self = self else { return }
            self.pressFavoriteButtonEvent.accept(userID)
        }
    } else {
        self.pressFavoriteButtonEvent.accept(userID)
    }
}

```

### Reflection

#### 1. 구조 변환
* 프로젝트 중간에 구조를 바꿔야될 일이 있었다. 처음에는 뷰를 1개로 하고 enum을 활용하여 기능을 모두 구현해보려 했으나, ViewModel이 점점 거대해지면서 코드의 가독성도 나빠졌다. 따라서, 사용자에게 크게 이점이 없는 구조라고 판단했고 코드가 더 엉망이 되기 전에 전체 구조를 바꿨다. 다행히도 생각보다 구조를 바꾸는데에 시간은 그리 오래 걸리지 않았다. 기능적인 측면은 잘 분리된 상태로 구현되어있어서 코드를 수정할 소요도 크지 않았다.

#### 2. Realm vs CoreData
* 이번 프로젝트에서는 즐겨찾기 유저 저장을 위해 DB사용이 필수적이었다. DB기능을 제공해주는 iOS 프레임워크 CoreData와 써드파티플랫폼인 Realm 중에서 고민이 필요했다. 즐겨찾기 로직으로 인해 데이터의 잦은 호출과 변화가 필요했기 때문에, In-memory방식의 CoreData는 이번 프로젝트에 적합하지 못하다고 생각했다. 메모리에 로드한 뒤에 데이터를 편집/삭제할 수 있는 CoreData의 특성때문에 앱 런타임 중에 메모리 누수 가능성도 존재했다. 따라서, 로컬 저장소에서 데이터를 가져와서 쓰는 Realm이 이번 프로젝트에 좀 더 적절하다고 판단했다.

#### 3. 로컬 뷰 Section Header
* 개인적으로, 가장 복잡했고 신경써야할 부분이 많은 로직이었다. 따로 header용 리스트를 만들어서 즐겨찾기 유저 데이터가 들어올 때마다 갱신해줘야 했고 검색할 때도 검색데이터에 맞게끔 header가 변해야 했다. 또한 header 리스트를 만들더라도 각 header별 section에 맞는 row의 수를 구해야했기 때문에, header 리스트 하나만으로는 section별 row의 수를 도출할 수 없었다.(header 리스트의 데이터는 중복되어서는 안된다)
* 고민 끝에, 위 모든 고려사항을 신경쓰면서 기능을 구현하려면 header 리스트의 실시간 갱신 로직이 제일 필요했다. 검색어에 따라 header 리스트가 바로 갱신만 되어준다면, 검색된 즐겨찾기 유저 리스트와 비교하여 section별 row의 수도 도출이 가능했다.
* 사실 정말 돌고 돌아서 구현할 뻔했던 로직이었다. 그랬다면 필연적으로 코드도 지저분해졌을 가능성이 컸다. 이번 프로젝트 경험을 통해 어떤 복잡한 문제가 있을 때, 뼈대가 되는 로직 발견의 필요성을 크게 느꼈다.

*****

## ScreenShot
<div markdown="1">  
    <div align = "center">
    <img src="https://user-images.githubusercontent.com/87598209/165725379-efba51be-4d4a-4241-bbdf-aa79db1cd861.png" width="250px" height="500px"></img>
    <img src="https://user-images.githubusercontent.com/87598209/165725389-8a69f9d4-dac0-4a99-9e9a-3798c9afb9b3.png" width="250px" height="500px"></img>
    <img src="https://user-images.githubusercontent.com/87598209/165725402-148c0fe1-0f81-42ab-ad14-f131668cc0b0.png" width="250px" height="500px"></img>
</div>
<div markdown="2">  
    <div align = "center">
    <img src="https://user-images.githubusercontent.com/87598209/165725750-79bd8034-b4e8-40fc-91bb-3648d9ebf637.png" width="250px" height="500px"></img>
    <img src="https://user-images.githubusercontent.com/87598209/165725771-a940c47b-457c-4ffb-9008-9e892c1b28d7.png" width="250px" height="500px"></img>
    <img src="https://user-images.githubusercontent.com/87598209/165725783-7ceeb14a-d1a0-479e-a735-7dfe8500247f.png" width="250px" height="500px"></img>
</div>

## Video

### [iPhone 11 Pro Max(iOS 15.4)](https://youtu.be/LOsTi-mKUjM)
