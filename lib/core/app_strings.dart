import '../services/locale_service.dart';

// كل نص هنا له نسخة عربي وإنجليزي.
// الشاشات تستخدم AppStrings.xxx
// بدل كتابة النص مباشرة، عشان يتحدث تلقائيًا مع تغيير اللغة.

class AppStrings {
  static String _t(String ar, String en) =>
      LocaleService.instance.isArabic ? ar : en;

  // =========================================================
  // عام
  // =========================================================

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
      _t('حدث خطأ', 'Something went wrong');

  static String get noResults =>
      _t('لا توجد نتائج', 'No results found');

  static String get requiredField =>
      _t('هذا الحقل مطلوب', 'This field is required');

  // =========================================================
  // Google Login - رسائل المصادقة
  // =========================================================

  static String get googleIdTokenError =>
      _t(
        'تعذر الحصول على Google ID Token.',
        'Unable to get Google ID Token.',
      );

  static String get backendInvalidResponse =>
      _t(
        'استجابة الباكند غير صحيحة.',
        'Invalid backend response.',
      );

  static String get googleLoginFailed =>
      _t(
        'فشل تسجيل الدخول بواسطة Google.',
        'Google sign-in failed.',
      );

  static String get googleLoginCanceled =>
      _t(
        'تم إلغاء تسجيل الدخول.',
        'Sign-in was canceled.',
      );

  static String get googleLoginError =>
      _t(
        'حدث خطأ أثناء تسجيل الدخول بواسطة Google.',
        'An error occurred while signing in with Google.',
      );

  static String get authConnectionError =>
      _t(
        'حدث خطأ أثناء الاتصال بالخدمة.',
        'An error occurred while connecting to the service.',
      );

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

  // =========================================================
  // معلومات الشركة
  // =========================================================

  static String get stayConnected =>
      _t('ابقي على تواصل معنا', 'Stay Connected With Us');

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
  // التحقق من الرمز
  // =========================================================

  static String get verifyCodeTitle =>
      _t(
        'التحقق من الرمز',
        'Verify Code',
      );

  static String get verifyCodeSubtitle =>
      _t(
        'أدخل رمز التحقق المرسل إلى',
        'Enter the verification code sent to',
      );

  static String get didNotReceiveCode =>
      _t(
        'لم يصلك الرمز؟ إعادة الإرسال خلال',
        'Didn\'t receive the code? Resend in',
      );

  static String get resendCode =>
      _t(
        'إعادة إرسال الرمز',
        'Resend Code',
      );

  static String get verify =>
      _t(
        'تحقق',
        'Verify',
      );

  static String get codeResent =>
      _t(
        'تم إرسال رمز جديد',
        'A new code has been sent',
      );

  static String get enterFullCode =>
      _t(
        'أدخل رمز التحقق كاملًا',
        'Please enter the complete verification code',
      );

  // =========================================================
  // إعادة تعيين كلمة المرور
  // =========================================================

  static String get resetPasswordTitle =>
      _t(
        'إعادة تعيين كلمة السر',
        'Reset Password',
      );

  static String get resetPasswordSubtitle =>
      _t(
        'أدخل كلمة سر جديدة لحسابك',
        'Enter a new password for your account',
      );

  static String get newPassword =>
      _t(
        'كلمة المرور الجديدة',
        'New Password',
      );

  static String get confirmPassword =>
      _t(
        'تأكيد كلمة المرور',
        'Confirm Password',
      );

  static String get confirmPasswordRequired =>
      _t(
        'يرجى تأكيد كلمة المرور',
        'Please confirm your password',
      );

  static String get passwordsDoNotMatch =>
      _t(
        'كلمتا المرور غير متطابقتين',
        'Passwords do not match',
      );

  static String get savePassword =>
      _t(
        'حفظ كلمة السر',
        'Save Password',
      );

  // =========================================================
  // نجاح تغيير كلمة المرور
  // =========================================================

  static String get passwordResetSuccessTitle =>
      _t(
        'تم إنشاء كلمة السر بنجاح',
        'Password created successfully',
      );

  static String get passwordResetSuccessSubtitle =>
      _t(
        'يمكنك الآن تسجيل الدخول بكلمة السر الجديدة',
        'You can now log in with your new password',
      );

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

  // =========================================================
  // المنتجات حسب الفئة
  // =========================================================

  static String get noProductsInCategory =>
      _t(
        'لا توجد منتجات حالياً في هذه الفئة',
        'No products currently available in this category',
      );

  // =========================================================
  // الاستلام من الفرع
  // =========================================================

  static String get pickupFromBranch =>
      _t(
        'استلام من الفرع',
        'Pickup from Branch',
      );

  static String get nearbyPharmacies =>
      _t(
        'الصيدليات القريبة منك',
        'Nearby Pharmacies',
      );

  static String get optionalNote =>
      _t(
        'هل تحتاجين ملاحظة؟ (اختياري)',
        'Need a note? (Optional)',
      );

  static String get noteHint =>
      _t(
        'مثال: اتصل قبل الوصول',
        'Example: Call before arrival',
      );

  static String get totalOrder =>
      _t(
        'إجمالي الطلب',
        'Order Total',
      );

  static String get confirmBranch =>
      _t(
        'تأكيد الفرع',
        'Confirm Branch',
      );

  // =========================================================
  // فروع الصيدلية
  // =========================================================

  static String get branchSafa =>
      _t(
        'فرع الصفا',
        'Al Safa Branch',
      );

