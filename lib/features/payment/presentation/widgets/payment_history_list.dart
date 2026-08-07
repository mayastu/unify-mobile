import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unify/features/payment/presentation/widgets/payment_history_tile.dart';

import '../cubit/payment_cubit.dart';
import '../cubit/payment_state.dart';

class PaymentHistoryList extends StatelessWidget {
  const PaymentHistoryList({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<PaymentCubit,PaymentState>(

      builder: (context,state){

        if(state is PaymentLoading){

          return const Center(
            child: CircularProgressIndicator(),
          );

        }

        if(state is PaymentLoaded){

          if(state.payments.isEmpty){

            return const Center(
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Text("No Payments Yet"),
              ),
            );

          }

          return ListView.separated(

            shrinkWrap: true,

            physics: const NeverScrollableScrollPhysics(),

            itemBuilder: (_,index){

              return PaymentHistoryTile(
                payment: state.payments[index],

              );

            },

            separatorBuilder: (_,__)=>const SizedBox(height:12),

            itemCount: state.payments.length,

          );

        }

        return const SizedBox();

      },

    );

  }

}