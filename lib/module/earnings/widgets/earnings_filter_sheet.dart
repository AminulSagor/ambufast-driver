import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../widgets/datetime_picker_sheet.dart';
import '../earnings_controller.dart';

class EarningsFilterSheet extends StatefulWidget {
  const EarningsFilterSheet({super.key, required this.controller});
  final EarningsController controller;

  @override
  State<EarningsFilterSheet> createState() => _EarningsFilterSheetState();
}

class _EarningsFilterSheetState extends State<EarningsFilterSheet> {
  late FilterPreset _preset;
  DateTime? _start;
  DateTime? _end;

  bool _showPresetList = false;

  @override
  void initState() {
    super.initState();
    _preset = widget.controller.selectedPreset.value;
    _start = widget.controller.customStart.value;
    _end = widget.controller.customEnd.value;
  }

  String _presetText() => widget.controller.presetLabel(_preset);

  // Future<void> _pickDate({required bool start}) async {
  //   final localeTag = Get.locale?.toLanguageTag();
  //   final initial =
  //       start ? (_start ?? DateTime.now()) : (_end ?? DateTime.now());
  //   final first = DateTime(2020, 1, 1);
  //   final last = DateTime.now().add(const Duration(days: 365));
  //   final picked = await showDatePicker(
  //     context: context,
  //     initialDate: initial,
  //     firstDate: first,
  //     lastDate: last,
  //     locale: localeTag != null ? Locale(localeTag) : null,
  //   );
  //   if (picked != null) {
  //     setState(() {
  //       if (start) {
  //         _start = picked;
  //       } else {
  //         _end = picked;
  //       }
  //     });
  //   }
  // }

  // --- Methods to show pickers ---
  void showCupDatePicker({required bool start}) {
    // A temporary variable to hold the picker's state
    DateTime tempDate = DateTime.now();

    Get.bottomSheet(
      isScrollControlled: true,
      DatetimePickerSheet(
        title: 'choose_a_date'.tr,
        picker: CupertinoDatePicker(
          initialDateTime: DateTime.now(),
          minimumDate: DateTime(DateTime.now().year - 5),
          mode: CupertinoDatePickerMode.date,
          onDateTimeChanged: (newDate) {
            tempDate = newDate;
          },
          showDayOfWeek: true,
        ),
        onDone: () {
          // On "Done" pressed
          final currentDateTime = tempDate;
          // Combine the new date with the existing time
          if (start) {
            setState(() {
              _start = DateTime(
                tempDate.year,
                tempDate.month,
                tempDate.day,
                currentDateTime.hour,
                currentDateTime.minute,
                currentDateTime.second,
              );
            });
          } else {
            setState(() {
              _end = DateTime(
                tempDate.year,
                tempDate.month,
                tempDate.day,
                currentDateTime.hour,
                currentDateTime.minute,
                currentDateTime.second,
              );
            });
          }
          Get.back();
        },
      ),
    );
  }

  void _apply() {
    if (_preset == FilterPreset.custom) {
      widget.controller.applyCustom(_start, _end);
    } else {
      widget.controller.applyPreset(_preset);
    }
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('dd MMM, yyyy', Get.locale?.toLanguageTag());

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 8.h,
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // grabber
              Container(
                width: 120.w,
                height: 6.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFE74B3B),
                  borderRadius: BorderRadius.circular(3.r),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: Get.back,
                  icon:
                      const Icon(Icons.close_rounded, color: Colors.redAccent),
                ),
              ),

              // Preset field (inline dropdown)
              GestureDetector(
                onTap: () => setState(() => _showPresetList = !_showPresetList),
                child: Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFD1D5DB)),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _presetText(),
                          style: TextStyle(fontSize: 16.sp),
                        ),
                      ),
                      AnimatedRotation(
                        duration: const Duration(milliseconds: 200),
                        turns: _showPresetList ? 0.5 : 0.0,
                        child: const Icon(Icons.unfold_more_rounded, size: 18),
                      ),
                    ],
                  ),
                ),
              ),

              // Inline options list with smooth height animation
              ClipRect(
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOut,
                  child: _showPresetList
                      ? Container(
                          margin: EdgeInsets.only(top: 10.h),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFD1D5DB)),
                            borderRadius: BorderRadius.circular(12.r),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: _presetOptions()
                                .map((opt) => _PresetOptionTile(
                                      label: opt.$2,
                                      selected: _preset == opt.$1,
                                      onTap: () {
                                        setState(() {
                                          _preset = opt.$1;
                                          if (_preset != FilterPreset.custom) {
                                            _start = null;
                                            _end = null;
                                          }
                                          _showPresetList = false;
                                        });
                                      },
                                    ))
                                .toList(),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ),

              14.verticalSpace,

              // Date range row (active for custom or optional for any)
              Row(
                children: [
                  Expanded(
                    child: _DateField(
                      label: 'start_date'.tr,
                      value: _start != null ? df.format(_start!) : null,
                      onTap: () => showCupDatePicker(start: true),
                    ),
                  ),
                  12.horizontalSpace,
                  Expanded(
                    child: _DateField(
                      label: 'end_date'.tr,
                      value: _end != null ? df.format(_end!) : null,
                      onTap: () => showCupDatePicker(start: false),
                    ),
                  ),
                ],
              ),

              22.verticalSpace,

              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE53935),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  onPressed: _apply,
                  icon:
                      const Icon(Icons.filter_alt_rounded, color: Colors.white),
                  label: Text('filter'.tr,
                      style: TextStyle(fontSize: 16.sp, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<(FilterPreset, String)> _presetOptions() => <(FilterPreset, String)>[
        (FilterPreset.today, 'filter_today'.tr),
        (FilterPreset.yesterday, 'filter_yesterday'.tr),
        (FilterPreset.lastWeek, 'filter_last_week'.tr),
        (FilterPreset.lastMonth, 'filter_last_month'.tr),
        (FilterPreset.lastYear, 'filter_last_year'.tr),
        (FilterPreset.custom, 'filter_custom'.tr),
      ];
}

class _DateField extends StatelessWidget {
  const _DateField({required this.label, required this.onTap, this.value});
  final String label;
  final VoidCallback onTap;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final isHint = value == null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFD1D5DB)),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value ?? label,
                style: TextStyle(
                  color: isHint
                      ? const Color(0xFF9CA3AF)
                      : const Color(0xFF111827),
                  fontSize: 14.sp,
                ),
              ),
            ),
            const Icon(Icons.calendar_month_rounded, color: Color(0xFF9CA3AF)),
          ],
        ),
      ),
    );
  }
}

class _PresetOptionTile extends StatelessWidget {
  const _PresetOptionTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.withOpacity(.15),
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: const Color(0xFF111827),
                    fontSize: 15.sp,
                  ),
                ),
              ),
            ),
            if (selected)
              const Icon(Icons.check_rounded, color: Colors.green, size: 18),
          ],
        ),
      ),
    );
  }
}
