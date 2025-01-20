//
//  ViewController.swift
//  PLFramework
//
//  Created by cank388 on 01/19/2025.
//  Copyright (c) 2025 cank388. All rights reserved.
//

import UIKit
import PLFramework

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @objc func nodeButtonTapped(_ sender: UIButton) {
        if let path = Bundle.main.path(forResource: "graph", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                if let graph = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    // Select a random node
                    if let randomNode = graph.randomElement(), let nodeId = randomNode["id"] as? String {
                        if let closestNode = try PLNavigator.findClosestNode(from: data, startNodeId: nodeId, pointType: "wc", algorithm: DijkstraAlgorithm()) {
                            let alert = UIAlertController(title: "Closest Node", message: "Node ID: \(closestNode.node.id), Distance: \(closestNode.distance)", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            present(alert, animated: true, completion: nil)
                        } else {
                            let alert = UIAlertController(title: "Error", message: "No node found with the specified pointType.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            present(alert, animated: true, completion: nil)
                        }
                    }
                }
            } catch {
                let alert = UIAlertController(title: "Error", message: "Error parsing graph: \(error)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        }
    }

    @IBAction func firstButtonTapped(_ sender: Any) {
        nodeButtonTapped(sender as! UIButton)
    }
    
    @IBAction func secondButtonTapped(_ sender: Any) {
        nodeButtonTapped(sender as! UIButton)
    }
    
    @IBAction func thirdButtonTapped(_ sender: Any) {
        nodeButtonTapped(sender as! UIButton)
    }
    
    @IBAction func fourthButtonTapped(_ sender: Any) {
        nodeButtonTapped(sender as! UIButton)
    }
    
}

