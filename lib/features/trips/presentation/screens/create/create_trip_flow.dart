import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/extensions/theme_context_extension.dart';
import '../../../application/create_trip_controller.dart';
import 'steps/dates_step.dart';
import 'steps/destination_step.dart';
import 'steps/review_step.dart';
import 'steps/travelers_step.dart';

/// Host for the Create Trip flow: Destination → Travelers → Dates → Review.
///
/// Owns the page navigation; each step reads and writes the shared
/// [createTripControllerProvider] state. Entered via [AppRoutes.createTrip] with
/// a [CreateTripEntry] telling the first step which entry style to show.
class CreateTripFlow extends ConsumerStatefulWidget {
  const CreateTripFlow({super.key, this.entry = CreateTripEntry.manual});

  final CreateTripEntry entry;

  @override
  ConsumerState<CreateTripFlow> createState() => _CreateTripFlowState();
}

class _CreateTripFlowState extends ConsumerState<CreateTripFlow> {
  static const _stepCount = 4;
  final _pageController = PageController();
  int _index = 0;

  @override
  void initState() {
    super.initState();
    // Reset any prior draft and seed the chosen entry style.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(createTripControllerProvider.notifier).start(widget.entry);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goTo(int index) {
    if (index < 0 || index >= _stepCount) return;
    // Dismiss the keyboard before changing steps so it doesn't linger over the
    // next page.
    FocusScope.of(context).unfocus();
    setState(() => _index = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  void _next() => _goTo(_index + 1);

  void _back() {
    if (_index > 0) {
      _goTo(_index - 1);
    } else {
      Navigator.of(context).maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _index == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _back();
      },
      child: Scaffold(
        backgroundColor: context.colors.bg,
        // Let the keyboard overlay the screen instead of pushing the pinned
        // footer up over the suggestions list — the footer stays in place.
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
          // Tapping anywhere outside a field dismisses the keyboard.
          onTap: () => FocusScope.of(context).unfocus(),
          behavior: HitTestBehavior.translucent,
          child: SafeArea(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                DestinationStep(
                  onContinue: _next,
                  onLead: _back,
                  onJump: _goTo,
                ),
                TravelersStep(onContinue: _next, onBack: _back),
                DatesStep(onReview: _next, onBack: _back),
                ReviewStep(onBack: _back, onEdit: _goTo),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
