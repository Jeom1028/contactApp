import UIKit
import SnapKit
import CoreData

class ViewController: UIViewController {
    
    private let friendLabel: UILabel = {
        let label = UILabel()
        label.text = "친구 목록"
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.setTitle("추가", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.backgroundColor = .white
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.id)
        return tableView
    }()
    
    private var friends: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        fetchFriends()
        NotificationCenter.default.addObserver(self, selector: #selector(friendAdded), name: NSNotification.Name("FriendAdded"), object: nil)
    }

    @objc
    private func buttonTapped() {
        self.navigationController?.pushViewController(AddFriendViewController(), animated: true)
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        [
            friendLabel,
            plusButton,
            tableView
        ].forEach { view.addSubview($0) }
        
        friendLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(70)
        }
        
        plusButton.snp.makeConstraints {
            $0.leading.equalTo(friendLabel.snp.trailing).offset(20)
            $0.centerY.equalTo(friendLabel)
            $0.height.equalTo(100)
            $0.width.equalTo(200)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(friendLabel.snp.bottom).offset(20)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
    @objc private func friendAdded() {
        fetchFriends()
    }
    
    private func fetchFriends() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Friend")
        
        // Add sort descriptor to fetch request
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            friends = try managedContext.fetch(fetchRequest)
            tableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let friend = friends[indexPath.row]
        let addFriendVC = AddFriendViewController()
        addFriendVC.friend = friend
        self.navigationController?.pushViewController(addFriendVC, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.id, for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        
        let friend = friends[indexPath.row]
        let name = friend.value(forKey: "name") as? String
        let phone = friend.value(forKey: "phone") as? String
        let imageData = friend.value(forKey: "imageData") as? Data
        let image = imageData != nil ? UIImage(data: imageData!) : nil
        
        cell.configure(name: name ?? "", phone: phone ?? "", image: image)
        return cell
    }
}
