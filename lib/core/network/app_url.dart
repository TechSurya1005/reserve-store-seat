abstract class AppUrl {
  static const String baseUrlProd =
      "https://api.pumppartner.socialseller.in/api"; // Production
  static const String baseUrlDev =
      "https://api.pumppartner.socialseller.in/api"; // Development
  static AppUrlEndpoints get authEndPoints => _AuthEndPoints();
}

abstract class AppUrlEndpoints {
  String get dealerLogin;
  String get dealerMyProfile;
  String get getProducts;
  String get getProductsVariant;
  String get getCategories;
  String get createOrder;
  String get getMyOrders;
  String get createAffiliate;
  String get getAffiliateByDealer;
  String get walletMyTransactions;
  String get payoutRequest;
  String get getPayoutRequest;
  String get generatePin;
  String get offerList;
  String get tutorials;
  String get getActitivy;
  String get paymentDetails;
  String get sendOTP;
  String get verifyOTP;
  String get changePassword;
}

class _AuthEndPoints implements AppUrlEndpoints {
  @override
  String get dealerLogin => "/dealers/login";

  @override
  String get dealerMyProfile => "/dealers/my-profile";

  @override
  String get getProducts => "/products";

  @override
  String get getCategories => "/categories";

  @override
  String get createOrder => "/orders";

  @override
  String get createAffiliate => '/affiliates';

  @override
  String get getAffiliateByDealer => '/affiliates/dealer';

  @override
  String get walletMyTransactions => '/wallet/my-transactions';

  @override
  String get payoutRequest => '/payouts/request';

  @override
  String get getPayoutRequest => '/payouts/my-history';

  @override
  String get generatePin => '/affiliates/generate-pin';

  @override
  String get offerList => '/offers';

  @override
  String get tutorials => '/tutorials/type';

  @override
  String get getProductsVariant => '/products/variants';

  @override
  String get getMyOrders => '/orders/my-order';

  @override
  String get getActitivy => '/activity/recent';

    @override
  String get paymentDetails => '/payment-details';
  
  @override
  String get sendOTP => '/dealers/send-otp';
  
  @override
  String get verifyOTP => '/dealers/verify-otp';  
  
  @override
  String get changePassword => '/dealers/change-password';
  
}
