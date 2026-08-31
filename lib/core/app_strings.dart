import '../services/locale_service.dart';

// كل نص هنا له نسخة عربي وإنجليزي.
// الشاشات تستخدم AppStrings.xxx
// بدل كتابة النص مباشرة، عشان يتحدث تلقائيًا مع تغيير اللغة.

class AppStrings {
  static String _t(String ar, String en) =>
      LocaleService.instance.isArabic ? ar : en;

  // =========================================================
  // حسابي
  // =========================================================

  static String get myAccount =>
      _t('حسابي', 'My Account');

  static String get accountInfo =>
      _t('معلومات الحساب', 'Account Info');

  static String get addresses =>
      _t('العناوين', 'Addresses');

  static String get wishlist =>
      _t('قائمة الأمنيات', 'Wishlist');

  static String get myOrders =>
      _t('طلباتي', 'My Orders');

  static String get loyaltyPoints =>
      _t('نقاط الولاء', 'Loyalty Points');

  static String get myPrescriptions =>
      _t('وصفتي', 'My Prescriptions');

  static String get familyMembers =>
      _t('أفراد الأسرة', 'Family Members');

  // =========================================================
  // تفضيلاتي
  // =========================================================

  static String get preferences =>
      _t('تفضيلاتي', 'Preferences');

  static String get countryAndLanguage =>
      _t('الدولة واللغة', 'Country & Language');

  static String get country =>
      _t('الدولة', 'Country');

  static String get language =>
      _t('اللغة', 'Language');

  static String get saudiArabia =>
      _t('السعودية', 'Saudi Arabia');

  static String get uae =>
      _t('الإمارات', 'UAE');

  static String get arabic =>
      _t('العربية', 'Arabic');

  static String get english =>
      _t('English', 'English');

  // =========================================================
  // المساعدة والدعم
  // =========================================================

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

  // =========================================================
  // الحساب
  // =========================================================

  static String get logout =>
      _t('تسجيل الخروج', 'Log Out');

  static String get deleteAccount =>
      _t('حذف الحساب', 'Delete Account');

  static String get login =>
      _t('تسجيل الدخول', 'Log In');

  static String get cancel =>
      _t('إلغاء', 'Cancel');

  static String get confirm =>
      _t('متابعة', 'Continue');

  // =========================================================
  // معلومات الشركة
  // =========================================================

  static String get stayConnected =>
      _t('ابقي على تواصل معنا', 'Stay Connected With Us');

  static String get vatCertificate =>
      _t('شهادة ضريبة القيمة المضافة',
          'VAT Registration Certificate');

  static String get tapForDetails =>
      _t(
        'صيدلية الأمل للأدوية — اضغطي للتفاصيل',
        'Alamal Pharmacy — Tap for details',
      );

  static String get version =>
      _t('الإصدار', 'Version');

  // =========================================================
  // تأكيد تسجيل الخروج وحذف الحساب
  // =========================================================

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
      _t('حذف نهائياً', 'Delete Permanently');

  // =========================================================
  // الرئيسية
  // =========================================================

  static String get loginOrCreateAccount =>
      _t(
        'تسجيل الدخول / إنشاء حساب',
        'Log In / Create Account',
      );

  static String get deliverToHome =>
      _t('التوصيل إلى المنزل', 'Deliver to Home');

  static String get pickupFromPharmacy =>
      _t('الاستلام من الصيدلية', 'Pickup from Pharmacy');

  static String deliverTo(String label) =>
      _t(
        'التوصيل إلى $label',
        'Deliver to $label',
      );

  static String get chooseNearestPharmacy =>
      _t(
        'اختاري أقرب صيدلية',
        'Choose nearest pharmacy',
      );

  static String get defaultAddress =>
      _t('العنوان الافتراضي', 'Default address');

  static String get searchHint =>
      _t(
        'ابحثي عن منتج أو دواء',
        'Search for a product or medicine',
      );

  static String get myOrdersShort =>
      _t('طلباتي', 'My Orders');

  static String get healthCare =>
      _t('العناية الصحية', 'Health Care');

  static String get medicalDevices =>
      _t('أجهزة طبية', 'Medical Devices');

  static String get uploadPrescription =>
      _t('رفع وصفة', 'Upload Prescription');

  static String get shopByCategory =>
      _t('تسوقي حسب الفئة', 'Shop by Category');

  static String get viewAll =>
      _t('عرض الكل', 'View All');

  static String get kids =>
      _t('الأطفال', 'Kids');

  static String get skinCare =>
      _t('العناية بالبشرة', 'Skin Care');

  static String get vitamins =>
      _t('الفيتامينات', 'Vitamins');

  static String get medicines =>
      _t('الأدوية', 'Medicines');

  static String get endingSoonOffers =>
      _t(
        'العروض التي تنتهي قريبًا',
        'Offers Ending Soon',
      );

  static String get searchResults =>
      _t('نتائج البحث', 'Search Results');

