import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class FamilyMember {
  final String name;
  final String relation;
  final String phone;

  const FamilyMember({
    required this.name,
    required this.relation,
    required this.phone,
  });
}

class FamilyMembersScreen extends StatefulWidget {
  const FamilyMembersScreen({super.key});

  @override
  State<FamilyMembersScreen> createState() => _FamilyMembersScreenState();
}

class _FamilyMembersScreenState extends State<FamilyMembersScreen> {
  // TODO: استبدال هذه القائمة بربطها بالـ API عندما يجهز.
  final List<FamilyMember> members = [];

  void _showAddMemberSheet() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();

    String relation = 'ابن/ابنة';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  const Text(
                    'إضافة فرد من الأسرة',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryDark,
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: nameController,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      hintText: 'الاسم الكامل',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: phoneController,
                    textAlign: TextAlign.right,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'رقم الجوال',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Wrap(
                    alignment: WrapAlignment.end,
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final r in [
                        'ابن/ابنة',
                        'زوج/زوجة',
                        'والد/والدة',
                        'آخر',
                      ])
                        ChoiceChip(
                          label: Text(r),
                          selected: relation == r,
                          onSelected: (_) {
                            setModalState(() {
                              relation = r;
                            });
                          },
                          selectedColor:
                              AppColors.primary.withOpacity(0.12),
                          labelStyle: TextStyle(
                            fontSize: 11,
                            color: relation == r
                                ? AppColors.primary
                                : AppColors.textGray,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: relation == r
                                  ? AppColors.primary
                                  : AppColors.border,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        final name = nameController.text.trim();
                        final phone = phoneController.text.trim();

                        if (name.isEmpty || phone.isEmpty) {
                          return;
                        }

                        setState(() {
                          members.add(
                            FamilyMember(
                              name: name,
                              relation: relation,
                              phone: phone,
                            ),
                          );
                        });

                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'إضافة',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: AppColors.primaryDark,
        ),
        centerTitle: true,
        title: const Text(
          'أفراد الأسرة',
          style: TextStyle(
            color: AppColors.primaryDark,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),

      body: members.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: AppColors.border.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.groups_outlined,
                      size: 40,
                      color: AppColors.textGray,
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'لم تضيفي أي فرد من الأسرة بعد',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryDark,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'أضيفي أفراد أسرتك ليتمكنوا من الطلب باسمهم',
                    style: TextStyle(
                      color: AppColors.textGray,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton.icon(
                    onPressed: _showAddMemberSheet,
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'إضافة فرد جديد',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: members.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final member = members[index];

                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.border,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            members.removeAt(index);
                          });
                        },
                        icon: const Icon(
                          Icons.delete_outline,
                          color: AppColors.textGray,
                          size: 20,
                        ),
                      ),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.end,
                          children: [
                            Text(
                              member.name,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryDark,
                              ),
                            ),

                            const SizedBox(height: 2),

                            Text(
                              '${member.relation} — ${member.phone}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textGray,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 10),

                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color:
                              AppColors.primary.withOpacity(0.08),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person_outline,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

      floatingActionButton: members.isEmpty
          ? null
          : FloatingActionButton(
              backgroundColor: AppColors.primary,
              onPressed: _showAddMemberSheet,
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
    );
  }
}