  static String get branchSafaAddress =>
      _t(
        'حي السويس، شارع الأمير سلطان',
        'Al-Suwais District, Prince Sultan Street',
      );

  static String get branchRawdah =>
      _t(
        'فرع الروضة',
        'Al Rawdah Branch',
      );

  static String get branchRawdahAddress =>
      _t(
        'حي الروضة، جازان',
        'Al Rawdah District, Jazan',
      );

  static String get branchBeach =>
      _t(
        'فرع الشاطئ',
        'Al Shati Branch',
      );

  static String get branchBeachAddress =>
      _t(
        'حي الشاطئ، جازان',
        'Al Shati District, Jazan',
      );

  static String distanceKm(double distance) {
    final formatted = distance.toStringAsFixed(2);

    return _t(
      '$formatted كم',
      '$formatted km',
    );
  }

  // =========================================================
  // معلومات التوصيل
  // =========================================================

  static String get deliveryDuration =>
      _t(
        'مدة التوصيل',
        'Delivery Duration',
      );

  static String get deliveryDurationBody =>
      _t(
        'تاريخ عملية الشحن يعتمد على طلب الشراء الخاص بك، من ناحية المدينة وطريقة الدفع. يرجى الملاحظة أن طلبات الحجز غير مدرجة ضمن الوقت القياسي للشحن الملخص أدناه.\n\n'
        'الحد الأقصى للتوصيل هو 7 أيام عمل للطلبات خارج نطاق تواجدنا، أما في المدن المتواجدين فيها كجازان وأبها وخميس مشيط فإن مدة التوصيل من ساعتين إلى يومي عمل، ويتوقف ذلك على نوعية الأصناف وكمياتها.\n\n'
        'وقت التوصيل يتم بالتقدير وليس مضمونًا. لمراجعة تاريخ ووقت التوصيل المقدّر يرجى مراجعة صفحة المنتج، حيث يتم تحديثها بانتظام بالاعتماد على أحدث المعلومات.',
        'Delivery time depends on your order, including the city and payment method. Please note that reservation orders are not included in the standard shipping time mentioned below.\n\n'
        'The maximum delivery time is 7 business days for orders outside our service areas. In cities where we operate, such as Jazan, Abha, and Khamis Mushait, delivery usually takes from two hours to two business days, depending on the type and quantity of products.\n\n'
        'Delivery time is an estimate and is not guaranteed. To check the estimated delivery date and time, please review the product page, which is regularly updated based on the latest information.',
      );

  static String get deliverySchedule =>
      _t(
        'تنسيق موعد التوصيل',
        'Delivery Scheduling',
      );

  static String get deliveryScheduleBody =>
      _t(
        'يعتمد التوصيل على قبول العميل وتحديد موعد التوصيل مع فريق صيدلية الأمل أو شركات الشحن الأخرى. في حال تعذّر الاتصال بالعميل بالموعد المحدد، قد يحصل تأخير في توصيل الشحنة دون أدنى مسؤولية على شركة الأمل.',
        'Delivery depends on the customer accepting and scheduling a delivery time with Alamal Pharmacy or other shipping companies. If the customer cannot be reached at the scheduled time, delivery may be delayed without any responsibility on Alamal.',
      );

  static String get freeDelivery =>
      _t(
        'التوصيل المجاني',
        'Free Delivery',
      );

  static String get freeDeliveryBody =>
      _t(
        'تتكفل صيدليات الأمل بخدمة التوصيل المجاني للطلبات التي تبلغ 199 ريالًا وأكثر.',
        'Alamal Pharmacies provides free delivery for orders of SAR 199 or more.',
      );

  static String get coverageArea =>
      _t(
        'نطاق التغطية',
        'Coverage Area',
      );

  static String get coverageAreaBody =>
      _t(
        'يرجى الملاحظة أن طلبات الشراء التي يكون مكان إقامة العميل فيها غير محدد ضمن قائمة المدن والأحياء في عنوان الشحن، يحق لصيدليات الأمل إلغاؤها مباشرة.\n\n'
        'إذا تم طلب الشراء لمنتجات كبيرة وصغيرة معًا، فقد يتم توصيلها للمكان المحدد لكن بشحنات مختلفة وأوقات مختلفة.',
        'Please note that Alamal Pharmacies may directly cancel orders when the customer’s location is not included in the list of cities and districts available in the shipping address.\n\n'
        'If an order contains both large and small products, they may be delivered to the specified location in separate shipments and at different times.',
      );

  static String get pickupFromPharmacyTitle =>
      _t(
        'الاستلام من الصيدلية',
        'Pickup from Pharmacy',
      );

  static String get pickupFromPharmacyBody =>
      _t(
        'لا تريدين انتظار التوصيل؟ استلمي من الصيدلية!\n\n'
        'ببساطة اطلبي المنتج من التطبيق واختاري "استلام من الصيدلية" كخيار للتوصيل، وسنقوم بتجهيز طلبك لاستلامه من الفرع الذي تم اختياره.\n\n'
        'الخدمة متاحة في جميع صيدليات الأمل في حال توفر المنتجات، وسيصلك إشعار عند جاهزية طلبك للاستلام.\n\n'
        'يمكن الدفع في الصيدلية عند استلام الطلب، أو عبر التطبيق عند إنشاء الطلب.',
        'Don’t want to wait for delivery? Pick up your order from the pharmacy!\n\n'
        'Simply order the product through the app and select "Pickup from Pharmacy" as your delivery option. We will prepare your order for pickup at the selected branch.\n\n'
        'The service is available at all Alamal Pharmacies subject to product availability. You will receive a notification when your order is ready for pickup.\n\n'
        'You can pay at the pharmacy when collecting your order, or through the app when placing the order.',
      );

