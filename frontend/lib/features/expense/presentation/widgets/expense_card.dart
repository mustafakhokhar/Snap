import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/expense/domain/entity/expense.dart';
import 'package:frontend/features/expense/presentation/cubits/expense_cubit.dart';

Widget buildExpenseCard(BuildContext context, Expense expense,
    {bool showDivider = true}) {
  final cs = Theme.of(context).colorScheme;
  final textTheme = Theme.of(context).textTheme;
  final timeLabel = TimeOfDay.fromDateTime(expense.date).format(context);

  final keyStr = (/* if you have */ (expense as dynamic).id?.toString() ?? '')
      .toString()
      .trim();
  final dismissKey = ValueKey(keyStr.isNotEmpty
      ? 'exp-$keyStr'
      : 'exp-${expense.title}-${expense.date.microsecondsSinceEpoch}-${expense.amount}');

  return Dismissible(
    key: dismissKey,
    direction: DismissDirection.endToStart,
    background: Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.red.withOpacity(0.15),
      child: const Icon(Icons.delete_outline, color: Colors.red),
    ),
    confirmDismiss: (_) async {
      // Optional: show a confirm dialog
      return true;
    },
    onDismissed: (_) async {
      // 🔗 Hook to your cubit; rename methods if needed
      final cubit = context.read<ExpenseCubit>();
      // await cubit.deleteExpense(/* expense.id */ expense); // if delete by id, pass id

      // Undo snackbar
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Expense deleted'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () async {
              // Provide a way to restore; rename to your cubit API
              // await cubit.upsertExpense(expense);
              // or: await cubit.addExpense(expense);
            },
          ),
          duration: const Duration(seconds: 4),
        ),
      );
    },
    child: RepaintBoundary(
      child: Material(
        color: cs.surface,
        child: InkWell(
          onTap: () {
            // TODO: open details / edit
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: cs.surfaceVariant.withOpacity(0.35),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        iconForExpense(expense),
                        size: 20,
                        color: cs.onSurface.withOpacity(0.80),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            expense.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            expense.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodySmall?.copyWith(
                              color: cs.onSurface.withOpacity(0.6),
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Rs ${expense.amount.toStringAsFixed(0)}',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontFeatures: const [FontFeature.tabularFigures()],
                            color: cs.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          timeLabel,
                          style: textTheme.bodySmall?.copyWith(
                            color: cs.onSurface.withOpacity(0.55),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (showDivider) ...[
                  const SizedBox(height: 12),
                  Divider(
                    height: 1,
                    thickness: 0.6,
                    indent: 48,
                    color: cs.outlineVariant.withOpacity(0.6),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

// Widget buildExpenseCard(BuildContext context, Expense expense,
//     {bool showDivider = true}) {
//   final cs = Theme.of(context).colorScheme;
//   final textTheme = Theme.of(context).textTheme;
//   final timeLabel = TimeOfDay.fromDateTime(expense.date).format(context);

//   // minimal, native-feel tile (no Card)
//   return RepaintBoundary(
//     child: Material(
//       color: cs.surface, // matches list background
//       child: InkWell(
//         onTap: () {
//           // TODO: open details / edit
//         },
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   // small leading icon chip (subtle, neutral)
//                   Container(
//                     width: 36,
//                     height: 36,
//                     decoration: BoxDecoration(
//                       color: cs.surfaceVariant.withOpacity(0.35),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     alignment: Alignment.center,
//                     child: Icon(
//                       iconForExpense(expense),
//                       size: 20,
//                       color: cs.onSurface.withOpacity(0.80),
//                     ),
//                   ),
//                   const SizedBox(width: 12),

//                   // title + description
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           expense.title,
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: textTheme.titleMedium?.copyWith(
//                             fontWeight: FontWeight.w600,
//                             height: 1.2,
//                           ),
//                         ),
//                         const SizedBox(height: 2),
//                         Text(
//                           expense.description,
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: textTheme.bodySmall?.copyWith(
//                             color: cs.onSurface.withOpacity(0.6),
//                             height: 1.1,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(width: 12),

//                   // amount + time (right aligned)
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Text(
//                         'Rs ${expense.amount.toStringAsFixed(0)}',
//                         style: textTheme.titleMedium?.copyWith(
//                           fontWeight: FontWeight.w700,
//                           // tabular figures keep digits aligned -> looks crisp when scrolling
//                           fontFeatures: const [FontFeature.tabularFigures()],
//                           color: cs.onSurface,
//                         ),
//                       ),
//                       const SizedBox(height: 2),
//                       Text(
//                         timeLabel,
//                         style: textTheme.bodySmall?.copyWith(
//                           color: cs.onSurface.withOpacity(0.55),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               if (showDivider) ...[
//                 const SizedBox(height: 12),
//                 // hairline divider that lines up under text, not under the icon chip
//                 Divider(
//                   height: 1,
//                   thickness: 0.6,
//                   indent: 48, // 36 icon + 12 gap
//                   color: cs.outlineVariant.withOpacity(0.6),
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ),
//     ),
//   );
// }

IconData iconForExpense(Expense e) {
  final t = e.title.toLowerCase();
  if (t.contains('grocery') || t.contains('market')) {
    return Icons.local_grocery_store_outlined;
  }
  if (t.contains('restaurant') || t.contains('food') || t.contains('coffee')) {
    return Icons.restaurant_outlined;
  }
  if (t.contains('transport') ||
      t.contains('bus') ||
      t.contains('uber') ||
      t.contains('taxi')) {
    return Icons.directions_bus_outlined;
  }
  if (t.contains('shopping') || t.contains('clothes')) {
    return Icons.shopping_bag_outlined;
  }
  if (t.contains('bill') || t.contains('utility')) {
    return Icons.receipt_long_outlined;
  }
  return Icons.wallet_outlined;
}
