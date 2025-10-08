import 'package:get/get.dart';

class HelpCenterController extends GetxController {
  /// all FAQs (id is used to track expanded state safely)
  final faqs = <Map<String, String>>[
    {
      'id': 'book',
      'question': 'How Do I Book An Ambulance?',
      'answer':
      'Open the AmbuFast app.Select your pick-up and drop-off locations.Choose ambulance type See fare estimate and confirm details. Pay 15–20% advance to confirm booking. Receive live driver/vehicle details after payment'
    },
    {
      'id': 'fare',
      'question': 'How Is The Fare Calculated?',
      'answer':
      'Fares are based on:Distance (base fare + per km). Ambulance type Zone (metro/rural) Waiting time, multi-stop, and return trip options. You’ll see a fare estimate before confirming.'
    },
    {
      'id': 'app_issue',
      'question': 'What If The App Doesn’t Work?',
      'answer':
      'Call to hotline number: 09678 911 911.'
    },
    {
      'id': 'payment',
      'question': 'What Payment Methods Are Supported?',
      'answer': 'bKash,Nagad,Visa/MasterCard, More options coming soon.'
    },
    {
      'id': 'cancel',
      'question': 'How Can I Cancel A Trip?',
      'answer':
      'From My Trips > Active, tap the trip and choose Cancel before the driver starts the ride.'
    },
  ].obs;

  /// search query & results
  final query = ''.obs;
  final filteredFaqs = <Map<String, String>>[].obs;

  /// expanded card ids
  final expanded = <String>{}.obs;

  void toggle(String id) {
    if (expanded.contains(id)) {
      expanded.remove(id);
    } else {
      expanded.add(id);
    }
  }

  void _applyFilter() {
    final q = query.value.trim().toLowerCase();
    if (q.isEmpty) {
      filteredFaqs.assignAll(faqs);
    } else {
      filteredFaqs.assignAll(
        faqs.where((e) =>
        (e['question'] ?? '').toLowerCase().contains(q) ||
            (e['answer'] ?? '').toLowerCase().contains(q)),
      );
    }
  }

  @override
  void onInit() {
    filteredFaqs.assignAll(faqs);
    // debounce search for performance
    debounce<String>(query, (_) => _applyFilter(),
        time: const Duration(milliseconds: 300));
    super.onInit();
  }
}
