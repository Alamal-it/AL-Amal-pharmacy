import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_strings.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../widgets/product_card.dart';
import '../widgets/countdown_timer.dart';
import 'product_details_screen.dart';

enum _SortOption {
  mostDiscount,
  priceLowHigh,
  priceHighLow,
}

class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  final ProductService productService = ProductService();

  late Future<List<Product>> productsFuture;

  String? selectedCategory;
  _SortOption sortOption = _SortOption.mostDiscount;

  @override
  void initState() {
    super.initState();
    productsFuture = productService.getProducts();
  }

  int _discountOf(Product product) {
    if (product.oldPrice == null ||
        product.oldPrice! <= product.price) {
      return 0;
    }

    return (((product.oldPrice! - product.price) /
                product.oldPrice!) *
            100)
        .round();
  }

  String _sortLabel(_SortOption option) {
    switch (option) {
      case _SortOption.mostDiscount:
        return AppStrings.mostDiscount;

      case _SortOption.priceLowHigh:
        return AppStrings.priceLowToHigh;

      case _SortOption.priceHighLow:
        return AppStrings.priceHighToLow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabic =
        Directionality.of(context) == TextDirection.rtl;

    return Directionality(
      textDirection: isArabic
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: AppColors.white,

        // ==========================================================
        // APP BAR
        // ==========================================================

        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: true,

          title: Text(
            AppStrings.offers,
            style: const TextStyle(
              color: AppColors.primaryDark,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),

        // ==========================================================
        // PRODUCTS
        // ==========================================================

        body: FutureBuilder<List<Product>>(
          future: productsFuture,

          builder: (context, snapshot) {
            // ======================================================
            // LOADING
            // ======================================================

            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              );
            }

            // ======================================================
            // ERROR
            // ======================================================

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  AppStrings.errorLoadingProducts,
                  style: const TextStyle(
                    color: AppColors.textGray,
                    fontSize: 13,
                  ),
                ),
              );
            }

            // ======================================================
            // ALL OFFERS
            // ======================================================

            final allOffers = (snapshot.data ?? [])
                .where(
                  (product) =>
                      product.oldPrice != null &&
                      product.oldPrice! > product.price,
                )
                .toList()
              ..sort(
                (a, b) => _discountOf(b)
                    .compareTo(_discountOf(a)),
              );

            // ======================================================
            // NO OFFERS
            // ======================================================

            if (allOffers.isEmpty) {
              return Center(
                child: Text(
                  AppStrings.noOffersNow,
                  style: const TextStyle(
                    color: AppColors.textGray,
                    fontSize: 13,
                  ),
                ),
              );
            }

            // ======================================================
            // CATEGORIES
            // ======================================================

            final categories = <String>[
              ...{
                for (final product in allOffers)
                  product.category,
              }
            ];

            // ======================================================
            // SELECTED CATEGORY
            // ======================================================

            List<Product> offers;

            if (selectedCategory == null) {
              offers = List<Product>.from(allOffers);
            } else {
              offers = allOffers
                  .where(
                    (product) =>
                        product.category ==
                        selectedCategory,
                  )
                  .toList();
            }

            // ======================================================
            // SORT
            // ======================================================

            switch (sortOption) {
              case _SortOption.mostDiscount:
                offers.sort(
                  (a, b) => _discountOf(b)
                      .compareTo(_discountOf(a)),
                );
                break;

              case _SortOption.priceLowHigh:
                offers.sort(
                  (a, b) =>
                      a.price.compareTo(b.price),
                );
                break;

              case _SortOption.priceHighLow:
                offers.sort(
                  (a, b) =>
                      b.price.compareTo(a.price),
                );
                break;
            }

            // ======================================================
            // FEATURED PRODUCT
            // ======================================================

            final featured = allOffers.first;

            // ======================================================
            // PAGE
            // ======================================================

            return ListView(
              padding: const EdgeInsets.only(
                bottom: 20,
              ),

              children: [

                // ==================================================
                // PROMOTIONAL BANNER
                // ==================================================

                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),

                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.primaryDark,
                      ],
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                    ),
                    borderRadius:
                        BorderRadius.circular(14),
                  ),

                  child: Row(
                    children: [

                      const Icon(
                        Icons.local_offer_outlined,
                        color: Colors.white,
                        size: 28,
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              isArabic
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,

                          children: [

                            Text(
                              AppStrings.discountUpTo(
                                _discountOf(featured),
                              ),

                              textAlign: isArabic
                                  ? TextAlign.right
                                  : TextAlign.left,

                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight:
                                    FontWeight.w700,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              AppStrings.selectedProductsOffer,

                              textAlign: isArabic
                                  ? TextAlign.right
                                  : TextAlign.left,

                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ==================================================
                // COUNTDOWN
                // ==================================================

                Padding(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),

                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,

                    children: [

                      Text(
                        AppStrings.offersEndIn,

                        style: const TextStyle(
                          color:
                              AppColors.primaryDark,
                          fontSize: 13,
                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),

                      const CountdownTimer(
                        duration: Duration(
                          hours: 5,
                          minutes: 30,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // ==================================================
                // BIGGEST DISCOUNT
                // ==================================================

                Padding(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),

                  child: Align(
                    alignment: isArabic
                        ? Alignment.centerRight
                        : Alignment.centerLeft,

                    child: Text(
                      AppStrings.biggestDiscountToday,

                      style: const TextStyle(
                        color:
                            AppColors.primaryDark,
                        fontSize: 14,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // ==================================================
                // FEATURED PRODUCT CARD
                // ==================================================

                Padding(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),

                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ProductDetailsScreen(
                            product: featured,
                          ),
                        ),
                      );
                    },

                    child: Container(
                      padding:
                          const EdgeInsets.all(12),

                      decoration: BoxDecoration(
                        color:
                            const Color(0xffFFF8F0),
                        borderRadius:
                            BorderRadius.circular(16),
                        border: Border.all(
                          color:
                              const Color(0xffFFE0B2),
                        ),
                      ),

                      child: Row(
                        children: [

                          // DISCOUNT
                          Container(
                            padding:
                                const EdgeInsets
                                    .symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),

                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius:
                                  BorderRadius
                                      .circular(20),
                            ),

                            child: Text(
                              '-${_discountOf(featured)}%',

                              style:
                                  const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          // PRODUCT INFO
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  isArabic
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,

                              children: [

                                Text(
                                  featured.name,

                                  textAlign:
                                      isArabic
                                          ? TextAlign.right
                                          : TextAlign.left,

                                  maxLines: 1,
                                  overflow:
                                      TextOverflow
                                          .ellipsis,

                                  style:
                                      const TextStyle(
                                    fontSize: 13.5,
                                    fontWeight:
                                        FontWeight.w700,
                                    color: AppColors
                                        .primaryDark,
                                  ),
                                ),

                                const SizedBox(
                                  height: 4,
                                ),

                                Row(
                                  mainAxisSize:
                                      MainAxisSize.min,

                                  children: [

                                    Text(
                                      '${featured.oldPrice} ${AppStrings.currency}',

                                      style:
                                          const TextStyle(
                                        color: AppColors
                                            .textGray,
                                        fontSize: 11.5,
                                        decoration:
                                            TextDecoration
                                                .lineThrough,
                                      ),
                                    ),

                                    const SizedBox(
                                      width: 6,
                                    ),

                                    Text(
                                      '${featured.price} ${AppStrings.currency}',

                                      style:
                                          const TextStyle(
                                        color: AppColors
                                            .primary,
                                        fontSize: 14,
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 10),

                          // IMAGE
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(
                              10,
                            ),

                            child: Image.network(
                              featured.image,
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,

                              errorBuilder:
                                  (_, __, ___) {
                                return Container(
                                  width: 56,
                                  height: 56,
                                  color: AppColors
                                      .border
                                      .withOpacity(
                                          0.3),

                                  child: const Icon(
                                    Icons
                                        .image_outlined,
                                    color: AppColors
                                        .textGray,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Divider(
                  color: AppColors.border,
                  height: 1,
                ),

                const SizedBox(height: 14),

                // ==================================================
                // CATEGORY FILTER
                // ==================================================

                if (categories.isNotEmpty)
                  SizedBox(
                    height: 36,

                    child: ListView.separated(
                      scrollDirection:
                          Axis.horizontal,

                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),

                      itemCount:
                          categories.length + 1,

                      separatorBuilder:
                          (_, __) =>
                              const SizedBox(
                        width: 8,
                      ),

                      itemBuilder:
                          (context, index) {

                        final String? category =
                            index == 0
                                ? null
                                : categories[
                                    index - 1];

                        final bool isSelected =
                            category ==
                                selectedCategory;

                        return ChoiceChip(
                          label: Text(
                            category ??
                                AppStrings.all,
                          ),

                          selected: isSelected,

                          onSelected: (_) {
                            setState(() {
                              selectedCategory =
                                  category;
                            });
                          },

                          selectedColor:
                              AppColors.primary
                                  .withOpacity(
                            0.12,
                          ),

                          backgroundColor:
                              Colors.white,

                          labelStyle:
                              TextStyle(
                            fontSize: 11.5,
                            fontWeight:
                                FontWeight.w600,

                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textGray,
                          ),

                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              20,
                            ),

                            side: BorderSide(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.border,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                const SizedBox(height: 12),

                // ==================================================
                // SORT + COUNT
                // ==================================================

                Padding(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),

                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,

                    children: [

                      PopupMenuButton<_SortOption>(
                        initialValue:
                            sortOption,

                        onSelected: (value) {
                          setState(() {
                            sortOption = value;
                          });
                        },

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            10,
                          ),
                        ),

                        itemBuilder:
                            (context) {

                          return _SortOption
                              .values
                              .map(
                                (
                                  option,
                                ) =>
                                    PopupMenuItem<
                                        _SortOption>(
                                  value: option,

                                  child: Text(
                                    _sortLabel(
                                      option,
                                    ),
                                  ),
                                ),
                              )
                              .toList();
                        },

                        child: Row(
                          children: [

                            const Icon(
                              Icons.swap_vert,
                              size: 18,
                              color:
                                  AppColors.primary,
                            ),

                            const SizedBox(
                              width: 4,
                            ),

                            Text(
                              _sortLabel(
                                sortOption,
                              ),

                              style:
                                  const TextStyle(
                                fontSize: 12,
                                fontWeight:
                                    FontWeight.w600,
                                color: AppColors
                                    .primary,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Text(
                        AppStrings.productsCount(
                          offers.length,
                        ),

                        style:
                            const TextStyle(
                          fontSize: 12,
                          color:
                              AppColors.textGray,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // ==================================================
                // PRODUCTS GRID
                // ==================================================

                offers.isEmpty

                    ? Padding(
                        padding:
                            const EdgeInsets.symmetric(
                          vertical: 40,
                        ),

                        child: Center(
                          child: Text(
                            AppStrings
                                .noOffersInCategory,

                            style:
                                const TextStyle(
                              color: AppColors
                                  .textGray,
                            ),
                          ),
                        ),
                      )

                    : GridView.builder(
                        shrinkWrap: true,

                        physics:
                            const NeverScrollableScrollPhysics(),

                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),

                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.68,
                        ),

                        itemCount:
                            offers.length,

                        itemBuilder:
                            (context, index) {

                          final product =
                              offers[index];

                          final discountPercent =
                              _discountOf(
                            product,
                          );

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ProductDetailsScreen(
                                    product:
                                        product,
                                  ),
                                ),
                              );
                            },

                            child: Stack(
                              children: [

                                ProductCard(
                                  product: product,
                                ),

                                Positioned(
                                  top: 8,
                                  left: 8,

                                  child:
                                      Container(
                                    padding:
                                        const EdgeInsets
                                            .symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),

                                    decoration:
                                        BoxDecoration(
                                      color:
                                          Colors.red,
                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                        6,
                                      ),
                                    ),

                                    child: Text(
                                      '-$discountPercent%',

                                      style:
                                          const TextStyle(
                                        color:
                                            Colors.white,
                                        fontSize: 10,
                                        fontWeight:
                                            FontWeight
                                                .bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ],
            );
          },
        ),
      ),
    );
  }
}