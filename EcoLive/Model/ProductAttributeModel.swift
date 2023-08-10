//
//  ProductAttributeModel.swift
//  EcoLive
//
//  Created by Emizen Tech Amit on 19/07/22.
//


import Foundation

// MARK: - ProductAttributeModel
class ProductAttributeModel: Codable {
    let statusCode: Int
    let message: String
    let data: [ProductAttribute]

    init(statusCode: Int, response: String, message: String, data: [ProductAttribute]) {
        self.statusCode = statusCode
        self.message = message
        self.data = data
    }
}

// MARK: - Datum
class ProductAttribute: Codable {
    let dropdownList: [DropdownList]
    let status: Bool
    let id, shopCategoryID, shopSubCategoryID, label: String
    let inputType, key, placeHolder: String
    let validation: Validation
    let createdAt, updatedAt: String
    let v: Int
    var inputValue:String = ""
    var inputColor:[String] = [String]()

    enum CodingKeys: String, CodingKey {
        case dropdownList, status
        case id = "_id"
        case shopCategoryID = "shopCategoryId"
        case shopSubCategoryID = "shopSubCategoryId"
        case label, inputType, key, placeHolder, validation, createdAt, updatedAt
        case v = "__v"
    }

    init(dropdownList: [DropdownList], status: Bool, id: String, shopCategoryID: String, shopSubCategoryID: String, label: String, inputType: String, key: String, placeHolder: String, validation: Validation, createdAt: String, updatedAt: String, v: Int) {
        self.dropdownList = dropdownList
        self.status = status
        self.id = id
        self.shopCategoryID = shopCategoryID
        self.shopSubCategoryID = shopSubCategoryID
        self.label = label
        self.inputType = inputType
        self.key = key
        self.placeHolder = placeHolder
        self.validation = validation
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.v = v
    }
}

// MARK: - DropdownList
class DropdownList: Codable {
    let value, option: String

    init(value: String, option: String) {
        self.value = value
        self.option = option
    }
}

// MARK: - Validation
class Validation: Codable {
    let isRequire: Bool
    let message: String

    init(isRequire: Bool, message: String) {
        self.isRequire = isRequire
        self.message = message
    }
}
