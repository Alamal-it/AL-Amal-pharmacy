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