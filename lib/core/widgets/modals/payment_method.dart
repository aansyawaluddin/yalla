import 'package:flutter/material.dart';
import 'package:yalla/core/theme/app_colors.dart';
import 'package:yalla/core/theme/app_typography.dart';
import 'package:yalla/core/widgets/button/primary_gradient_button.dart';

enum TrailingType { chevron, radio }

class PaymentMethod extends StatefulWidget {
  const PaymentMethod({super.key});

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  String _selectedMethod = '';
  String _selectedBank = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.45,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -50,
            right: -50,
            child: IgnorePointer(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.lightBlue.withOpacity(0.15),
                      blurRadius: 80,
                      spreadRadius: 40,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: -50,
            child: IgnorePointer(
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.lightBlue.withOpacity(0.15),
                      blurRadius: 80,
                      spreadRadius: 40,
                    ),
                  ],
                ),
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Center(
                child: Container(
                  width: 50,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  "Pilih Metode",
                  style: AppTypography.bold14.copyWith(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      _buildPaymentOption(
                        title: "Transfer Bank",
                        iconPath: 'assets/icons/card.png',
                        trailingType: TrailingType.chevron,
                        subOptions: [
                          {'name': 'Bank BRI', 'icon': 'assets/icons/bri.png'},
                          {'name': 'Bank BCA', 'icon': 'assets/icons/bca.png'},
                          {'name': 'Bank BNI', 'icon': 'assets/icons/bni.png'},
                        ],
                      ),
                      const SizedBox(height: 12),

                      _buildPaymentOption(
                        title: "QRIS",
                        iconPath: 'assets/icons/qris.png',
                        trailingType: TrailingType.radio,
                      ),
                      const SizedBox(height: 12),

                      _buildPaymentOption(
                        title: "Kartu Kredit/Debit",
                        iconPath: 'assets/icons/card.png',
                        trailingType: TrailingType.chevron,
                        subOptions: [
                          {'name': 'Bank BRI', 'icon': 'assets/icons/bri.png'},
                          {'name': 'Bank BCA', 'icon': 'assets/icons/bca.png'},
                          {'name': 'Bank BNI', 'icon': 'assets/icons/bni.png'},
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
                child: PrimaryGradientButton(
                  text: "Pilih Metode",
                  onPressed: () {
                    String finalSelection =
                        _selectedMethod == "Transfer Bank" &&
                            _selectedBank.isNotEmpty
                        ? _selectedBank
                        : _selectedMethod;
                    Navigator.pop(context, finalSelection);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required String title,
    required String iconPath,
    required TrailingType trailingType,
    List<Map<String, String>>? subOptions,
  }) {
    bool isSelected = _selectedMethod == title;
    bool isExpanded = isSelected && subOptions != null;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppColors.lightBlue : Colors.grey.shade300,
          width: isSelected ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedMethod = isExpanded ? '' : title;
              });
            },
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              color: Colors.transparent,
              child: Row(
                children: [
                  Image.asset(
                    iconPath,
                    width: 24,
                    height: 24,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.account_balance_wallet,
                      color: Colors.grey,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),

                  Expanded(
                    child: Text(
                      title,
                      style: AppTypography.regular12.copyWith(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),

                  if (trailingType == TrailingType.chevron)
                    Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Colors.black54,
                      size: 20,
                    )
                  else
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? AppColors.lightBlue
                              : Colors.grey.shade300,
                          width: isSelected ? 5 : 1.5,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            alignment: Alignment.topCenter,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeOut,
              child: isExpanded
                  ? _buildExpandedArea(subOptions)
                  : const SizedBox.shrink(key: ValueKey('collapsed')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedArea(List<Map<String, String>> banks) {
    return Column(
      key: const ValueKey('expanded_area'),
      children: [
        Container(
          height: 1,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.35),
                blurRadius: 1,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        ...banks.map((bank) {
          bool isBankSelected = _selectedBank == bank['name'];
          return InkWell(
            onTap: () {
              setState(() {
                _selectedBank = bank['name']!;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Image.asset(
                    bank['icon']!,
                    width: 24,
                    height: 24,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.account_balance,
                      color: Colors.blue,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),

                  Expanded(
                    child: Text(
                      bank['name']!,
                      style: AppTypography.regular12.copyWith(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isBankSelected
                            ? AppColors.lightBlue
                            : Colors.grey.shade300,
                        width: isBankSelected ? 5 : 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),

        const SizedBox(height: 8),
      ],
    );
  }
}