  static String get errorLoadingProducts =>
      _t(
        'حدث خطأ أثناء تحميل المنتجات',
        'Error loading products',
      );

  static String get noOffersNow =>
      _t(
        'لا توجد عروض حاليًا',
        'No offers right now',
      );

  static String get noProductsFound =>
      _t(
        'لم يتم العثور على منتجات',
        'No products found',
      );

  // =========================================================
  // إنشاء الحساب / تم إنشاء الحساب
  // =========================================================

  static String get accountCreated =>
      _t(
        'تم إنشاء حسابك بنجاح',
        'Account Created Successfully',
      );

  static String get accountCreatedSubtitle =>
      _t(
        'يمكنك الآن تسجيل الدخول والاستفادة من كل خدمات صيدلية الأمل',
        'You can now log in and enjoy all Alamal Pharmacy services',
      );

  static String get backToLogin =>
      _t(
        'عودة تسجيل الدخول',
        'Back to Login',
      );

  // =========================================================
  // شريط التنقل السفلي
  // =========================================================

  static String get shoppingCart =>
      _t('سلة التسوق', 'Cart');

  static String get home =>
      _t('الرئيسية', 'Home');

  static String get categories =>
      _t('الفئات', 'Categories');

  static String get offers =>
      _t('العروض', 'Offers');

  static String get error =>
      _t('حدث خطأ', 'Something went wrong');

  // =========================================================
  // تسجيل الدخول
  // =========================================================

  static String get loginFromCheckoutTitle =>
      _t(
        'سجّلي الدخول لإكمال الطلب',
        'Log in to complete your order',
      );

  static String get loginSubtitle =>
      _t(
        'سجّل دخولك للوصول إلى خدمات صيدلية الأمل',
        'Log in to access Alamal Pharmacy services',
      );

  static String get loginFromCheckoutSubtitle =>
      _t(
        'سجّلي دخولك عشان نكمل طلبك ونتواصل معك',
        'Log in so we can complete your order and reach you',
      );

  static String get phoneHint =>
      _t('رقم الجوال', 'Phone Number');

  static String get phoneRequired =>
      _t(
        'يرجى إدخال رقم الجوال',
        'Please enter your phone number',
      );

  static String get phoneInvalid =>
      _t(
        'أدخل رقم جوال سعودي صحيح',
        'Enter a valid Saudi phone number',
      );

  static String get passwordHint =>
      _t('كلمة المرور', 'Password');

  static String get passwordRequired =>
      _t(
        'يرجى إدخال كلمة المرور',
        'Please enter your password',
      );

  static String get passwordTooShort =>
      _t(
        'كلمة المرور يجب أن تكون 6 أحرف على الأقل',
        'Password must be at least 6 characters',
      );

  static String get forgotPassword =>
      _t(
        'نسيت كلمة المرور؟',
        'Forgot password?',
      );

  static String get orLoginVia =>
      _t('أو الدخول عبر', 'Or log in with');

  static String get noAccountYet =>
      _t(
        'ليس لديك حساب؟',
        "Don't have an account?",
      );

  static String get createAccount =>
      _t('إنشاء حساب', 'Create Account');

  static String get continueAsGuest =>
      _t('الدخول كضيف', 'Continue as Guest');

  static String get googleLoginComingSoon =>
      _t(
        'سيتم ربط الدخول عبر Google',
        'Google login coming soon',
      );

  static String get appleLoginComingSoon =>
      _t(
        'سيتم ربط الدخول عبر Apple',
        'Apple login coming soon',
      );

  // =========================================================
  // السلة
  // =========================================================

  static String get cartTitle =>
      _t('السلة', 'Cart');

  static String get emptyCartTitle =>
      _t('سلتك فارغة', 'Your cart is empty');

  static String get emptyCartSubtitle =>
      _t(
        'أضف منتجات لبدء التسوق',
        'Add products to start shopping',
      );

  static String get couponHint =>
      _t(
        'أدخل كود الخصم',
        'Enter discount code',
      );

  static String get apply =>
      _t('تطبيق', 'Apply');

  static String get subtotal =>
      _t('المجموع الفرعي', 'Subtotal');

  static String get taxLabel =>
      _t('الضريبة (15%)', 'Tax (15%)');

  static String get deliveryFeeLabel =>
      _t('رسوم التوصيل', 'Delivery Fee');

  static String get totalLabel =>
      _t('الإجمالي', 'Total');

  static String get checkout =>
      _t('إتمام الشراء', 'Checkout');

  static String get currency =>
      _t('ر.س', 'SAR');

  // =========================================================
  // الفئات
  // =========================================================

  static String get allCategories =>
      _t('جميع الفئات', 'All Categories');

  static String get motherAndBaby =>
      _t('الأم والطفل', 'Mother & Baby');

  static String get hairCare =>
      _t('العناية بالشعر', 'Hair Care');