  // =========================================================
  // طرق الدفع
  // =========================================================

  static String get paymentMethod =>
      _t(
        'طريقة الدفع',
        'Payment Method',
      );

  static String get choosePaymentMethod =>
      _t(
        'اختاري طريقة الدفع',
        'Choose a payment method',
      );

  static String get cashOnDelivery =>
      _t(
        'الدفع عند الاستلام',
        'Cash on Delivery',
      );

  static String get cardPayment =>
      _t(
        'الدفع بالبطاقة',
        'Card Payment',
      );

  static String get applePay =>
      _t(
        'Apple Pay',
        'Apple Pay',
      );

  static String get mada =>
      _t(
        'مدى',
        'Mada',
      );

  static String get payNow =>
      _t(
        'ادفعي الآن',
        'Pay Now',
      );

  // =========================================================
  // الطلب
  // =========================================================

  static String get orderConfirmed =>
      _t(
        'تم تأكيد طلبك',
        'Your order has been confirmed',
      );

  static String get orderNumber =>
      _t(
        'رقم الطلب',
        'Order Number',
      );

  static String get orderDetails =>
      _t(
        'تفاصيل الطلب',
        'Order Details',
      );

  static String get orderStatus =>
      _t(
        'حالة الطلب',
        'Order Status',
      );

  static String get continueShopping =>
      _t(
        'متابعة التسوق',
        'Continue Shopping',
      );

  // =========================================================
  // العناوين
  // =========================================================

  static String get addAddress =>
      _t(
        'إضافة عنوان',
        'Add Address',
      );

  static String get editAddress =>
      _t(
        'تعديل العنوان',
        'Edit Address',
      );

  static String get addressDetails =>
      _t(
        'تفاصيل العنوان',
        'Address Details',
      );

  static String get addressName =>
      _t(
        'اسم العنوان',
        'Address Name',
      );

  static String get homeAddress =>
      _t(
        'المنزل',
        'Home',
      );

  static String get workAddress =>
      _t(
        'العمل',
        'Work',
      );

  static String get saveAddress =>
      _t(
        'حفظ العنوان',
        'Save Address',
      );

  // =========================================================
  // الفئات الإضافية
  // =========================================================

  static String get categoryMedicines =>
      _t(
        'الأدوية',
        'Medicines',
      );

  static String get categoryHealthCare =>
      _t(
        'العناية الصحية',
        'Health Care',
      );

  static String get categoryMedicalDevices =>
      _t(
        'أدوات طبية',
        'Medical Devices',
      );

  static String get categorySkinCare =>
      _t(
        'العناية بالبشرة',
        'Skin Care',
      );

  static String get categoryVitamins =>
      _t(
        'الفيتامينات',
        'Vitamins',
      );

  static String get categoryKids =>
      _t(
        'الأطفال',
        'Kids',
      );

  static String get contactInformation =>
      _t(
        'معلومات الاتصال',
        'Contact Information',
      );

  static String get workingHours =>
      _t(
        'الأحد - الخميس، من 10 صباحًا حتى 6 مساءً',
        'Sunday - Thursday, from 10 AM to 6 PM',
      );

  static String get unableToOpenApp =>
      _t(
        'تعذر فتح التطبيق المطلوب',
        'Unable to open the required app',
      );

  static String get deliveryAppointment =>
      _t(
        'موعد التوصيل',
        'Delivery Appointment',
      );

  static String get chooseDay =>
      _t(
        'اختاري اليوم',
        'Choose a day',
      );

  static String get chooseDeliveryDayDescription =>
      _t(
        'حددي اليوم المناسب لاستلام طلبك',
        'Select a convenient day to receive your order',
      );

  static String get chooseTime =>
      _t(
        'اختاري الوقت',
        'Choose a time',
      );

  static String get chooseDeliveryTimeDescription =>
      _t(
        'اختاري الفترة المناسبة لتوصيل طلبك',
        'Select a convenient delivery time',
      );

  static String get selectedDeliveryDay =>
      _t(
        'موعد التوصيل المحدد',
        'Selected delivery date',
      );

  static String get deliverySummary =>
      _t(
        'ملخص موعد التوصيل',
        'Delivery appointment summary',
      );

  static String get confirmAppointment =>
      _t(
        'تأكيد الموعد',
        'Confirm appointment',
      );

  static String get selectDeliveryTime =>
      _t(
        'يرجى اختيار وقت التوصيل',
        'Please select a delivery time',
      );

  static String get noDeliveryTimes =>
      _t(
        'لا توجد أوقات توصيل متاحة لهذا اليوم',
        'No delivery times are available for this day',
      );

  static String get full =>
      _t(
        'ممتلئ',
        'Fully booked',
      );

  static String get today =>
      _t(
        'اليوم',
        'Today',
      );

  static String get monday =>
      _t(
        'الاثنين',
        'Monday',
      );

  static String get tuesday =>
      _t(
        'الثلاثاء',
        'Tuesday',
      );

  static String get wednesday =>
      _t(
        'الأربعاء',
        'Wednesday',
      );

  static String get thursday =>
      _t(
        'الخميس',
        'Thursday',
      );

  static String get friday =>
      _t(
        'الجمعة',
        'Friday',
      );

  static String get saturday =>
      _t(
        'السبت',
        'Saturday',
      );

  static String get sunday =>
      _t(
        'الأحد',
        'Sunday',
      );

