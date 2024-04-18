
import UIKit
import CoreData

class WishListViewController: UITableViewController {
    
    var wishList: [WishList] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wishListfetch() //CoraData에서 데이터 가져오는 함수
    }
    
    //위시리스트 함수
    func wishListfetch() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        do {
            //CoraData에서 데이터 가져오는부분
            wishList = try context.fetch(WishList.fetchRequest()) as! [WishList]
            print("WishList")
        } catch {
            print("WishList Error")
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wishList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let wishListItem = wishList[indexPath.row]
        let id = wishListItem.id
        let title = wishListItem.title ?? ""
        let price = wishListItem.price
        //셀에 Label생성
        cell.textLabel?.text = "[\(id)] \(title) - \(price)$"
        return cell
    }
}
