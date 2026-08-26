import '../services/locale_service.dart';

class AppStrings {
  static String _t(String ar, String en) {
    return LocaleService.instance.isArabic ? ar : en;
  }

  // ============================================================
  // عام
  // ============================================================

  static String get appName =>
      _t('صيدلية الأمل', 'Alamal Pharmacy');

  static String get loading =>
      _t('جاري التحميل...', 'Loading...');

  static String get save =>
      _t('حفظ', 'Save');

  static String get cancel =>
      _t('إلغاء', 'Cancel');

  static String get confirm =>
      _t('متابعة', 'Continue');

  static String get back =>
      _t('رجوع', 'Back');

  static String get next =>
      _t('التالي', 'Next');

  static String get done =>
      _t('تم', 'Done');

  static String get close =>
      _t('إغلاق', 'Close');

  static String get search =>
      _t('بحث', 'Search');

  static String get retry =>
      _t('إعادة المحاولة', 'Retry');

  static String get yes =>
      _t('نعم', 'Yes');

  static String get no =>
      _t('لا', 'No');

  static String get error =>
      _t('حدث خطأ', 'An error occurred');

  static String get noResults =>
      _t('لا توجد نتائج', 'No results found');

  static String get requiredField =>
      _t('هذا الحقل مطلوب', 'This field is required');

  // ============================================================
  // اللغة
  // ============================================================

  static String get arabic =>
      _t('العربية', 'Arabic');

  static String get english =>
      _t('الإنجليزية', 'English');

  static String get language =>
      _t('اللغة', 'Language');

  static String get isArabicText =>
      _t('العربية', 'English');

  // ============================================================
  // تسجيل الدخول
  // ============================================================

  static String get loginTitle =>
      _t('تسجيل الدخول', 'Log In');

  static String get welcomeBack =>
      _t('مرحباً بعودتك', 'Welcome Back');

  static String get phoneNumber =>
      _t('رقم الجوال', 'Phone Number');

  static String get enterPhoneNumber =>
      _t('أدخلي رقم الجوال', 'Enter your phone number');

  static String get password =>
      _t('كلمة المرور', 'Password');

  static String get enterPassword =>
      _t('أدخلي كلمة المرور', 'Enter your password');

  static String get forgotPassword =>
      _t('نسيتِ كلمة المرور؟', 'Forgot Password?');

  static String get login =>
      _t('تسجيل الدخول', 'Log In');

  static String get loginRegister =>
      _t('دخول / تسجيل', 'Login / Register');

  static String get dontHaveAccount =>
      _t('ليس لديك حساب؟', "Don't have an account?");

  static String get createAccount =>
      _t('إنشاء حساب', 'Create Account');

  static String get invalidPhone =>
      _t('أدخلي رقم جوال صحيح', 'Enter a valid phone number');

  static String get invalidPassword =>
      _t('كلمة المرور غير صحيحة', 'Incorrect password');

  static String get loginFailed =>
      _t(
        'تعذر تسجيل الدخول، حاولي مرة أخرى',
        'Unable to log in. Please try again.',
      );

  // ============================================================
  // إنشاء الحساب
  // ============================================================

  static String get createAccountTitle =>
      _t('إنشاء حساب', 'Create Account');

  static String get fullName =>
      _t('الاسم الكامل', 'Full Name');

  static String get enterFullName =>
      _t('أدخلي الاسم الكامل', 'Enter your full name');

  static String get email =>
      _t('البريد الإلكتروني', 'Email');

  static String get enterEmail =>
      _t('أدخلي البريد الإلكتروني', 'Enter your email');

  static String get confirmPassword =>
      _t('تأكيد كلمة المرور', 'Confirm Password');

  static String get enterConfirmPassword =>
      _t('أعيدي إدخال كلمة المرور', 'Re-enter your password');

  static String get accountCreated =>
      _t('تم إنشاء الحساب بنجاح', 'Account created successfully');

  static String get alreadyHaveAccount =>
      _t('لديك حساب بالفعل؟', 'Already have an account?');

  // ============================================================
  // نسيت كلمة المرور
  // ============================================================

  static String get forgotPasswordTitle =>
      _t('نسيتِ كلمة المرور', 'Forgot Password');

  static String get forgotPasswordDescription =>
      _t(
        'أدخلي رقم الجوال لاستعادة كلمة المرور',
        'Enter your phone number to reset your password',
      );

  static String get sendCode =>
      _t('إرسال الرمز', 'Send Code');

  static String get verificationCode =>
      _t('رمز التحقق', 'Verification Code');

  static String get enterVerificationCode =>
      _t('أدخلي رمز التحقق', 'Enter verification code');

  static String get verify =>
      _t('تحقق', 'Verify');

  static String get resendCode =>
      _t('إعادة إرسال الرمز', 'Resend Code');

  // ============================================================
  // الرئيسية
  // ============================================================

  static String get home =>
      _t('الرئيسية', 'Home');

  static String get categories =>
      _t('الفئات', 'Categories');

  static String get products =>
      _t('المنتجات', 'Products');

  static String get seeAll =>
      _t('عرض الكل', 'See All');