  static String get january =>
      _t(
        'يناير',
        'January',
      );

  static String get february =>
      _t(
        'فبراير',
        'February',
      );

  static String get march =>
      _t(
        'مارس',
        'March',
      );

  static String get april =>
      _t(
        'أبريل',
        'April',
      );

  static String get may =>
      _t(
        'مايو',
        'May',
      );

  static String get june =>
      _t(
        'يونيو',
        'June',
      );

  static String get july =>
      _t(
        'يوليو',
        'July',
      );

  static String get august =>
      _t(
        'أغسطس',
        'August',
      );

  static String get september =>
      _t(
        'سبتمبر',
        'September',
      );

  static String get october =>
      _t(
        'أكتوبر',
        'October',
      );

  static String get november =>
      _t(
        'نوفمبر',
        'November',
      );

  static String get december =>
      _t(
        'ديسمبر',
        'December',
      );

  // =========================================================
  // طرق الدفع الإضافية
  // =========================================================

  static String get visaMastercard =>
      _t(
        'فيزا / ماستركارد',
        'Visa / Mastercard',
      );

  static String get tamara =>
      _t(
        'تمارا',
        'Tamara',
      );

  static String get tabby =>
      _t(
        'تابي',
        'Tabby',
      );

  static String get internalWallet =>
      _t(
        'المحفظة الداخلية',
        'Internal Wallet',
      );

  static String get confirmPayment =>
      _t(
        'تأكيد الدفع',
        'Confirm Payment',
      );

  // =========================================================
  // سياسة الخصوصية
  // =========================================================

  static String get privacyIntro =>
      _t(
        'نحن على علم بمسؤوليتنا تجاه حماية معلوماتك الشخصية ونأخذ هذا الأمر بجدية تامة. نقوم بتخزين ومعالجة معلوماتك الشخصية من خلال خوادمنا المحمية بأجهزة وبرامج ذات تقنية أمنية عالية.\n\n'
        'في حال اعتراضك على معالجتنا لمعلوماتك الشخصية، يمكنك إرسال طلبك إلى admin@alamalph.com أو تجنب استخدام خدمات التطبيق.',
        'We understand our responsibility to protect your personal information and take this matter very seriously. We store and process your personal information through our servers, which are protected by advanced security hardware and software.\n\n'
        'If you object to the way we process your personal information, you may contact us at admin@alamalph.com or choose not to use the application services.',
      );

  static String get privacyRegistrationTitle =>
      _t(
        'التسجيل — حسابي الشخصي',
        'Registration — My Account',
      );

  static String get privacyRegistrationBody =>
      _t(
        'تتضمن عملية التسجيل معلوماتك الشخصية التي تزودنا بها لإتمام معاملاتك وللتواصل معك. تشكل هذه المعلومات جزءًا من سجلك الخاص لتعاملاتك مع خدماتنا.\n\n'
        'أنتِ مسؤولة عن المحافظة على سرية حسابك الشخصي وكلمة المرور، وعن جميع العمليات التي تتم من خلال حسابك. في حال الشك بوجود عمليات مشبوهة، يرجى إخطارنا فورًا.',
        'The registration process includes the personal information you provide to complete your transactions and communicate with you. This information forms part of your personal record of interactions with our services.\n\n'
        'You are responsible for maintaining the confidentiality of your account and password, as well as for all activities carried out through your account. If you suspect any suspicious activity, please notify us immediately.',
      );

  static String get privacyDeleteTitle =>
      _t(
        'إلغاء حسابك الشخصي',
        'Deleting Your Account',
      );

  static String get privacyDeleteBody =>
      _t(
        'تستطيعين في أي وقت إلغاء وحذف حسابك الشخصي، كما يحق لنا حذف الحساب في أي وقت إذا تأكدنا أنه احتيالي أو أن استخدامه لا يتوافق مع سياسة الخصوصية وشروط الاستخدام لدينا.',
        'You may cancel and delete your personal account at any time. We also reserve the right to delete an account if we determine that it is fraudulent or that its use does not comply with our Privacy Policy and Terms of Use.',
      );

  static String get privacyElectronicTitle =>
      _t(
        'التواصل الإلكتروني',
        'Electronic Communications',
      );

  static String get privacyElectronicBody =>
      _t(
        'باستخدامك للتطبيق وخدماتنا الإلكترونية، فإنك توافقين على استقبال رسائلنا الإلكترونية بجميع أشكالها (بريد إلكتروني، نشرات دورية، إشعارات). يمكنك إلغاء استلام الرسائل الترويجية بالضغط على خيار إلغاء الاشتراك المتوفر أسفل الرسائل.\n\n'
        'يحق لنا مراقبة وتسجيل وحفظ أي تواصل معك لأغراض تدريبية بهدف تحسين جودة الخدمة المقدمة.',
        'By using the application and our electronic services, you agree to receive our electronic communications in all forms, including emails, newsletters, and notifications. You may unsubscribe from promotional messages by selecting the unsubscribe option available at the bottom of the messages.\n\n'
        'We may monitor, record, and retain communications with you for training purposes in order to improve the quality of the service provided.',
      );

  static String get privacyCookiesTitle =>
      _t(
        'ملفات السجل وملفات تعريف الارتباط',
        'Log Files & Cookies',
      );

