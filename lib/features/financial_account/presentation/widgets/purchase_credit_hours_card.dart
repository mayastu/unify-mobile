import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../system_settings/data/models/system_settings_model.dart';
import '../../../system_settings/presentation/cubit/system_settings_cubit.dart';
import '../cubit/financial_cubit.dart';

class PurchaseCreditHoursCard extends StatefulWidget {
  const PurchaseCreditHoursCard({
    super.key,
    required this.palette,
  });

  final AppPalette palette;

  @override
  State<PurchaseCreditHoursCard> createState() =>
      _PurchaseCreditHoursCardState();
}

class _PurchaseCreditHoursCardState
    extends State<PurchaseCreditHoursCard> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Recomputes the live total as the student types.
    controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _purchase(SystemSettingsModel? settings) {
    final hours = int.tryParse(controller.text);

    if (hours == null || hours <= 0) {
      _showError('Enter a valid number of credit hours.');
      return;
    }

    if (settings?.minimumCreditHours != null && hours < settings!.minimumCreditHours!) {
      _showError('Minimum purchase is ${settings.minimumCreditHours} credit hours.');
      return;
    }

    if (settings?.maximumCreditHours != null && hours > settings!.maximumCreditHours!) {
      _showError('Maximum purchase is ${settings.maximumCreditHours} credit hours.');
      return;
    }

    context.read<FinancialCubit>().purchaseCreditHours(hours);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = widget.palette;
    final hours = int.tryParse(controller.text);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: palette.waveGold,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  Icons.add_card_rounded,
                  color: palette.secondary,
                  size: 21,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Buy credit hours',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: palette.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Add hours to your academic account.',
                      style: TextStyle(
                        fontSize: 11,
                        color: palette.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          BlocBuilder<SystemSettingsCubit, SystemSettingsState>(
            builder: (context, settingsState) {
              final settings =
                  settingsState is SystemSettingsSuccess ? settingsState.settings : null;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _PriceRow(state: settingsState, palette: palette),
                  const SizedBox(height: 14),
                  TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: palette.textPrimary,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Credit hours',
                      hintText: settings?.minimumCreditHours != null &&
                              settings?.maximumCreditHours != null
                          ? '${settings!.minimumCreditHours}–${settings.maximumCreditHours} hours'
                          : 'e.g. 12',
                      prefixIcon: Icon(
                        Icons.schedule_rounded,
                        color: palette.primary,
                      ),
                      filled: true,
                      fillColor: palette.surfaceElevated,
                      labelStyle: TextStyle(color: palette.textSecondary),
                      hintStyle: TextStyle(color: palette.textSecondary.withOpacity(.6)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: palette.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: palette.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: palette.primary, width: 1.5),
                      ),
                    ),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    child: (settings != null && hours != null && hours > 0)
                        ? Padding(
                            key: ValueKey(hours),
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              children: [
                                Icon(Icons.calculate_outlined,
                                    size: 15, color: palette.textSecondary),
                                const SizedBox(width: 6),
                                Text(
                                  'Total: \$${(hours * settings.creditHourPrice).toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: palette.primary,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 13),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FilledButton.icon(
                      onPressed: () => _purchase(settings),
                      icon: const Icon(Icons.shopping_cart_checkout_rounded, size: 19),
                      label: const Text(
                        'Purchase credit hours',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: palette.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({required this.state, required this.palette});

  final SystemSettingsState state;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (state is SystemSettingsLoading || state is SystemSettingsInitial) {
      content = SizedBox(
        width: 90,
        height: 12,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: palette.border,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      );
    } else if (state is SystemSettingsFailure) {
      content = Text(
        "Price unavailable — pull to refresh",
        style: TextStyle(fontSize: 11.5, color: palette.textSecondary),
      );
    } else {
      final price = (state as SystemSettingsSuccess).settings.creditHourPrice;
      content = Text(
        '\$${price.toStringAsFixed(2)} / credit hour',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: palette.textPrimary,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: palette.surfaceElevated,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.sell_outlined, size: 15, color: palette.secondary),
          const SizedBox(width: 8),
          content,
        ],
      ),
    );
  }
}
