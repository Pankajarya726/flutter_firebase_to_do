import 'package:flutter/material.dart';
import 'package:to_do/utils/database.dart';
import 'package:to_do/utils/validator.dart';
import 'package:to_do/widget/custom_form_field.dart';

import '../widget/CustomColors.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({Key? key}) : super(key: key);

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final FocusNode titleFocusNode = FocusNode();
  final FocusNode descriptionFocusNode = FocusNode();
  final _addItemFormKey = GlobalKey<FormState>();

  bool _isProcessing = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.firebaseNavy,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: CustomColors.firebaseNavy,
        title: const Text("Add Note"),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 20.0,
            ),
            child: Form(
              key: _addItemFormKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                      right: 8.0,
                      bottom: 24.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24.0),
                        Text(
                          'Title',
                          style: TextStyle(
                            color: CustomColors.firebaseGrey,
                            fontSize: 22.0,
                            letterSpacing: 1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        CustomFormField(
                          isLabelEnabled: false,
                          controller: _titleController,
                          focusNode: titleFocusNode,
                          keyboardType: TextInputType.text,
                          inputAction: TextInputAction.next,
                          validator: (value) => Validator.validateField(
                            value: value,
                          ),
                          label: 'Title',
                          hint: 'Enter your note title',
                        ),
                        const SizedBox(height: 24.0),
                        Text(
                          'Description',
                          style: TextStyle(
                            color: CustomColors.firebaseGrey,
                            fontSize: 22.0,
                            letterSpacing: 1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        CustomFormField(
                          maxLines: 10,
                          isLabelEnabled: false,
                          controller: _descriptionController,
                          focusNode: descriptionFocusNode,
                          keyboardType: TextInputType.text,
                          inputAction: TextInputAction.done,
                          validator: (value) => Validator.validateField(
                            value: value,
                          ),
                          label: 'Description',
                          hint: 'Enter your note description',
                        ),
                      ],
                    ),
                  ),
                  _isProcessing
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              CustomColors.firebaseOrange,
                            ),
                          ),
                        )
                      : Container(
                          width: double.maxFinite,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                CustomColors.firebaseOrange,
                              ),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            onPressed: () async {
                              titleFocusNode.unfocus();
                              descriptionFocusNode.unfocus();

                              if (_addItemFormKey.currentState!.validate()) {
                                setState(() {
                                  _isProcessing = true;
                                });

                                await Database.addItem(
                                  title: _titleController.text,
                                  description: _descriptionController.text,
                                );

                                setState(() {
                                  _isProcessing = false;
                                });

                                Navigator.of(context).pop();
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                              child: Text(
                                'ADD NOTE',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: CustomColors.firebaseGrey,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            )),
      ),
    );
  }
}