  static String get privacyCookiesBody =>
      _t(
        'نقوم بجمع بيانات تشمل عنوان بروتوكول الإنترنت (IP) الخاص بك، ومزود خدمة الإنترنت، والمتصفح المستخدم، ووقت وصفحات الزيارة.\n\n'
        'نستخدم ملفات تعريف الارتباط (Cookies) لتحسين تجربة الاستخدام وتخصيصها، مثل حفظ تفضيلاتك الشخصية وتسجيل الدخول التلقائي لبعض الميزات.',
        'We collect data including your Internet Protocol (IP) address, Internet service provider, browser type, visit time, and the pages you visit.\n\n'
        'We use cookies to improve and personalize your experience, such as saving your preferences and automatically signing you in to certain features.',
      );

  static String get privacyContactTitle =>
      _t(
        'للتواصل معنا',
        'Contact Us',
      );

  static String get privacyContactBody =>
      _t(
        'إن كانت لديك أي استفسارات بخصوص سياسة الخصوصية، يمكنك التواصل معنا عبر:\n\n'
        'البريد الإلكتروني: admin@alamalph.com\n\n'
        'العنوان: مدينة جازان، المنطقة الصناعية، جازان 82511، المملكة العربية السعودية.',
        'If you have any questions regarding our Privacy Policy, you can contact us through:\n\n'
        'Email: admin@alamalph.com\n\n'
        'Address: Jazan City, Industrial Area, Jazan 82511, Saudi Arabia.',
      );

  // =========================================================
  // المنتج
  // =========================================================

  static String get productDescription =>
      _t('الوصف', 'Description');

  static String get productDescriptionBody =>
      _t(
        'سيتم إضافة وصف تفصيلي لهذا المنتج قريباً.',
        'A detailed description for this product will be added soon.',
      );

  static String get quantity =>
      _t('الكمية', 'Quantity');

  static String get addToCart =>
      _t('أضيفي للسلة', 'Add to Cart');

  static String addedToCart(int quantity, String productName) =>
      _t(
        'تمت إضافة $quantity × $productName للسلة',
        '$quantity × $productName has been added to your cart',
      );

  // =========================================================
  // الشروط والأحكام
  // =========================================================

  static String get termsIntro =>
      _t(
        'أهلاً بكم في تطبيق صيدليات الأمل الإلكتروني. باستخدامك للتطبيق فإنك تقرّين وتوافقين على أنك قرأتِ وفهمتِ بنود وأحكام هذه الاتفاقية وطريقة استخدام التطبيق، وأنك بكامل الأهلية المعتبرة شرعًا وقانونًا.\n\n'
        'هذه الشروط قابلة للتعديل من قبلنا في أي وقت، واستمرار استخدامك للتطبيق بعد نشر أي تغيير يعني موافقتك على الشروط المعدّلة.',
        'Welcome to Alamal Pharmacies electronic application. By using the application, you acknowledge and agree that you have read and understood the terms and conditions of this agreement and how to use the application, and that you have the full legal capacity required by law.\n\n'
        'These terms may be amended by us at any time. Your continued use of the application after any changes are published means that you accept the amended terms.',
      );

  static String get termsRegistrationTitle =>
      _t('شروط التسجيل', 'Registration Requirements');

  static String get termsRegistrationBody =>
      _t(
        '• أن تكوني بالغة السن القانونية (18 عامًا) لتتمكني من شراء المنتجات.\n'
        '• أن تكوني قادرة على تقديم عنوان داخل المملكة العربية السعودية لتسليم المنتجات.\n'
        '• لا يحق لأي شخص استخدام التطبيق إذا أُلغيت عضويته من قبل صيدلية الأمل.\n'
        '• لا يحق لأي عميل استخدام بريد إلكتروني واحد أو رقم جوال واحد لفتح أكثر من حساب.',
        '• You must be of legal age (18 years or older) to purchase products.\n'
        '• You must be able to provide an address within the Kingdom of Saudi Arabia for product delivery.\n'
        '• No person may use the application if their membership has been cancelled by Alamal Pharmacy.\n'
        '• A customer may not use the same email address or mobile number to create more than one account.',
      );

  static String get termsCustomerTitle =>
      _t('التزامات العميل', 'Customer Obligations');

  static String get termsCustomerBody =>
      _t(
        '• المحافظة على سرية حسابك وكلمة المرور، وتحمل مسؤولية جميع الأنشطة التي تتم من خلاله.\n'
        '• إخطارنا فورًا عن أي استخدام غير مصرح به لحسابك.\n'
        '• تقديم معلومات كاملة وحقيقية ودقيقة عن نفسك.\n'
        '• عدم استخدام التطبيق بما يخالف الأنظمة والقوانين المعمول بها في المملكة العربية السعودية.',
        '• Maintain the confidentiality of your account and password and take responsibility for all activities carried out through your account.\n'
        '• Notify us immediately of any unauthorized use of your account.\n'
        '• Provide complete, truthful, and accurate information about yourself.\n'
        '• Do not use the application in violation of the laws and regulations applicable in the Kingdom of Saudi Arabia.',
      );

  static String get termsPaymentTitle =>
      _t('الدفع', 'Payment');

  static String get termsPaymentBody =>
      _t(
        'يوفر التطبيق إمكانية الدفع عند الاستلام أو عبر الإنترنت. جميع عمليات الدفع تتم بالريال السعودي، ويتم قبول البطاقات الائتمانية الصادرة من بنوك سعودية عبر بوابة الدفع الإلكترونية المعتمدة.\n\n'
        'نحن لا نقوم بتخزين معلومات بطاقتك الائتمانية على التطبيق، وجميع البيانات المدخلة عبر بوابة الدفع يتم تشفيرها لأغراض الحماية الأمنية.',
        'The application provides payment by cash on delivery or online. All payments are made in Saudi Riyals, and credit cards issued by Saudi banks are accepted through the approved electronic payment gateway.\n\n'
        'We do not store your credit card information in the application. All data entered through the payment gateway is encrypted for security purposes.',
      );