  static String get popularProducts =>
      _t('المنتجات الأكثر طلباً', 'Popular Products');

  static String get featuredProducts =>
      _t('منتجات مميزة', 'Featured Products');

  static String get offers =>
      _t('العروض', 'Offers');

  static String get deliveryToHome =>
      _t('التوصيل إلى المنزل', 'Home Delivery');

  static String get deliveryTo =>
      _t('التوصيل إلى', 'Delivery to');

  static String get defaultAddress =>
      _t('حي السويس، جازان', 'Al-Suwais District, Jazan');

  static String get pickupFromPharmacy =>
      _t('استلام من الصيدلية', 'Pickup from Pharmacy');

  static String get chooseNearestPharmacy =>
      _t(
        'اختاري الصيدلية الأقرب لك',
        'Choose the nearest pharmacy',
      );

  static String get deliveryToYourDoor =>
      _t(
        'نوصل طلبك إلى باب منزلك',
        'We deliver your order to your doorstep',
      );

  // ============================================================
  // البحث
  // ============================================================

  static String get searchProducts =>
      _t('ابحثي عن منتج', 'Search for a product');

  static String get searchProductsHint =>
      _t(
        'ابحثي عن دواء أو منتج...',
        'Search for a medicine or product...',
      );

  static String get searchForProduct =>
      _t(
        'ابحثي عن المنتجات...',
        'Search for products...',
      );

  static String get noProductsFound =>
      _t(
        'لم يتم العثور على منتجات',
        'No products found',
      );

  static String get searchResults =>
      _t('نتائج البحث', 'Search Results');

  // ============================================================
  // الفئات
  // ============================================================

  static String get category =>
      _t('الفئة', 'Category');

  static String get healthCare =>
      _t('العناية الصحية', 'Health Care');

  static String get skinCare =>
      _t('العناية بالبشرة', 'Skin Care');

  static String get hairCare =>
      _t('العناية بالشعر', 'Hair Care');

  static String get vitamins =>
      _t(
        'الفيتامينات والمكملات',
        'Vitamins & Supplements',
      );

  static String get medicines =>
      _t('الأدوية', 'Medicines');

  static String get babyCare =>
      _t('العناية بالأطفال', 'Baby Care');

  static String get personalCare =>
      _t('العناية الشخصية', 'Personal Care');

  static String get medicalDevices =>
      _t('أدوات طبية', 'Medical Devices');

  static String get children =>
      _t('أطفال', 'Baby Care');

  static String get skin =>
      _t('بشرة', 'Skin Care');

  // ============================================================
  // المنتجات
  // ============================================================

  static String get productDetails =>
      _t('تفاصيل المنتج', 'Product Details');

  static String get price =>
      _t('السعر', 'Price');

  static String get quantity =>
      _t('الكمية', 'Quantity');

  static String get addToCart =>
      _t('إضافة للسلة', 'Add to Cart');

  static String get addedToCart =>
      _t('تمت الإضافة إلى السلة', 'Added to cart');

  static String get outOfStock =>
      _t('غير متوفر', 'Out of Stock');

  static String get available =>
      _t('متوفر', 'Available');

  static String get description =>
      _t('الوصف', 'Description');

  // ============================================================
  // السلة
  // ============================================================

  static String get cart =>
      _t('السلة', 'Cart');

  static String get shoppingCart =>
      _t('سلة التسوق', 'Shopping Cart');

  static String get emptyCart =>
      _t('السلة فارغة', 'Your cart is empty');

  static String get total =>
      _t('الإجمالي', 'Total');

  static String get subtotal =>
      _t('المجموع الفرعي', 'Subtotal');

  static String get deliveryFee =>
      _t('رسوم التوصيل', 'Delivery Fee');

  static String get checkout =>
      _t('إتمام الطلب', 'Checkout');

  static String get remove =>
      _t('حذف', 'Remove');

  // ============================================================
  // العناوين
  // ============================================================

  static String get addresses =>
      _t('العناوين', 'Addresses');

  static String get addAddress =>
      _t('إضافة عنوان', 'Add Address');

  static String get addNewAddress =>
      _t('إضافة عنوان جديد', 'Add New Address');

  static String get searchAddress =>
      _t('ابحثي عن عنوانك', 'Search for your address');

  static String get addressDetails =>
      _t('تفاصيل العنوان', 'Address Details');

  static String get addressName =>
      _t('اسم العنوان', 'Address Name');

  static String get addressType =>
      _t('نوع العنوان', 'Address Type');

  static String get homeAddress =>
      _t('المنزل', 'Home');

  static String get workAddress =>
      _t('العمل', 'Work');

  static String get otherAddress =>
      _t('آخر', 'Other');

  static String get saveAddress =>
      _t('حفظ العنوان', 'Save Address');

  static String get savedAddresses =>
      _t('العناوين المحفوظة', 'Saved Addresses');

  static String get noAddresses =>
      _t('لا توجد عناوين محفوظة', 'No saved addresses');

  // ============================================================
  // التوصيل
  // ============================================================

  static String get delivery =>
      _t('التوصيل', 'Delivery');

