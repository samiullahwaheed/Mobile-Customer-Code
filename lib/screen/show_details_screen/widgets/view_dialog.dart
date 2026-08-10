import 'package:flutter/material.dart';
import 'package:loyalty_customer/screen/show_details_screen/model/tiar_model.dart';
import 'package:loyalty_customer/utils/app_size.dart';
import 'package:loyalty_customer/widget/app_text/app_text.dart';

class ViewPointTierDialog extends StatelessWidget {
  final List<TiarDataModel>? tiarList;
  const ViewPointTierDialog({super.key, this.tiarList});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        children: [
          AppText(
            data: "Your Loyalty Program",
            fontSize: AppSize.width(value: 14),
            fontWeight: FontWeight.w700,
          ),
        ],
      ),
      content: SizedBox(
        height: AppSize.size.height * 0.1,
        width: double.maxFinite,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: tiarList?.length,
          itemBuilder: (context, index) {
            final data = tiarList?[index];
            final List<Color> colors = [
              Colors.green,
              Colors.blue,
              Colors.orange,
              Colors.purple,
              Colors.indigo,
              Colors.teal,
            ];
            return ViewTiarCard(
              data: data,
              cardColor: colors[index % colors.length],
            );
          },
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.width(value: 12),
                  vertical: AppSize.width(value: 8),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: AppText(
                  data: "Close",
                  fontSize: AppSize.width(value: 16),
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ViewTiarCard extends StatelessWidget {
  final TiarDataModel? data;
  final Color? cardColor;
  const ViewTiarCard({super.key, this.data, this.cardColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        width: AppSize.width(value: 120),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: cardColor ?? Colors.green,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Center(
                  child: AppText(
                    textAlign: TextAlign.center,
                    data: data?.name ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    fontSize: AppSize.width(value: 12),
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Expanded(
              flex: 3,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    AppText(
                      data:
                          "Points Threshold : ${data?.pointsThreshold.toString()}",
                      fontSize: AppSize.width(value: 12),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                    
                    AppText(
                      data: "Accumulation Rule : ${data?.accumulationRule} %",
                      fontSize: AppSize.width(value: 12),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
