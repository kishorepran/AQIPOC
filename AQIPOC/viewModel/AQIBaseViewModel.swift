//
//  AQIBaseViewModel.swift
//  AQIPOC
//
//  Created by User on 10/24/21.
//

import Foundation
import Starscream

protocol ViewModelDelegate: AnyObject {
    func viewModelDidUpdate()
    func viewModelUpdateFailed(error: AQIError)
}

class AQBaseViewModel {
    init(with citiesList: [String]) {
        self.citiesList = citiesList
    }
    private var socket: WebSocket = {
        let url = URL(string: "ws://city-ws.herokuapp.com")!
        let urlRequest = URLRequest(url: url)
        let webSocket = WebSocket(request: urlRequest)
        return webSocket
    }()
    let citiesList: [String]
    weak var delegate: ViewModelDelegate?
    
    var pollList: AQIList = [] {
        didSet {
            handleUpdate()
        }
    }
    
    lazy var defaultCitiesList: [AQIElement] = {
        var list: [AQIElement] = []
        for element in citiesList {
            let aqi = AQIElement(city: element, aqi: 0.0)
            list.append(aqi)
        }
        return list
    }()
    
    func filtered(cities cityList: [String], from aqiList: AQIList) -> AQIList? {
        let filteredList = aqiList.filter {cityList.contains($0.city)}
        return filteredList
    }
    
    func mergeIntoDefaultList(_ filteredList: AQIList) {
        
        for element in filteredList {
            if let index = defaultCitiesList.firstIndex(of: element) {
                print("merge \(element.city) \(element.aqi) into default value \(defaultCitiesList[index].city) \(defaultCitiesList[index].aqi)")
                defaultCitiesList[index] = element
            }
        }
    }
    
    func handleUpdate() {
        if let filteredList = filtered(cities: citiesList, from: pollList) {
            mergeIntoDefaultList(filteredList)
        }
        delegate?.viewModelDidUpdate()
    }
    
    private func handle(data: Data) {
        let decoder = JSONDecoder()
        do {
            let item = try decoder.decode(AQIList.self, from: data)
            self.pollList = item
        } catch {
            self.delegate?.viewModelUpdateFailed(error: AQIServerResponseError.JsonParsing)
        }
    }
}

extension AQBaseViewModel {
    func startDataPoll() {
        // Start the socket connection
        socket.delegate = self
        socket.connect()
    }
    
    func stopDataPoll() {
        // Stop the socket connection
        socket.disconnect()
        socket.delegate = nil
    }
    
}

extension AQBaseViewModel: WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            print("websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            let data = Data(string.utf8)
            handle(data: data)
            print("Received text: \(string)")
        case .error(let error):
            print(error)
            break
        default:
            break
        }
    }
}