  static String get termsMedicineTitle =>
      _t(
        'تنبيه هام حول منتجات الأدوية',
        'Important Notice About Medicines',
      );

  static String get termsMedicineBody =>
      _t(
        'يجب استشارة الطبيب المختص حول كيفية استخدام الأدوية. لا نبيع الأدوية التي تتطلب وصفة طبية إلا بوصفة، ويحق لنا إيقاف أي طلب نتأكد أنه كميات بيع وليست كميات استخدام.',
        'You should consult a qualified physician regarding the proper use of medicines. We do not sell prescription medicines without a valid prescription, and we reserve the right to stop any order if we determine that the quantities are intended for resale rather than personal use.',
      );

  static String get termsCancelOrderTitle =>
      _t('إلغاء الطلب', 'Order Cancellation');

  static String get termsCancelOrderBody =>
      _t(
        'يحق لصيدلية الأمل إلغاء الطلب في حال: رفض عملية الدفع، تأخر العميل عن الدفع لأكثر من 12 ساعة، خطأ في عنوان التوصيل أو معلومات الاتصال، أو عدم استلام الطلب خلال المدة المحددة.\n\n'
        'يحق للعميل إلغاء طلبه قبل شحنه بالتواصل معنا مباشرة.',
        'Alamal Pharmacy reserves the right to cancel an order in cases including: payment rejection, failure to complete payment within 12 hours, an incorrect delivery address or contact information, or failure to receive the order within the specified period.\n\n'
        'The customer may cancel an order before it is shipped by contacting us directly.',
      );

  static String get termsReturnTitle =>
      _t(
        'الاسترجاع والاستبدال ورد المدفوعات',
        'Returns, Exchanges & Refunds',
      );

  static String get termsReturnBody =>
      _t(
        'في حال عدم رضاك عن المنتج أو وجود خلل فيه، يمكنك خلال 3 أيام من الاستلام طلب إعادة المنتج، ولن يتم رد المبلغ إلا بعد استلامنا للمنتج وفحص حالته.\n\n'
        'استثناءات لا تُرجع أو تُستبدل: منتجات الصحة والجمال (أجهزة حلاقة، عناية بالفم والأسنان)، الأصناف التي تحتاج تبريدًا (كالإنسولين)، أصناف درجة الحرارة الثابتة (حليب وأكل الأطفال)، والمنتجات المصروفة عبر التأمين الطبي.',
        'If you are not satisfied with a product or if it has a defect, you may request a return within 3 days of receiving it. A refund will only be issued after we receive the product and inspect its condition.\n\n'
        'Non-returnable or non-exchangeable items include: health and beauty products (such as shaving devices and oral and dental care products), products requiring refrigeration (such as insulin), temperature-sensitive products (such as infant formula and baby food), and products dispensed through medical insurance.',
      );

  static String get termsWarrantyTitle =>
      _t('الضمان', 'Warranty');

  static String get termsWarrantyBody =>
      _t(
        'يكون الضمان فقط للأجهزة الطبية حسب ضمان الوكيل.',
        'Warranty applies only to medical devices according to the manufacturer or authorized distributor warranty.',
      );

  static String get termsLawTitle =>
      _t('القانون المنظم', 'Governing Law');

  static String get termsLawBody =>
      _t(
        'تخضع جميع شروط الخدمة وتُفسر وفقًا للقوانين المعمول بها في المملكة العربية السعودية، وفي حال نشوء أي نزاع يتم اللجوء للتحكيم.',
        'All terms of service are governed by and interpreted in accordance with the laws applicable in the Kingdom of Saudi Arabia. In the event of any dispute, the matter shall be referred to arbitration.',
      );

  static String get termsContactTitle =>
      _t('للتواصل معنا', 'Contact Us');

  static String get termsContactBody =>
      _t(
        'البريد الإلكتروني: admin@alamalph.com\n\n'
        'العنوان: مدينة جازان، المنطقة الصناعية، جازان 82511، المملكة العربية السعودية.',
        'Email: admin@alamalph.com\n\n'
        'Address: Jazan City, Industrial Area, Jazan 82511, Saudi Arabia.',
      );

  // =========================================================
  // وصفتي
  // =========================================================

  static String get wasfaty =>
      _t('وصفتي', 'My Prescription');

  static String get prescriptionDescription =>
      _t(
        'ارفعي صورة واضحة لوصفتك الطبية وسيقوم فريقنا بمراجعتها وتجهيز طلبك',
        'Upload a clear photo of your prescription and our team will review it and prepare your order.',
      );

  static String get takePrescriptionPhoto =>
      _t(
        'التقاط صورة بالكاميرا',
        'Take a Photo with Camera',
      );

  static String get chooseFromGallery =>
      _t(
        'اختيار من المعرض',
        'Choose from Gallery',
      );

  static String get attachPrescription =>
      _t(
        'اضغطي لإرفاق صورة الوصفة',
        'Tap to Attach Prescription',
      );

  static String get cameraOrGallery =>
      _t(
        'كاميرا أو من المعرض',
        'Camera or Gallery',
      );

  static String get paymentMethodTitle =>
      _t(
        'طريقة الدفع',
        'Payment Method',
      );

