import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/storage/secure_storage.dart';
import '../cubit/payment_cubit.dart';
import '../cubit/payment_state.dart';

class PaymentForm extends StatefulWidget {
  const PaymentForm({super.key});

  @override
  State<PaymentForm> createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {

  final _formKey = GlobalKey<FormState>();

  final amountController = TextEditingController();
  final referenceController = TextEditingController();
  final dateController = TextEditingController();

  @override
  void dispose() {
    amountController.dispose();
    referenceController.dispose();
    dateController.dispose();
    super.dispose();
  }

  Future<void> pickDate() async {

    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime(2035),
      initialDate: DateTime.now(),
    );

    if (date != null) {

      dateController.text =
      "${date.year}-${date.month.toString().padLeft(2, "0")}-${date.day.toString().padLeft(2, "0")}";
    }
  }

  @override
  Widget build(BuildContext context) {

    return Card(

      elevation: 3,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),

      child: Padding(

        padding: const EdgeInsets.all(20),

        child: Form(

          key: _formKey,

          child: Column(

            children: [

              TextFormField(
                controller: amountController,

                keyboardType: TextInputType.number,

                decoration: const InputDecoration(
                  labelText: "Amount",
                  prefixIcon: Icon(Icons.payments),
                ),

                validator: (value) {

                  if(value==null || value.isEmpty){
                    return "Enter amount";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 18),

              TextFormField(

                controller: referenceController,

                decoration: const InputDecoration(

                  labelText: "Reference Number",

                  prefixIcon: Icon(Icons.receipt_long),

                ),

                validator: (value){

                  if(value==null || value.isEmpty){
                    return "Enter reference";
                  }

                  return null;

                },

              ),

              const SizedBox(height: 18),

              TextFormField(

                controller: dateController,

                readOnly: true,

                onTap: pickDate,

                decoration: const InputDecoration(

                  labelText: "Payment Date",

                  prefixIcon: Icon(Icons.calendar_month),

                ),

                validator: (value){

                  if(value==null || value.isEmpty){
                    return "Choose payment date";
                  }

                  return null;

                },

              ),

              const SizedBox(height: 28),

              SizedBox(

                width: double.infinity,

                height: 56,

                child: BlocBuilder<PaymentCubit,PaymentState>(

                  builder: (context,state){

                    if(state is PaymentLoading){

                      return const Center(
                        child: CircularProgressIndicator(),
                      );

                    }

                    return ElevatedButton(

                      style: ElevatedButton.styleFrom(

                        backgroundColor: const Color(0xff1A237E),

                        foregroundColor: Colors.white,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),

                      ),

                      onPressed: () async{

                        if(!_formKey.currentState!.validate()){
                          return;
                        }

                        final studentId =
                        await SecureStorage.getStudentId();

                        context.read<PaymentCubit>().createPayment(

                          studentId: studentId,

                          amount: double.parse(amountController.text),

                          referenceNumber:
                          referenceController.text,

                          paymentDate: dateController.text,

                        );

                      },

                      child: const Text(

                        "Pay Now",

                        style: TextStyle(

                          fontSize: 17,

                          fontWeight: FontWeight.bold,

                        ),

                      ),

                    );

                  },

                ),

              ),

            ],

          ),

        ),

      ),

    );

  }

}