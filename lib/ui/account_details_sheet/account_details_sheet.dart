import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sunshine/core/core.dart';
import 'package:sunshine/sunshine.dart';

import 'account_details_sheet_view_model.dart';

class AccountDetailsSheet extends StatelessWidget {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BaseWidget<AccountDetailsSheetViewModel>(
      onModelReady: (model) => model.loadAccount(),
      builder: (context, model, _) => Container(
        constraints: BoxConstraints(
          minHeight: 700.h.toDouble(),
        ),
        decoration: BoxDecoration(
          color: AppColors.mainBackground,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(22),
            topRight: Radius.circular(22),
          ),
        ),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 120.w.toDouble(),
                  vertical: 4.h.toDouble(),
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Divider(
                    thickness: 5.h.toDouble(),
                    color: Colors.black45,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 42.h.toDouble(),
                  left: 8.w.toDouble(),
                ),
                child: Column(
                  children: [
                    Text(
                      'Account',
                      style: TextStyle(
                        fontSize: 24.ssp.toDouble(),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 22.h.toDouble()),
                    Input(
                      hintText: 'First Name',
                      controller: _firstNameController
                        ..text = model.account?.firstName,
                    ),
                    SizedBox(height: 14.h.toDouble()),
                    Input(
                      hintText: 'Last Name',
                      controller: _lastNameController
                        ..text = model.account?.lastName,
                    ),
                    SizedBox(height: 22.h.toDouble()),
                    Button(
                      text: 'Save',
                      variant: ButtonVariant.thin,
                      onPressed: () {
                        final firstName = _firstNameController.value.text;
                        final lastName = _lastNameController.value.text;
                        debugPrint(firstName);
                        debugPrint(lastName);
                        model
                          ..setFirstName(firstName)
                          ..setLastName(lastName);
                        Navigator.of(context).pop();
                      },
                    ),
                    SizedBox(height: 32.h.toDouble()),
                    Row(
                      children: [
                        Expanded(
                          child: Input(
                            readOnly: true,
                            hintText: model.account?.address ??
                                '0x235985604983045987FA13....',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: CopyAddressToClipboard(
                            text: model.account?.address ?? '',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 48.h.toDouble()),
                    Button(
                      text: 'Show Public Key QR Code',
                      variant: ButtonVariant.thin,
                      onPressed: () {
                        // TODO(shekohex): make use of public key qr code from keystore!
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CopyAddressToClipboard extends StatefulWidget {
  const CopyAddressToClipboard({
    Key key,
    this.text,
  }) : super(key: key);

  final String text;

  @override
  _CopyAddressToClipboardState createState() => _CopyAddressToClipboardState();
}

class _CopyAddressToClipboardState extends State<CopyAddressToClipboard> {
  bool _copied = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Clipboard.setData(
          ClipboardData(
            text: widget.text,
          ),
        );
        setState(() {
          _copied = true;
        });
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            _copied = false;
          });
        });
      },
      child: AnimatedCrossFade(
        firstChild: Icon(
          Icons.assignment,
          color: AppColors.secondry,
          size: 32.ssp.toDouble(),
        ),
        crossFadeState:
            _copied ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        duration: const Duration(milliseconds: 200),
        secondChild: Icon(
          Icons.check,
          color: AppColors.success,
          size: 32.ssp.toDouble(),
        ),
      ),
    );
  }
}
