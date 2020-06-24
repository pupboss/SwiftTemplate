//
//  ApplePayService.swift
//  SwiftTemplate
//
//  Created by Jie Li on 31/5/18.
//  Copyright © 2018 Meltdown Research. All rights reserved.
//

import Foundation
import PassKit

class ApplePayService {
    
    class func deviceSupportsApplePay() -> Bool {
        return PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: supportedPKPaymentNetworks())
    }
    class func supportedPKPaymentNetworks() -> [PKPaymentNetwork] {
        return [.visa, .masterCard]
    }
    class func parameters(forPayment payment: PKPayment) -> [String: Any] {
        let paymentString = String.init(data: payment.token.paymentData, encoding: .utf8)
        var payload: [String: Any] = Dictionary()
        payload["pk_token"] = paymentString
        
        if let contact = payment.billingContact {
            payload["card"] = addressParamsFromPKContact(billingContact: contact)
        }
        
        guard !(paymentString?.count == 0 && Constants.stripeAppKey.hasPrefix("pk_live")) else {
            return payload
        }
        
        if let paymentInstrumentName = payment.token.paymentMethod.displayName {
            payload["pk_token_instrument_name"] = paymentInstrumentName
        }
        
        if let paymentNetwork = payment.token.paymentMethod.network {
            payload["pk_token_payment_network"] = paymentNetwork
        }
        
        var transactionIdentifier = payment.token.transactionIdentifier
        
        if transactionIdentifier == "Simulated Identifier" {
            transactionIdentifier = testTransactionIdentifier()
        }
        
        payload["pk_token_transaction_id"] = transactionIdentifier
        
        return payload
    }
    
    class func paymentRequest(withMerchantIdentifier merchantIdentifier: String, country: String, currency: String) -> PKPaymentRequest {
        let paymentRequest = PKPaymentRequest()
        paymentRequest.merchantIdentifier = merchantIdentifier
        paymentRequest.supportedNetworks = supportedPKPaymentNetworks()
        paymentRequest.merchantCapabilities = .capability3DS
        paymentRequest.countryCode = country.uppercased()
        paymentRequest.currencyCode = currency.uppercased()
        return paymentRequest
    }
    
    private class func addressParamsFromPKContact(billingContact: PKContact) -> [String: String]? {
        var params: [String: String] = [:]
        if let nameComponents = billingContact.name {
            params["name"] = PersonNameComponentsFormatter.localizedString(from: nameComponents, style: .default, options: PersonNameComponentsFormatter.Options.init(rawValue: 0))
        }
        if let address = billingContact.postalAddress {
            params["address_line1"] = address.street
            params["address_city"] = address.city
            params["address_state"] = address.state
            params["address_zip"] = address.postalCode
            params["address_country"] = address.isoCountryCode
        }
        
        return params
    }
    
    private class func testTransactionIdentifier() -> String {
        var uuid = UUID().uuidString
        uuid = uuid.replacingOccurrences(of: "~", with: "")
        
        let number = "4242424242424242"
        let cents = "100"
        let identifier = ["ApplePayStubs", number, cents, "SGD", uuid].joined(separator: "~")
        return identifier
    }
}
