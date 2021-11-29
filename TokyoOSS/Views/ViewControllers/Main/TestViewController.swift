//
//  TestViewController.swift
//  TokyoOSS
//
//  Created by ミズキ on 2021/11/29.
//

import UIKit
import EditorJSKit
class TestViewController: UIViewController {
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var blockList: EJBlocksList!
    private lazy var renderer = EJCollectionRenderer(collectionView: collectionView)
    override func viewDidLoad() {
        super.viewDidLoad()
        performNetworkTask()
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        // Do any additional setup after loading the view.
    }
    
    private func performNetworkTask() {
        let path1 = Bundle.main.path(forResource: "EditorJSMock", ofType: "json")
        print(path1)
        guard let path = Bundle.main.path(forResource: "EditorJSMock", ofType: "json") else {
            print("sfdsfs")
            return }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else { return }
        blockList = try! JSONDecoder().decode(EJBlocksList.self, from: data)

        collectionView.reloadData()
    }

}
///
extension TestViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        do {
            return try renderer.size(forBlock: blockList.blocks[indexPath.section], itemIndex: indexPath.item, style: nil, superviewSize: collectionView.frame.size)
        } catch {
            return CGSize(width: 100, height: 100)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return renderer.spacing(forBlock: blockList.blocks[section])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return renderer.insets(forBlock: blockList.blocks[section])
    }
}
extension TestViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let blockList = blockList else { return 0 }
        return blockList.blocks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return blockList.blocks[section].data.numberOfItems
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        do {
            return try renderer.render(block: blockList.blocks[indexPath.section], indexPath: indexPath)
        }
        catch {
            return UICollectionViewCell()
        }
    }
}
