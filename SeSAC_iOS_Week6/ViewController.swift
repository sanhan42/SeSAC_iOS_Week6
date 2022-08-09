//
//  ViewController.swift
//  SeSAC_iOS_Week6
//
//  Created by 한상민 on 2022/08/08.
//

import UIKit

/*
 1. html tag <> </> 기능 활용
 2. 문자열 대체 메서드 사용
 response에서 처리하는 것과 보여지는 셀 등에서 처리하는 것의 차이는?
 html tag를 이후에 사용할 일이 없다면, response에서 처리하는 것이 나을 것 같다.
 */

/*
 TableView automaticDimension
 - 컨텐츠 양에 따라서 셀 높이가 자유롭게
 - 조건 : 레이블 numberOfLines = 0
 - 조건 : tableVIew Height automaticDimesion // UITableView.automaticDimension
 - 조건 : layout이 잘 잡혀있어야 한다. 크기가 유동적으로 변할 수 있도록!
 */

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var blogList: [String] = []
    var cafeList: [String] = []
    var isExpanded = false // false 2줄, true 0줄로 처리.
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension // 여기에 써주면 모든 섹션의 셀에 대해서 유동적!
        // 특정 셀에 적용하려면 heightForRowAt 에서..
        searchBlog()
        
    }
    
    @IBAction func expandCell(_ sender: UIBarButtonItem) {
        isExpanded = !isExpanded
        tableView.reloadData()
    }
    
    func searchBlog() {
        KakaoAPIManager.shared.callRequest(type: .blog, query: "고래밥") { json in
//            self.blogList.append(contentsOf:  json["documents"].arrayValue.map {$0["contents"].stringValue})
            for item in json["documents"].arrayValue {
                let value = item["contents"].stringValue.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
                self.blogList.append(value)
            }
            self.searchCafe()
          
        }
    }
    
    func searchCafe() {
        KakaoAPIManager.shared.callRequest(type: .cafe, query: "고래밥") { json in
            self.cafeList.append(contentsOf:  json["documents"].arrayValue.map {$0["contents"].stringValue.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")})
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    /*
    func requestBlog(query: String) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let url = Endpoint.blog.requestURL + query
        let header = HTTPHeader(name: "Authorization", value: "KakaoAK " + APIKey.kakao)
        // Alamofire - 내부적으로 URLSession Framework를 사용.
        // URLSession Framework는 비동기로 Request.
        AF.request(url,method: .get, headers: [header]).validate(statusCode: 200...300).responseData(queue: .global()) { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
            case .failure(let error):
                print(error)
            }
        }
        
    }
    */
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? blogList.count : cafeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "KakaoCell", for: indexPath) as? KakaoCell else { return UITableViewCell() }
        cell.testLabel.text = indexPath.section == 0 ? blogList[indexPath.row] : cafeList[indexPath.row]
        cell.testLabel.numberOfLines = isExpanded ? 0 : 2
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "블로그 검색 결과" : "카페 검색 결과"
    }
}

class KakaoCell: UITableViewCell {
    @IBOutlet weak var testLabel: UILabel!

}
