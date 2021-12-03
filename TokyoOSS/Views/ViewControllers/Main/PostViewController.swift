import UIKit
import RxSwift
import RxCocoa
import RxGesture
import PKHUD
import CoreLocation
final class PostViewController: UIViewController,Coordinating {
    // MARK: - Properties
    @IBOutlet private weak var pictureButton: UIButton!
    @IBOutlet private weak var dismissButton: UIButton!
    @IBOutlet private weak var postButton: UIButton!
    @IBOutlet private weak var titleTextField: UITextField! {
        didSet {
            titleTextField.layer.borderColor = UIColor.lightGray.cgColor
            titleTextField.layer.borderWidth = 1
        }
    }
    private let placeholderLabel:UILabel = {
        let label = UILabel()
        label.text = "テキスト入力"
        label.textColor = .lightGray
        return label
    }()
    private let countLabel:UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .lightGray
        return label
    }()
    @IBOutlet private weak var textView: UITextView! {
        didSet {
            textView.layer.borderColor = UIColor.lightGray.cgColor
            textView.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var postImageView: UIImageView!
    private var viewModel:PostViewModel!
    private let disposeBag = DisposeBag()
    private let picker = UIImagePickerController()
    var coordinator: Coordinator?
    private let locationManager = CLLocationManager()
    var lat = String()
    var lon = String()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        setupUI()
        coordinator = MainCoordinator()
        picker.delegate = self
        locationManager.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.startUpdatingLocation()
    }
    private func setupUI() {
        textView.addSubview(placeholderLabel)
        placeholderLabel.anchor(top:textView.topAnchor,
                                leading: textView.leadingAnchor,paddingTop: 10,paddingLeft: 10)
        textView.addSubview(countLabel)
        countLabel.anchor(leading: textView.leadingAnchor, bottom:  textView.bottomAnchor,
                          paddingLeft: 20, paddingBottom: -400)
    }
    private func setupBinding() {
        viewModel = PostViewModel(tap: dismissButton.rx.tap.asSignal(),
                                  openTap: postButton.rx.tap.asSignal(),pictureTap:pictureButton.rx.tap.asSignal(),api: FetchPost(),userAPI: FetchUser())
        
        titleTextField.rx.text.asDriver().drive(onNext: { [weak self] text in
            self?.viewModel.inputs.titleTextField.accept(text ?? "")
            self?.titleTextField.layer.borderColor = self?.viewModel.outputs.titleBorderColor
        }).disposed(by: disposeBag)
        
        textView.rx.text.asDriver().drive(onNext: { [weak self] text in
            self?.viewModel.inputs.contentTextView.accept(text ?? "")
            guard let bool = self?.viewModel.isPlaceHolderLabelHidden else { return }
            self?.placeholderLabel.isHidden = bool
            self?.textView.layer.borderColor = self?.viewModel.outputs.textViewBorderColor
            self?.countLabel.text = self?.viewModel.outputs.textViewCount
        }).disposed(by: disposeBag)
        
        
        viewModel.outputs.doneDismiss.subscribe(onNext: { [weak self] _ in
            self?.coordinator?.eventOccurred(tap: .dismiss, vc: self!)
        }).disposed(by: disposeBag)
        
        viewModel.outputs.donePost.subscribe(onNext: {[weak self] _ in
            HUD.show(.success, onView: self?.view)
            self?.coordinator?.eventOccurred(tap: .dismiss, vc: self!)
        }).disposed(by: disposeBag)
        
        viewModel.outputs.toPhotoLibrary.subscribe(onNext: { _ in
            self.present(self.picker, animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
        titleTextField.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.titleTextField.layer.borderColor = UIColor.systemTeal.cgColor
            }).disposed(by: disposeBag)
        
        textView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.textView.layer.borderColor = UIColor.systemTeal.cgColor
            }).disposed(by: disposeBag)
        
        postButton.rx.tap.asDriver().drive(onNext: { _ in
            self.viewModel.inputs.post(image: self.postImageView.image!) { result in
                switch result {
                case .success:
                    self.coordinator?.eventOccurred(tap: .dismiss, vc: self)
                case .failure(let error):
                    print(error)
                }
            }
        }).disposed(by: disposeBag)

    }
    
}
extension PostViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(#function)
        pictureButton.isHidden = true
        guard let image = info[.originalImage] as? UIImage else { return }
        postImageView.image = image
        dismiss(animated: true, completion: nil)
    }
}


extension PostViewController:CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locations.last.map {
            let latitude = $0.coordinate.latitude
            let longitude =  $0.coordinate.longitude
            self.lat = "\(latitude)"
            self.lon = "\(longitude)"
            viewModel.lat = latitude
            viewModel.lng = longitude
        }
    }
    func locationManager(_ manager: CLLocationManager,didChangeAuthorization status: CLAuthorizationStatus) {
             switch status {
             case .notDetermined:
                 manager.requestWhenInUseAuthorization()
             case .restricted, .denied:
                 break
             case .authorizedAlways, .authorizedWhenInUse:
                 manager.startUpdatingLocation()
                 break
             default:
                 break
             }
         }
}
