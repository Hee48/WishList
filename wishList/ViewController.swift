
import UIKit
import CoreData


class ViewController: UIViewController {
    
    var loadData: WishListModel?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        jsonloadData()
    }
    
    //위시리스트담기 버튼함수
    @IBAction func wishListputButton(_ sender: UIButton) {
        saveWishList() //위시리스트 코어데이터에 저장하기

    }
    //다른상품보기 버튼함수
    @IBAction func anotheritemButton(_ sender: UIButton) {
        jsonloadData() //상품불러오는 함수호출부분
    }
    //위시리스트보기 버튼함수
    @IBAction func wishListButton(_ sender: UIButton) {
        guard let wishListvc = storyboard?.instantiateViewController(withIdentifier: "WishListVC") as? WishListViewController else { return }
        present(wishListvc, animated: true)
    }
}


//JSON데이터가져오고 UI그리는코드 넣어둔곳 위시리스트 코어데이터에 저장시키는 함수
extension ViewController {
    
    //JSON데이터 가져오는부분
    func jsonloadData() {
        let jsonDataID = Int.random(in: 1...100)
        let session = URLSession.shared
        if let url = URL(string: "https://dummyjson.com/products/\(jsonDataID)") {
            let task = session.dataTask(with: url) {(data, response, error) in
                if let error = error {
                    print("Error: Json Data \(error)")
                } else if let data = data {
                    do {
                        let loadData = try JSONDecoder().decode(WishListModel.self, from: data)
                        print("Decoding")
                        self.loadData = loadData //loadData를 loadData 프로퍼티에 할당
                        DispatchQueue.main.async {
                            self.titleLabel.text = loadData.title
                            self.descriptionLabel.text = loadData.description
                            self.priceLabel.text = "Price : \(loadData.price)$"
                            self.brandLabel.text = "Brand : \(loadData.brand)"
                            self.loadImage(from: loadData.thumbnail)
                            self.categoryLabel.text = "category : \(loadData.category)"
                        }
                    } catch {
                        print("DecodingError : \(error)")
                    }
                }
            }
            task.resume()
        }
    }
    // 이미지를 비동기적으로 가져오는 함수
    func loadImage(from url: URL) {
        let session = URLSession.shared
        let task = session.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                self?.imageView.image = UIImage(data: data)
            }
        }
        task.resume()
    }
    
    //위시리스트 저장함수
    func saveWishList() {
        guard let loadData = loadData else {
            print("NO data to save")
            return
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "WishList", in: context)
        if let entity = entity {
            let wishList = NSManagedObject(entity: entity, insertInto: context)
            wishList.setValue(loadData.id, forKey: "id")
            wishList.setValue(loadData.title, forKey: "title")
            wishList.setValue(loadData.price, forKey: "price")
            do {
                try context.save()
                print("save Data")
            } catch {
                print("Failed to save")
            }
        }  else {
            print("saveWishListError")
        }
    }

}


