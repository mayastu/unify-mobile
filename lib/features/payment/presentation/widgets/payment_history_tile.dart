import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/payment_model.dart';
import '../cubit/payment_cubit.dart';
import '../pages/payment_details_page.dart';

class PaymentHistoryTile extends StatelessWidget {

  final PaymentModel payment;

  const PaymentHistoryTile({
    super.key,
    required this.payment,
  });

  @override
  Widget build(BuildContext context) {

    return Card(

      elevation: 2,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),

      child: ListTile(

        leading: CircleAvatar(

          radius: 25,

          backgroundColor:
          const Color(0xff1A237E),

          child: const Icon(

            Icons.payments,

            color: Colors.white,

          ),

        ),

        title: Text(

          "\$${payment.amount}",

          style: const TextStyle(

            fontWeight: FontWeight.bold,

            fontSize: 18,

          ),

        ),

        subtitle: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,


          children: [

            const SizedBox(height:6),

            Text(
              payment.referenceNumber,
            ),

            Text(
              payment.paymentDate,
            ),

          ],

        ),

        trailing: const Icon(
          Icons.chevron_right,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<PaymentCubit>(),
                child: PaymentDetailsPage(
                  paymentId:int.parse( payment.id),
                ),
              ),
            ),
          );
  },

      ),

    );

  }

}