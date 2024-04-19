
import UIKit
import CoreData


class ViewController: UIViewController {
    
    var loadData: WishListModel?
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var wishListButton: UIButton!
    @IBOutlet weak var anotheritemButton: UIButton!
    @IBOutlet weak var wishListputButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alpha()
        jsonloadData()
    }


    //위시리스트담기 버튼함수
    @IBAction func wishListputButton(_ sender: UIButton) {
        if let loadData = loadData {
            saveWishList(with: loadData) //위시리스트 코어데이터에 저장하기
        }
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
    
    //화면 로더뜨기전 정보를 흐리게하는부분
    func alpha() {
        loader.alpha = 1.0
        imageView.alpha = 0.0
        titleLabel.alpha = 0.0
        descriptionLabel.alpha = 0.0
        priceLabel.alpha = 0.0
        brandLabel.alpha = 0.0
        categoryLabel.alpha = 0.0
        wishListButton.alpha = 0.0
        anotheritemButton.alpha = 0.0
        wishListputButton.alpha = 0.0
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
                            self.updateUI(with: loadData)
                        }
                    } catch {
                        print("DecodingError : \(error)")
                    }
                }
            }
            task.resume()
        }
    }
    //DisPatchQueue에 있던 UI 뜯어낸거
    func updateUI(with loadData: WishListModel) {
        self.titleLabel.text = loadData.title
        self.descriptionLabel.text = loadData.description
        self.priceLabel.text = "Price : \(loadData.price)$"
        self.brandLabel.text = "Brand : \(loadData.brand)"
        self.loadImage(from: loadData.thumbnail)
        self.categoryLabel.text = "category : \(loadData.category)"
        
        //정보가 다뜨면 알파값변경
        UIView.animate(withDuration: 0.3) {
            self.imageView.alpha = 1.0
            self.loader.alpha = 0.0
            self.titleLabel.alpha = 1.0
            self.descriptionLabel.alpha = 1.0
            self.priceLabel.alpha = 1.0
            self.brandLabel.alpha = 1.0
            self.categoryLabel.alpha = 1.0
            self.wishListButton.alpha = 1.0
            self.anotheritemButton.alpha = 1.0
            self.wishListputButton.alpha = 1.0
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
    func saveWishList(with loadData: WishListModel) {
        let context = ContainerManager.shared.persistentContainer.viewContext
        let wish = WishList.init(context: context)
        
        wish.id = Int64(loadData.id)
        wish.title = loadData.title
        wish.price = loadData.price
        
        do {
            try context.save()
            print("Save Data")
        } catch {
            print("SaveWishList Error")
        }
    }
}
