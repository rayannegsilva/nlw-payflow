import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:payflow/modules/insert_boleto/insert_boleto_controller.dart';
import 'package:payflow/shared/themes/app_colors.dart';
import 'package:payflow/shared/themes/app_text_styles.dart';
import 'package:payflow/shared/widgets/input_text/input_text_widget.dart';
import 'package:payflow/shared/widgets/set_label_buttons/set_label_buttons.dart';

class InsertBoletoPage extends StatefulWidget {
  final String? barcode;
  const InsertBoletoPage({Key? key, this.barcode}) : super(key: key);

  @override
  _InsertBoletoPageState createState() => _InsertBoletoPageState();
}

class _InsertBoletoPageState extends State<InsertBoletoPage> {
  final controller = InsertBoletoController();

  final moneyInputTextController =
      MoneyMaskedTextController(leftSymbol: "R\$", decimalSeparator: ",");
  final dueDateInputTextController = MaskedTextController(mask: "00/00/0000");
  final barcodeInputTextController = TextEditingController();

  @override
  void initState() {
    if (widget.barcode != null) {
      barcodeInputTextController.text = widget.barcode!;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: BackButton(
            color: AppColors.input,
            onPressed: () {
              Navigator.pushReplacementNamed(context, "/home");
            }),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 93, vertical: 24),
                child: Text(
                  "Peencha os Dados do Boleto",
                  style: TextStyles.titleBoldHeading,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 24),
              Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    InputTextWidget(
                      validator: controller.validateName,
                      icon: Icons.description_outlined,
                      label: 'Nome do Boleto',
                      onChanged: (String value) {
                        controller.onChanged(name: value);
                      },
                    ),
                    InputTextWidget(
                      validator: controller.validateVencimento,
                      controller: dueDateInputTextController,
                      icon: FontAwesomeIcons.timesCircle,
                      label: 'Vencimento',
                      onChanged: (String value) {
                        controller.onChanged(dueDate: value);
                      },
                    ),
                    InputTextWidget(
                      validator: (_) => controller
                          .validateValor(moneyInputTextController.numberValue),
                      controller: moneyInputTextController,
                      icon: FontAwesomeIcons.wallet,
                      label: 'Valor',
                      onChanged: (String value) {
                        controller.onChanged(
                            value: moneyInputTextController.numberValue);
                      },
                    ),
                    InputTextWidget(
                      validator: controller.validateCodigo,
                      controller: barcodeInputTextController,
                      icon: FontAwesomeIcons.barcode,
                      label: 'Código',
                      onChanged: (String value) {
                        controller.onChanged(barcode: value);
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: SetLabelButtons(
        enableSecondaryColor: true,
        primaryLabel: "Cancelar",
        primaryOnPressed: () {
          Navigator.pushReplacementNamed(context, '/home');
        },
        secondaryLabel: "Cadastrar",
        secondaryOnPressed: () async {
          await controller.cadastrarBoleto();
          Navigator.pushReplacementNamed(context, '/home');
        },
      ),
    );
  }
}
