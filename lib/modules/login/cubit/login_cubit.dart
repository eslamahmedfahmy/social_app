import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/login/cubit/login_states.dart';
import 'package:social_app/shared/components/constants.dart';



class LoginCubit extends Cubit<LoginStates>{
  LoginCubit():super(InitializeLoginState());
  static LoginCubit get(context)=>BlocProvider.of(context);

  bool isPassword=true;
  void changeVisibility(){
    isPassword=!isPassword;
    emit(ChangeVisibilityState());
  }
  void loginUser({
    required String email,
    required String password,
  }) {
    emit(LoadingLoginState());
    FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    ).then((value) {
      myId=value.user!.uid;

      emit(SuccessesLoginState());
    }).catchError((error){
      emit(ErrorLoginState(error.toString()));
    });
  }

  bool forgotPassword=false;
  void changeForgotPassword(){
    forgotPassword=!forgotPassword;
    emit(LoginChangeForgotPasswordState());

  }

  void resetPassword({
    required String email,
  }){
    FirebaseAuth.instance.sendPasswordResetEmail(email:email).then((value){
      emit(LoginResetPasswordSuccessState());

    }).catchError((error){
      emit(LoginResetPasswordErrorState(error.toString().split(']')[1]));
    });
  }


  void jumpTo(){
    emit(JumpToState());
  }


}