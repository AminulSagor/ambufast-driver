import 'package:ambufast_driver/utils/bottom_sheet_helper.dart';
import 'package:ambufast_driver/utils/colors.dart';
import 'package:ambufast_driver/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DistrictPickerSheet extends StatefulWidget {
  final String? initialSelection; // Preselect if available
  const DistrictPickerSheet({super.key, this.initialSelection});

  @override
  State<DistrictPickerSheet> createState() => _DistrictPickerSheetState();
}

class _DistrictPickerSheetState extends State<DistrictPickerSheet> {
  String? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialSelection;
  }

  @override
  Widget build(BuildContext context) {
    final maxH = MediaQuery.of(context).size.height * .6;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      constraints: BoxConstraints(maxHeight: maxH),
      padding: EdgeInsets.only(bottom: 10.h),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            dragHandle(),
            Text(
              'select_address_title'
                  .tr, // Select Address / ঠিকানা নির্বাচন করুন
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF374151),
              ),
            ),
            18.h.verticalSpace,
            divider(),

            // District list
            Flexible(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 6.h),
                itemCount: kBangladeshDistricts.length,
                itemBuilder: (_, i) {
                  final name = kBangladeshDistricts[i];
                  return InkWell(
                    onTap: () => setState(() => _selected = name),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              name,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF374151),
                              ),
                            ),
                          ),
                          Radio<String>(
                            value: name,
                            groupValue: _selected,
                            onChanged: (v) => setState(() => _selected = v),
                            activeColor: primaryBase,
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Done button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: CustomButton(
                btnTxt: 'done'.tr,
                onTap: _selected == null
                    ? null
                    : () => Get.back(result: _selected),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// All 64 districts of Bangladesh
const List<String> kBangladeshDistricts = [
  // Dhaka Division
  'Dhaka', 'Faridpur', 'Gazipur', 'Gopalganj', 'Kishoreganj', 'Madaripur',
  'Manikganj', 'Munshiganj', 'Narayanganj', 'Narsingdi', 'Rajbari',
  'Shariatpur', 'Tangail',
  // Chattogram Division
  'Bandarban', 'Brahmanbaria', 'Chandpur', 'Chattogram', 'Cox’s Bazar',
  'Cumilla', 'Feni', 'Khagrachhari', 'Lakshmipur', 'Noakhali', 'Rangamati',
  // Barishal Division
  'Barguna', 'Barishal', 'Bhola', 'Jhalokathi', 'Patuakhali', 'Pirojpur',
  // Khulna Division
  'Bagerhat', 'Chuadanga', 'Jashore', 'Jhenaidah', 'Khulna', 'Kushtia',
  'Magura', 'Meherpur', 'Narail', 'Satkhira',
  // Mymensingh Division
  'Jamalpur', 'Mymensingh', 'Netrokona', 'Sherpur',
  // Rajshahi Division
  'Bogura', 'Chapainawabganj', 'Joypurhat', 'Naogaon',
  'Natore', 'Pabna', 'Rajshahi', 'Sirajganj',
  // Rangpur Division
  'Dinajpur', 'Gaibandha', 'Kurigram', 'Lalmonirhat', 'Nilphamari',
  'Panchagarh', 'Rangpur', 'Thakurgaon',
  // Sylhet Division
  'Habiganj', 'Moulvibazar', 'Sunamganj', 'Sylhet',
];