  static String get cashPayment =>
      _t(
        'نقدي',
        'Cash',
      );

  static String get medicalInsurance =>
      _t(
        'تأمين طبي',
        'Medical Insurance',
      );

  static String get insuranceInformation =>
      _t(
        'بيانات التأمين',
        'Insurance Information',
      );

  static String get selectInsuranceCompany =>
      _t(
        'اختاري شركة التأمين',
        'Select Insurance Company',
      );

  static String get insuranceMembershipNumber =>
      _t(
        'رقم العضوية / الوثيقة التأمينية',
        'Membership / Insurance Policy Number',
      );

  static String get idOrIqamaNumber =>
      _t(
        'رقم الهوية / الإقامة',
        'National ID / Iqama Number',
      );

  static String get insuranceVerificationNotice =>
      _t(
        'سيتم التحقق من تغطية التأمين قبل تجهيز الطلب',
        'Your insurance coverage will be verified before preparing the order.',
      );

  static String get additionalNotesOptional =>
      _t(
        'ملاحظات إضافية (اختياري)',
        'Additional Notes (Optional)',
      );

  static String get prescriptionNoteHint =>
      _t(
        'مثال: أحتاج توصيل بسرعة',
        'Example: I need fast delivery',
      );

  static String get sendPrescription =>
      _t(
        'إرسال الوصفة',
        'Submit Prescription',
      );

  static String get prescriptionSentSuccessfully =>
      _t(
        'تم إرسال وصفتك بنجاح',
        'Your prescription has been submitted successfully',
      );

  static String get insuranceCoverageCheckingMessage =>
      _t(
        'سيتم التحقق من التغطية التأمينية والتواصل معك',
        'Your insurance coverage will be verified and we will contact you.',
      );

  static String get prescriptionReviewMessage =>
      _t(
        'سيتم مراجعتها والتواصل معك قريباً',
        'Your prescription will be reviewed and we will contact you soon.',
      );

  static String get doneButton =>
      _t(
        'تم',
        'Done',
      );

  static String get attachPrescriptionFirst =>
      _t(
        'الرجاء إرفاق صورة الوصفة أولاً',
        'Please attach a prescription photo first.',
      );

  static String get selectInsuranceFirst =>
      _t(
        'الرجاء اختيار شركة التأمين',
        'Please select an insurance company.',
      );

  static String get completeInsuranceData =>
      _t(
        'الرجاء تعبئة بيانات التأمين كاملة',
        'Please complete all insurance information.',
      );

  static String get insuranceBupa =>
      _t(
        'بوبا العربية',
        'Bupa Arabia',
      );

  static String get insuranceTawuniya =>
      _t(
        'التعاونية',
        'Tawuniya',
      );

  static String get insuranceMedgulf =>
      _t(
        'ميدغلف',
        'MedGulf',
      );

  static String get insuranceWalaa =>
      _t(
        'ولاء للتأمين',
        'Walaa Insurance',
      );

  static String get insuranceAlRajhi =>
      _t(
        'الراجحي تكافل',
        'Al Rajhi Takaful',
      );

  static String get insuranceOther =>
      _t(
        'أخرى',
        'Other',
      );

  // =========================================================
  // Delivery Option Sheet
  // =========================================================

  static String get chooseDeliveryOrPickup =>
      _t(
        'اختر التوصيل أو الاستلام',
        'Choose delivery or pickup',
      );

  static String get productAvailabilityDependsOnLocation =>
      _t(
        'توفّر المنتجات يعتمد على مكانك',
        'Product availability depends on your location',
      );

  static String get homeDelivery =>
      _t(
        'توصيل للمنزل',
        'Home delivery',
      );

  static String get orderArrivesIn30To60Minutes =>
      _t(
        'يصلك طلبك خلال 30-60 دقيقة',
        'Your order arrives within 30–60 minutes',
      );

  static String get pickupFromBranchOption =>
      _t(
        'استلام من الفرع',
        'Pickup from branch',
      );

  static String get pickupFromNearestBranchFree =>
      _t(
        'استلمي طلبك من أقرب فرع، بدون رسوم',
        'Pick up your order from the nearest branch, free of charge',
      );

  static String get deliveryAddress =>
      _t(
        'عنوان التوصيل',
        'Delivery address',
      );

  static String get addNewAddress =>
      _t(
        'أضف عنوانا جديدا',
        'Add a new address',
      );

  static String get continueButton =>
      _t(
        'متابعة',
        'Continue',
      );

  // =========================================================
  // Product Card
  // =========================================================

  static String discountPercent(int percent) =>
      _t(
        'خصم $percent%',
        '$percent% OFF',
      );

  static String get sarCurrency =>
      _t(
        'ر.س',
        'SAR',
      );

  // =========================================================
  // Quick Login Sheet
  // =========================================================

  static String get quickLoginTitle =>
      _t(
        'سجّلي الدخول لإكمال الطلب',
        'Sign in to complete your order',
      );

  static String get quickLoginSubtitle =>
      _t(
        'نحتاج اسمك ورقم جوالك بس عشان نكمل طلبك ونتواصل معك',
        'We need your name and phone number to complete your order and contact you',
      );

  static String get quickLoginNameHint =>
      _t(
        'الاسم',
        'Name',
      );

  static String get quickLoginNameRequired =>
      _t(
        'يرجى إدخال الاسم',
        'Please enter your name',
      );

  static String get quickLoginPhoneHint =>
      _t(
        'رقم الجوال',
        'Phone number',
      );

