import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:muslim_pocket/blocs/blocs.dart';
import 'package:muslim_pocket/config/configs.dart';
import 'package:muslim_pocket/helpers/helpers.dart';
import 'package:muslim_pocket/ui/screens/screens.dart';
import 'package:muslim_pocket/ui/widgets/widgets.dart';

class UserDetailScreen extends StatefulWidget {
  @override
  _UserDetailScreenState createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  late UserBloc _userBloc;
  final GlobalKey<FormState> _form = GlobalKey();
  final TextEditingController _nameController = TextEditingController();
  String? _imageProfile;
  String? _imagePathToUpload;

  @override
  void initState() {
    _userBloc = BlocProvider.of<UserBloc>(context);

    UserState state = _userBloc.state;
    if (state is UserLoginSuccess) {
      String name = state.name;

      _nameController.text = name;
      _imageProfile = state.imageProfile;
    }

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();

    super.dispose();
  }

  Future<void> _getImage(ImgSource source) async {
    var image = await ImagePickerGC.pickImage(
      context: context,
      source: source,
    );

    if (image != null) {
      setState(() => _imagePathToUpload = image.path);
    }
  }

  void _editPhotoAction() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MaterialButton(
                  onPressed: () {
                    _getImage(ImgSource.Camera);
                    Get.back();
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.camera,
                        color: Theme.of(context).accentColor,
                      ),
                      const SizedBox(width: 10.0),
                      Text(Word.getImageFromCamera),
                    ],
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    _getImage(ImgSource.Gallery);
                    Get.back();
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.collections,
                        color: Theme.of(context).accentColor,
                      ),
                      const SizedBox(width: 10.0),
                      Text(Word.getImageFromGallery),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _saveAction() {
    if (_form.currentState!.validate()) {
      FocusScope.of(context).unfocus();

      String name = _nameController.text.trim();
      _userBloc.add(
          UserUpdateProfile(name: name, imageToUpload: _imagePathToUpload));
    }
  }

  void _logoutAction() {
    _userBloc.add(UserLogout());
  }

  void _userListener(BuildContext context, UserState state) {
    if (state is UserUninitialized) {
      Get.offAll(() => SplashScreen());
    } else if (state is UserLoginSuccess) {
      _nameController.text = state.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: _userListener,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(Word.editProfile),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Measure.horizontalPadding,
              vertical: Measure.verticalPadding),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: 250.0,
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      shape: BoxShape.circle,
                      boxShadow: Pallette.boxShadow,
                    ),
                    child: CircleAvatar(
                      foregroundColor: Theme.of(context).accentColor,
                      radius: 80.0,
                      child: CircleAvatar(
                        foregroundImage: (_imagePathToUpload != null
                                ? FileImage(File(_imagePathToUpload!))
                                : _imageProfile != null
                                    ? CachedNetworkImageProvider(_imageProfile!)
                                    : AssetImage(Asset.profilePicture))
                            as ImageProvider,
                        radius: 77.0,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: MaterialButton(
                      onPressed: _editPhotoAction,
                      minWidth: 0.0,
                      shape: CircleBorder(),
                      color: Theme.of(context).accentColor,
                      padding: const EdgeInsets.all(7.0),
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30.0),
              Form(
                key: _form,
                child: TextFormField(
                  controller: _nameController,
                  validator: Validation.inputRequired,
                  decoration: InputDecoration(
                    hintText: 'Nama',
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25.0),
              BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  if (state is UserLoading) {
                    return PrimaryButton.loading();
                  }

                  return PrimaryButton(
                    label: Word.save,
                    onPressed: _saveAction,
                  );
                },
              ),
              const Spacer(),
              TertiaryButton(
                label: Word.logout,
                onPressed: _logoutAction,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