  static String get perfumes =>
      _t('العطور', 'Perfumes');

  static String get handCare =>
      _t('عناية باليدين', 'Hand Care');

  static String get beauty =>
      _t('الجمال', 'Beauty');

  static String get homeCare =>
      _t('العناية بالمنزل', 'Home Care');

  static String get dailyCare =>
      _t('العناية اليومية', 'Daily Care');

  static String get sportsNutrition =>
      _t('التغذية الرياضية', 'Sports Nutrition');

  // =========================================================
  // إنشاء حساب
  // =========================================================

  static String get createAccountTitle =>
      _t(
        'إنشاء حساب جديد',
        'Create New Account',
      );

  static String get createAccountSubtitle =>
      _t(
        'أنشئ حسابك للوصول إلى خدمات صيدلية الأمل',
        'Create your account to access Alamal Pharmacy services',
      );

  static String get username =>
      _t('اسم المستخدم', 'Username');

  static String get usernameRequired =>
      _t(
        'يرجى إدخال اسم المستخدم',
        'Please enter your username',
      );

  static String get phoneNumber =>
      _t('رقم الجوال', 'Phone Number');

  static String get invalidSaudiPhone =>
      _t(
        'أدخل رقم جوال سعودي صحيح',
        'Enter a valid Saudi phone number',
      );

  static String get email =>
      _t('البريد الإلكتروني', 'Email');

  static String get emailRequired =>
      _t(
        'يرجى إدخال البريد الإلكتروني',
        'Please enter your email',
      );

  static String get invalidEmail =>
      _t(
        'البريد الإلكتروني غير صحيح',
        'Invalid email address',
      );

  static String get password =>
      _t('كلمة المرور', 'Password');

  static String get passwordMinLength =>
      _t(
        'كلمة المرور 8 أحرف على الأقل',
        'Password must be at least 8 characters',
      );

  static String get passwordMustContainLetterAndNumber =>
      _t(
        'استخدم حرفاً ورقماً على الأقل',
        'Use at least one letter and one number',
      );

  // =========================================================
  // تسجيل الدخول - أسماء إضافية
  // =========================================================

  static String get loginTitle =>
      _t('تسجيل الدخول', 'Log In');

  static String get loginToCompleteOrder =>
      _t(
        'سجّلي الدخول لإكمال الطلب',
        'Log in to complete your order',
      );

  static String get loginToContinueOrder =>
      _t(
        'سجّلي دخولك عشان نكمل طلبك ونتواصل معك',
        'Log in so we can complete your order and reach you',
      );

  static String get orContinueWith =>
      _t('أو الدخول عبر', 'Or continue with');

  static String get dontHaveAccount =>
      _t(
        'ليس لديك حساب؟',
        "Don't have an account?",
      );

  // =========================================================
  // نسيت كلمة المرور
  // =========================================================

  static String get forgotPasswordTitle =>
      _t(
        'نسيت كلمة المرور؟',
        'Forgot Password?',
      );

  static String get forgotPasswordSubtitle =>
      _t(
        'أدخلي رقم جوالك وسنرسل لك رمز التحقق',
        'Enter your phone number and we\'ll send you a verification code',
      );

  static String get sendCode =>
      _t('إرسال الرمز', 'Send Code');

  // =========================================================
  // العروض
  // =========================================================

  static String discountUpTo(int percent) =>
      _t(
        'خصومات تصل حتى $percent%',
        'Discounts up to $percent%',
      );

  static String get selectedProductsOffer =>
      _t(
        'على مجموعة مختارة من المنتجات',
        'On a selected range of products',
      );

  static String get offersEndIn =>
      _t(
        'العروض تنتهي خلال',
        'Offers end in',
      );

  static String get biggestDiscountToday =>
      _t(
        '🔥 أكبر خصم اليوم',
        '🔥 Biggest Discount Today',
      );

  static String get all =>
      _t('الكل', 'All');

  static String get mostDiscount =>
      _t('الأكثر خصمًا', 'Highest Discount');

  static String get priceLowToHigh =>
      _t(
        'السعر: من الأقل',
        'Price: Low to High',
      );

  static String get priceHighToLow =>
      _t(
        'السعر: من الأعلى',
        'Price: High to Low',
      );

  static String productsCount(int count) =>
      _t(
        '$count منتج',
        '$count products',
      );

  static String get noOffersInCategory =>
      _t(
        'لا توجد عروض في هذه الفئة',
        'No offers in this category',
      );

  // =========================================================
  // معلومات الحساب
  // =========================================================

  static String get fullName =>
      _t('الاسم الكامل', 'Full Name');

  static String get optional =>
      _t('اختياري', 'Optional');

  static String get changesSaved =>
      _t(
        'تم حفظ التعديلات',
        'Changes saved successfully',
      );

  static String get saveChanges =>
      _t(
        'حفظ التعديلات',
        'Save Changes',
      );
}

