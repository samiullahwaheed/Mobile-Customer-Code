import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/const/app_color.dart';
import 'package:loyalty_customer/const/app_theme_color.dart';
import 'package:loyalty_customer/screen/transaction_history_screen/controller/transaction_history_controller.dart';
import 'package:loyalty_customer/screen/transaction_history_screen/widgets/shimmer/transection_shimmer_card.dart';
import 'package:loyalty_customer/utils/app_size.dart';
import 'package:loyalty_customer/widget/app_formater/date_formet.dart';
import 'package:loyalty_customer/widget/app_log/gap.dart';
import 'package:loyalty_customer/widget/app_text/app_text.dart';
import 'package:loyalty_customer/widget/appbar/custom_appbar.dart';

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppThemeColor appThemeColor = Theme.of(
      context,
    ).extension<AppThemeColor>()!;

    return GetBuilder<TransactionHistoryController>(
      init: TransactionHistoryController(),
      builder: (controller) {
        return Scaffold(
          appBar: CustomAppbar(
            appThemeColor: appThemeColor,
            text: "Transaction History",
          ),
          body: Obx(() {
            if (controller.isLoading.value) {
              return ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return const TransectionShimmerCard();
                },
              );
            }

            if (controller.subscriptionHistoryList.isEmpty) {
              return const Center(child: Text("No Data"));
            }
            return ListView.builder(
              itemCount: controller.subscriptionHistoryList.length,
              itemBuilder: (context, index) {
                final data = controller.subscriptionHistoryList[index];
                return TransSubCard(
                  isInactive: data.status == "active" ? false : true,
                  appThemeColor: appThemeColor,
                  r0: data.trxId,
                  r1: data.package?.title,
                  r2: formatDate(data.currentPeriodStart),
                  r3: formatDate(data.currentPeriodEnd),
                  r4: data.remaining.toString(),
                  r5: data.price.toString(),
                );
              },
            );
          }),
        );
      },
    );
  }
}

class TransSubCard extends StatelessWidget {
  final String? r0;
  final String? r1;
  final String? r2;
  final String? r3;
  final String? r4;
  final String? r5;
  final bool isInactive;
  const TransSubCard({
    super.key,
    required this.appThemeColor,
    required this.r0,
    required this.r1,
    required this.r2,
    required this.r3,
    required this.r4,
    required this.r5,
    this.isInactive = false,
  });

  final AppThemeColor appThemeColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: appThemeColor.icon),
        color: AppColor.button2Dark,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            data: "Transaction ID: $r0",
            fontSize: AppSize.width(value: 16),
            fontWeight: FontWeight.w600,
            color: isInactive ? AppColor.subCardInactive : AppColor.icon1Dark,
          ),
          Divider(color: AppColor.icon4Dark.withValues(alpha: 0.2)),
          if (r1 != null || r1!.isNotEmpty)
            TransectionRow(
              isInactive: isInactive,
              title: "Package ",
              value: r1,
            ),
          Gap(height: AppSize.height(value: 12)),
          if (r2 != null || r2!.isNotEmpty)
            TransectionRow(
              isInactive: isInactive,
              title: "start Date",
              value: r2,
            ),
          Gap(height: AppSize.height(value: 12)),
          if (r3 != null || r3!.isNotEmpty)
            TransectionRow(
              isInactive: isInactive,
              title: "end Date",
              value: r3,
            ),
          Gap(height: AppSize.height(value: 12)),
          if (r4 != null || r4!.isNotEmpty)
            TransectionRow(
              isInactive: isInactive,
              title: "Total Pay",
              value: r4,
            ),
          Divider(color: AppColor.icon4Dark.withValues(alpha: 0.2)),
          if (r5 != null || r5!.isNotEmpty)
            TransectionRow(
              isInactive: isInactive,
              isBold: true,
              title: "Total:",
              value: r5,
            ),
        ],
      ),
    );
  }
}

class TransectionRow extends StatelessWidget {
  final String? title;
  final String? value;
  final bool isBold;
  final bool isInactive;
  const TransectionRow({
    required this.isInactive,
    super.key,
    this.title,
    this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: AppSize.size.width * 0.35,
          child: AppText(
            data: title ?? "",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            fontSize: AppSize.width(value: 12),
            color: isInactive ? AppColor.subCardInactive : AppColor.icon1Dark,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        SizedBox(
          width: AppSize.size.width * 0.35,
          child: AppText(
            data: value ?? "",
            textAlign: TextAlign.right,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            fontSize: AppSize.width(value: 12),
            color: isInactive ? AppColor.subCardInactive : AppColor.icon1Dark,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