  static String get quickLoginPhoneRequired =>
      _t(
        'يرجى إدخال رقم الجوال',
        'Please enter your phone number',
      );

  static String get continueOrder =>
      _t(
        'متابعة الطلب',
        'Continue order',
      );

  // =========================================================
  // الأسئلة الشائعة FAQ
  // =========================================================

  static String get faqPrescriptionQuestion =>
      _t(
        'كيف أقدر أطلب دواء يحتاج وصفة طبية؟',
        'How can I order a medicine that requires a prescription?',
      );

  static String get faqPrescriptionAnswer =>
      _t(
        'من الصفحة الرئيسية اضغطي على "رفع وصفة"، صوّري الوصفة أو اختاريها من المعرض، وسيقوم فريقنا بمراجعتها والتواصل معك لإتمام الطلب.',
        'From the home page, tap "Upload Prescription", take a photo of the prescription or choose it from the gallery. Our team will review it and contact you to complete the order.',
      );

  static String get faqDeliveryQuestion =>
      _t(
        'كم تستغرق مدة التوصيل؟',
        'How long does delivery take?',
      );

  static String get faqDeliveryAnswer =>
      _t(
        'عادة يصل طلبك خلال 30 إلى 60 دقيقة داخل نطاق التغطية، وتقدرين تحددين موعد توصيل مناسب لك عند إتمام الطلب.',
        'Your order usually arrives within 30 to 60 minutes within the coverage area. You can also choose a suitable delivery time when completing your order.',
      );

  static String get faqPickupQuestion =>
      _t(
        'هل أقدر أستلم طلبي من الفرع مباشرة؟',
        'Can I pick up my order directly from a branch?',
      );

  static String get faqPickupAnswer =>
      _t(
        'نعم، عند إتمام الشراء اختاري "استلام من الفرع" وحددي أقرب فرع لك من الخريطة، وسيكون طلبك جاهزاً للاستلام في الوقت المحدد.',
        'Yes. When completing your purchase, choose "Pickup from Branch" and select your nearest branch on the map. Your order will be ready for pickup at the selected time.',
      );

  static String get faqPaymentQuestion =>
      _t(
        'ما هي طرق الدفع المتاحة؟',
        'What payment methods are available?',
      );

  static String get faqPaymentAnswer =>
      _t(
        'نوفر الدفع عبر مدى، فيزا/ماستركارد، Apple Pay، الدفع عند الاستلام، بالإضافة إلى خدمتي تمارا وتابي للتقسيط.',
        'We offer Mada, Visa/Mastercard, Apple Pay, Cash on Delivery, as well as Tamara and Tabby installment services.',
      );

  static String get faqReturnQuestion =>
      _t(
        'هل أقدر أرجع أو أستبدل منتج بعد الاستلام؟',
        'Can I return or exchange a product after receiving it?',
      );

  static String get faqReturnAnswer =>
      _t(
        'نعم، يمكنك التواصل مع خدمة العملاء خلال 24 ساعة من الاستلام لطلب الإرجاع أو الاستبدال وفق سياسة الاستبدال والاسترجاع الخاصة بنا.',
        'Yes. You can contact customer service within 24 hours of receiving the product to request a return or exchange according to our return and exchange policy.',
      );

  static String get faqOrderQuestion =>
      _t(
        'كيف أتابع حالة طلبي؟',
        'How can I track my order status?',
      );

  static String get faqOrderAnswer =>
      _t(
        'من صفحة "حسابي" اضغطي على "طلباتي" لمتابعة حالة كل طلب لحظة بلحظة، من التجهيز وحتى التسليم.',
        'From the "My Account" page, tap "My Orders" to follow the status of each order from preparation until delivery.',
      );

  static String get faqCoverageQuestion =>
      _t(
        'هل التطبيق متوفر في كل مناطق المملكة؟',
        'Is the app available in all regions of the Kingdom?',
      );

  static String get faqCoverageAnswer =>
      _t(
        'حالياً نغطي المنطقة الجنوبية من المملكة العربية السعودية عبر شبكة فروعنا، ونعمل على التوسع تباعاً لمناطق أخرى.',
        'We currently cover the southern region of Saudi Arabia through our branch network and are gradually expanding to other areas.',
      );

  // =========================================================
  // تحويل اسم الفئة إلى اللغة الحالية
  // =========================================================

  static String categoryName(String category) {
    switch (category.trim()) {
      case 'الأدوية':
      case 'Medicines':
        return medicines;

      case 'العناية الصحية':
      case 'Health Care':
        return healthCare;

      case 'أجهزة طبية':
      case 'أدوات طبية':
      case 'Medical Devices':
        return medicalDevices;

      case 'العناية بالبشرة':
      case 'Skin Care':
        return skinCare;

      case 'الفيتامينات':
      case 'Vitamins':
        return vitamins;

      case 'الأطفال':
      case 'Kids':
        return kids;

      case 'الأم والطفل':
      case 'Mother & Baby':
        return motherAndBaby;

      case 'العناية بالشعر':
      case 'Hair Care':
        return hairCare;

      case 'العطور':
      case 'Perfumes':
        return perfumes;

      case 'عناية باليدين':
      case 'Hand Care':
        return handCare;

      case 'الجمال':
      case 'Beauty':
        return beauty;

      case 'العناية بالمنزل':
      case 'Home Care':
        return homeCare;

      case 'العناية اليومية':
      case 'Daily Care':
        return dailyCare;

      case 'التغذية الرياضية':
      case 'Sports Nutrition':
        return sportsNutrition;

      default:
        return category;
    }
  }
}
