import 'dart:async';
import 'package:flutter/material.dart';

class PromoBanner {
  final String title;
  final String subtitle;
  final String buttonText;
  final Color color;
  final IconData icon;

  const PromoBanner({
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.color,
    required this.icon,
  });
}

class PromoBannerCarousel extends StatefulWidget {
  final List<PromoBanner> banners;
  final void Function(PromoBanner banner)? onTapButton;

  const PromoBannerCarousel({
    super.key,
    required this.banners,
    this.onTapButton,
  });

  @override
  State<PromoBannerCarousel> createState() => _PromoBannerCarouselState();
}

class _PromoBannerCarouselState extends State<PromoBannerCarousel> {
  final PageController controller = PageController();
  Timer? timer;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    if (widget.banners.length > 1) {
      timer = Timer.periodic(const Duration(seconds: 4), (_) {
        if (!mounted) return;

        currentPage = (currentPage + 1) % widget.banners.length;

        controller.animateToPage(
          currentPage,
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 130, // كان 118 — زودناه عشان يوسع للمحتوى
          child: PageView.builder(
            controller: controller,
            itemCount: widget.banners.length,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final banner = widget.banners[index];

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ), // كان EdgeInsets.all(16)
                decoration: BoxDecoration(
                  color: banner.color,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min, // مهم لمنع الـ overflow
                        children: [
                          Text(
                            banner.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18, // كان 19
                              fontWeight: FontWeight.w800,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 3), // كان 4
                          Text(
                            banner.subtitle,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 8), // كان 10
                          GestureDetector(
                            onTap: () => widget.onTapButton?.call(banner),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6, // كان 7
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xff2EAD59),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                banner.buttonText,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 50, // كان 56
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Color(0xff2EAD59),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(banner.icon, color: Colors.white, size: 24),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        if (widget.banners.length > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.banners.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: currentPage == index ? 18 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: currentPage == index
                      ? const Color(0xff0E4595)
                      : const Color(0xffDDE5EF),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
      ],
    );
  }
}