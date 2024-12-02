import 'package:flutter/material.dart';
import '../../utils/colors.dart';

class StorePage extends StatelessWidget {
  const StorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false, 
        backgroundColor: AppColors.background,
        title: const Text(
          "Store",
          style: TextStyle(color: AppColors.textPrimary),
        ),
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Upgrades and Features",
              style: TextStyle(
                color: AppColors.accent,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView(
                children: [
                  _buildStoreItem(
                    title: "Post Boosting",
                    description:
                        "Increase the visibility of your tasks to reach more people.",
                    price: "₱50.00",
                    onTap: () {
                      _showPurchaseDialog(context, "Post Boosting", "₱50.00");
                    },
                  ),
                  const SizedBox(height: 16.0),
                  _buildStoreItem(
                    title: "Additional Task Posting",
                    description: "Add 5 more task posts to your account.",
                    price: "₱70.00",
                    onTap: () {
                      _showPurchaseDialog(context, "Additional Task Posting", "₱70.00");
                    },
                  ),
                  const SizedBox(height: 16.0),
                  _buildStoreItem(
                    title: "Premium Membership",
                    description:
                        "Unlock unlimited task postings and priority support.",
                    price: "₱500.00",
                    onTap: () {
                      _showPurchaseDialog(context, "Premium Membership", "₱500.00");
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoreItem({
    required String title,
    required String description,
    required String price,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: AppColors.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                description,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 14.0,
                ),
              ),
              const SizedBox(height: 12.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    price,
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward,
                    color: AppColors.accent,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPurchaseDialog(BuildContext context, String title, String price) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: Text(
          "Purchase $title",
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        content: Text(
          "Are you sure you want to purchase $title for $price?",
          style: const TextStyle(color: AppColors.textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              "Cancel",
              style: TextStyle(color: AppColors.textPrimary),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("$title purchased successfully!"),
                ),
              );
            },
            child: const Text("Purchase"),
          ),
        ],
      ),
    );
  }
}
