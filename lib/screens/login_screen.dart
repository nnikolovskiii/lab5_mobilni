import 'package:flutter/material.dart';
import 'package:lab3/screens/grid_view_user_screen.dart';

import '../repository/repository.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login/Register Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: LoginForm(),
      ),
    );
  }
}

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Center(
        child: RegisterForm(),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  Repository repository = Repository();



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: 'Username',
            ),
          ),
          SizedBox(height: 20.0),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
            ),
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () async {
              String email = _usernameController.text;
              String password = _passwordController.text;
              await repository.signIn(email, password);
              // Perform login logic here
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => YourWidgetUser()), // Replace YourOtherScreen() with the screen you want to navigate to
              );
            },
            child: Text('Login'),
          ),
          SizedBox(height: 20.0),
          TextButton(
            onPressed: () {
              // Navigate to the Register screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegisterScreen()),
              );
            },
            child: Text('Create an account'),
          ),
        ],
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  Repository repository = Repository();


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: 'Username',
            ),
          ),
          SizedBox(height: 20.0),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
            ),
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () async {
              String email = _usernameController.text;
              String password = _passwordController.text;

              await repository.signUp(email, password);
              // Perform registration logic here
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => YourWidgetUser()), // Replace YourOtherScreen() with the screen you want to navigate to
              );
            },
            child: Text('Register'),
          ),
          SizedBox(height: 20.0),
          TextButton(
            onPressed: () {
              // Navigate to the Login screen
              Navigator.pop(context);
            },
            child: Text('Already have an account? Log in'),
          ),
        ],
      ),
    );
  }
}