  static String get deliveryOptions =>
      _t('خيارات التوصيل', 'Delivery Options');

  static String get standardDelivery =>
      _t('التوصيل العادي', 'Standard Delivery');

  static String get expressDelivery =>
      _t('التوصيل السريع', 'Express Delivery');

  static String get selectDeliveryAddress =>
      _t(
        'اختاري عنوان التوصيل',
        'Select Delivery Address',
      );

  // ============================================================
  // الطلبات
  // ============================================================

  static String get myOrders =>
      _t('طلباتي', 'My Orders');

  static String get orderDetails =>
      _t('تفاصيل الطلب', 'Order Details');

  static String get orderNumber =>
      _t('رقم الطلب', 'Order Number');

  static String get orderDate =>
      _t('تاريخ الطلب', 'Order Date');

  static String get orderStatus =>
      _t('حالة الطلب', 'Order Status');

  static String get pending =>
      _t('قيد الانتظار', 'Pending');

  static String get processing =>
      _t('قيد التجهيز', 'Processing');

  static String get shipped =>
      _t('تم الشحن', 'Shipped');

  static String get delivered =>
      _t('تم التوصيل', 'Delivered');

  static String get cancelled =>
      _t('ملغي', 'Cancelled');

  static String get noOrders =>
      _t('لا توجد طلبات', 'No orders');

  // ============================================================
  // المفضلة
  // ============================================================

  static String get wishlist =>
      _t('قائمة الأمنيات', 'Wishlist');

  static String get favorites =>
      _t('المفضلة', 'Favorites');

  static String get noFavorites =>
      _t(
        'لا توجد منتجات في المفضلة',
        'No favorite products',
      );

  // ============================================================
  // حسابي
  // ============================================================

  static String get myAccount =>
      _t('حسابي', 'My Account');

  static String get accountInfo =>
      _t('معلومات الحساب', 'Account Info');

  static String get loyaltyPoints =>
      _t('نقاط الولاء', 'Loyalty Points');

  static String get myPrescriptions =>
      _t('وصفتي', 'My Prescriptions');

  static String get familyMembers =>
      _t('أفراد الأسرة', 'Family Members');

  // ============================================================
  // التفضيلات
  // ============================================================

  static String get preferences =>
      _t('تفضيلاتي', 'Preferences');

  static String get countryAndLanguage =>
      _t('الدولة واللغة', 'Country & Language');

  static String get country =>
      _t('الدولة', 'Country');

  static String get saudiArabia =>
      _t('السعودية', 'Saudi Arabia');

  // ============================================================
  // المساعدة والدعم
  // ============================================================

  static String get helpAndSupport =>
      _t('المساعدة والدعم', 'Help & Support');

  static String get deliveryInfo =>
      _t('معلومات التوصيل', 'Delivery Info');

  static String get faq =>
      _t('الأسئلة الشائعة', 'FAQ');

  static String get contactUs =>
      _t('اتصل بنا', 'Contact Us');

  static String get aboutCompany =>
      _t('عن الشركة', 'About Us');

  static String get privacyPolicy =>
      _t('سياسة الخصوصية', 'Privacy Policy');

  static String get termsConditions =>
      _t('الشروط والأحكام', 'Terms & Conditions');

  // ============================================================
  // الحساب
  // ============================================================

  static String get logout =>
      _t('تسجيل الخروج', 'Log Out');

  static String get deleteAccount =>
      _t('حذف الحساب', 'Delete Account');

  static String get logoutConfirmTitle =>
      _t('تسجيل الخروج', 'Log Out');

  static String get logoutConfirmBody =>
      _t(
        'هل تودين تسجيل الخروج من حسابك؟',
        'Are you sure you want to log out?',
      );

  static String get deleteConfirmTitle =>
      _t('حذف الحساب', 'Delete Account');

  static String get deleteConfirmBody =>
      _t(
        'سيتم حذف حسابك وكل بياناتك نهائياً. هل تودين المتابعة؟',
        'Your account and all your data will be permanently deleted. Continue?',
      );

  static String get deleteConfirmButton =>
      _t(
        'حذف نهائياً',
        'Delete Permanently',
      );

  // ============================================================
  // الرئيسية - العروض
  // ============================================================

  static String get expiringOffers =>
      _t(
        'عروض تنتهي قريباً',
        'Offers Ending Soon',
      );

  static String get noOffersCurrently =>
      _t(
        'لا توجد عروض حالياً',
        'No offers currently available',
      );

  // ============================================================
  // التواصل الاجتماعي
  // ============================================================

  static String get stayConnected =>
      _t(
        'ابقَي على تواصل معنا',
        'Stay Connected With Us',
      );

  // ============================================================
  // الشهادة الضريبية
  // ============================================================

  static String get vatCertificate =>
      _t(
        'شهادة ضريبة القيمة المضافة',
        'VAT Registration Certificate',
      );

  static String get tapForDetails =>
      _t(
        'صيدلية الأمل للأدوية — اضغطي للتفاصيل',
        'Alamal Pharmacy — Tap for details',
      );

  // ============================================================
  // الإصدار
  // ============================================================

  static String get version =>
      _t('الإصدار', 'Version');
}