//
//  UtilityObject.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 19/07/21.
//

import UIKit

class UtilityObject: NSObject, Codable {
    var arrOnboarding: [OnboardingObject] = []
    var arrShopCategory: [ShopCategoryObject] = []
    var arrVehicleCategory: [VehicleCategoryObject] = []
    var arrProductCategory: [ProductCategoryObject] = []
    static var arrColorVehicleFuel: [String] = []
    
    init(_ dictionary: [String: Any]) {
        //ONBOARDING LIST
        if let onboarding = dictionary["onBordingScreen"] as? [Dictionary<String, Any>] {
            for i in 0..<onboarding.count  {
                let objData = OnboardingObject.init(onboarding[i])
                self.arrOnboarding.append(objData)
            }
        }
        
        //SHOP CATEGORY LIST
        if let shopCategory = dictionary["shopCategories"] as? [Dictionary<String, Any>] {
            for i in 0..<shopCategory.count  {
                let objData = ShopCategoryObject.init(shopCategory[i])
                self.arrShopCategory.append(objData)
            }
        }
        
        //VEHICLE CATEGORY LIST
        if let vehicleCategory = dictionary["vehicalCategories"] as? [Dictionary<String, Any>] {
            for i in 0..<vehicleCategory.count  {
                let objData = VehicleCategoryObject.init(vehicleCategory[i])
                self.arrVehicleCategory.append(objData)
            }
        }
        
        //VEHICLE CATEGORY LIST
        if let productCategory = dictionary["productCategories"] as? [Dictionary<String, Any>] {
            for i in 0..<productCategory.count  {
                let objData = ProductCategoryObject.init(productCategory[i])
                self.arrProductCategory.append(objData)
            }
        }
    }
}

//MARK: - ONBOARDING OBJECT
struct OnboardingObject: Codable {
    var title: String = ""
    var appImage: String = ""
    var appDescription: String = ""
    var appContent: String = ""
    
    init(_ dictionary: [String: Any]) {
        self.title = dictionary["title"] as? String ?? ""
        self.appImage = dictionary["banner"] as? String ?? ""
        self.appDescription = dictionary["description"] as? String ?? ""
        self.appContent = dictionary["content"] as? String ?? ""
    }
}

//MARK: - SHOP CATEGORY OBJECT
struct ShopCategoryObject: Codable {
    var _id: String = ""
    var name: String = ""
    var description: String = ""
    var createdAt: String = ""
    var updatedAt: String = ""
    
    init(_ dictionary: [String: Any]) {
        self._id = dictionary["_id"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.description = dictionary["description"] as? String ?? ""
        self.createdAt = dictionary["createdAt"] as? String ?? ""
        self.updatedAt = dictionary["updatedAt"] as? String ?? ""
    }
}

//MARK: - VEHICLE CATEGORY OBJECT
struct VehicleCategoryObject: Codable {
    var _id: String = ""
    var name: String = ""
    var description: String = ""
    var createdAt: String = ""
    var updatedAt: String = ""
    
    init(_ dictionary: [String: Any]) {
        self._id = dictionary["_id"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.description = dictionary["description"] as? String ?? ""
        self.createdAt = dictionary["createdAt"] as? String ?? ""
        self.updatedAt = dictionary["updatedAt"] as? String ?? ""
    }
}

//MARK: - PRODUCT CATEGORY OBJECT
struct ProductCategoryObject: Codable {
    var _id: String = ""
    var name: String = ""
    var description: String = ""
    var createdAt: String = ""
    var updatedAt: String = ""
    var image: String = ""
    
    init(_ dictionary: [String: Any]) {
        self._id = dictionary["_id"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.description = dictionary["description"] as? String ?? ""
        self.createdAt = dictionary["createdAt"] as? String ?? ""
        self.updatedAt = dictionary["updatedAt"] as? String ?? ""
        self.image = dictionary["image"] as? String ?? ""
    }
}


//MARK: - PRODUCT CATEGORY OBJECT
struct ProductCategoryObjectNew: Codable {
    var _id: String = ""
    var name: String = ""
    var vehicleTypeColor: String = ""
    init(_ dictionary: [String: Any]) {
        self._id = dictionary["_id"] as? String ?? ""
        self.name = dictionary["title"] as? String ?? ""
        self.vehicleTypeColor = dictionary["vehicleTypeColor"] as? String ?? ""
   }
}
//MARK: - ProductTypeObjectNew CATEGORY OBJECT
struct ProductTypeObjectNew: Codable {
    var _id: String = ""
    var name: String = ""
   
    init(_ dictionary: [String: Any]) {
        self._id = dictionary["_id"] as? String ?? ""
        self.name = dictionary["title"] as? String ?? ""
      
    }
}

//MARK: - ShopCategory
struct ShopInfoCategoryObject: Codable {
    
    var _id: String  = ""
    var name: String = ""
    var shopInfoCategorySubObject : [ShopInfoCategorySubObject] = []
    init(_ dictionary: [String: Any]) {
        self._id = dictionary["_id"] as? String ?? ""
        self.name = dictionary["categoryName"] as? String ?? ""
        if let subCategories = dictionary["subCategories"] as? [Dictionary<String, Any>] {
            for i in 0..<subCategories.count  {
                let objData = ShopInfoCategorySubObject.init(subCategories[i])
                self.shopInfoCategorySubObject.append(objData)
            }
        }
    }
    
}
//MARK: - ShopType
struct ShopInfoCategorySubObject: Codable {
    var _id: String = ""
    var name: String = ""
    var shopCategoryId: String = ""
    init(_ dictionary: [String: Any]) {
        self._id = dictionary["_id"] as? String ?? ""
        self.name = dictionary["subCategoryName"] as? String ?? ""
        self.shopCategoryId = dictionary["shopCategoryId"] as? String ?? ""
    }
}
