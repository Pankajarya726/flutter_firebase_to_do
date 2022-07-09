import 'package:flutter/material.dart';
import 'package:to_do/utils/database.dart';
import 'package:to_do/utils/validator.dart';
import 'package:to_do/widget/CustomColors.dart';
import 'package:to_do/widget/custom_form_field.dart';

class EditNoteScreen extends StatefulWidget {
  final String currentTitle;
  final String currentDescription;
  final String documentId;

  const EditNoteScreen({Key? key, required this.currentTitle, required this.currentDescription, required this.documentId})
      : super(key: key);

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final FocusNode _titleFocusNode = FocusNode();

  final FocusNode _descriptionFocusNode = FocusNode();

  bool _isDeleting = false;
  final _editItemFormKey = GlobalKey<FormState>();

  bool _isProcessing = false;

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  @override
  void initState() {
    _titleController = TextEditingController(
      text: widget.currentTitle,
    );

    _descriptionController = TextEditingController(
      text: widget.currentDescription,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _titleFocusNode.unfocus();
        _descriptionFocusNode.unfocus();
      },
      child: Scaffold(
        backgroundColor: CustomColors.firebaseNavy,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: CustomColors.firebaseNavy,
          title: Text(
            'Edit Note',
            style: TextStyle(
              color: CustomColors.firebaseYellow,
              fontSize: 18,
            ),
          ),
          actions: [
            _isDeleting
                ? Padding(
                    padding: const EdgeInsets.only(
                      top: 10.0,
                      bottom: 10.0,
                      right: 16.0,
                    ),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.redAccent,
                      ),
                      strokeWidth: 3,
                    ),
                  )
                : IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.redAccent,
                      size: 32,
                    ),
                    onPressed: () async {
                      setState(() {
                        _isDeleting = true;
                      });

                      await Database.deleteItem(
                        docId: widget.documentId,
                      );

                      setState(() {
                        _isDeleting = false;
                      });

                      Navigator.of(context).pop();
                    },
                  ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 20.0,
            ),
            child: Form(
              key: _editItemFormKey,
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
                        SizedBox(height: 24.0),
                        Text(
                          'Title',
                          style: TextStyle(
                            color: CustomColors.firebaseGrey,
                            fontSize: 22.0,
                            letterSpacing: 1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        CustomFormField(
                          isLabelEnabled: false,
                          controller: _titleController,
                          focusNode: _titleFocusNode,
                          keyboardType: TextInputType.text,
                          inputAction: TextInputAction.next,
                          validator: (value) => Validator.validateField(
                            value: value,
                          ),
                          label: 'Title',
                          hint: 'Enter your note title',
                        ),
                        SizedBox(height: 24.0),
                        Text(
                          'Description',
                          style: TextStyle(
                            color: CustomColors.firebaseGrey,
                            fontSize: 22.0,
                            letterSpacing: 1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        CustomFormField(
                          maxLines: 10,
                          isLabelEnabled: false,
                          controller: _descriptionController,
                          focusNode: _descriptionFocusNode,
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
                              _titleFocusNode.unfocus();
                              _descriptionFocusNode.unfocus();

                              if (_editItemFormKey.currentState!.validate()) {
                                setState(() {
                                  _isProcessing = true;
                                });

                                await Database.updateItem(
                                  docId: widget.documentId,
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
                              padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                              child: Text(
                                'UPDATE NOTE',
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
            ),
          ),
        ),
      ),
    );
  }
}
