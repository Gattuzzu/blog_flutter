import 'package:blog_beispiel/ui/profile/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget{
  final VoidCallback onPressed;
  const Profile({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileViewModel>();
    return Center(
      child: Column(
        children: [
          TextButton(
            onPressed: () => onPressedInternal(viewModel),
            child: viewModel.isAutenticated
              ? Text("Logoff")
              : Text("Login"),
          ),
          if(viewModel.isAutenticated)
            Text("Eingeloggt als: ${viewModel.userName}"),
        ],
      )
    );
  }

  void onPressedInternal(ProfileViewModel viewModel){
    if(viewModel.isAutenticated){
      viewModel.logout();

    } else {
      viewModel.login();
    }

    onPressed();
  }

}