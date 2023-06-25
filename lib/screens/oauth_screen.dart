import 'package:animephilic/authenication_bloc/authentication_handler_bloc_bloc.dart';
import 'package:animephilic/helpers/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showLogin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Center(
        child: Visibility(
          visible: !showLogin,
          replacement: const OAuthScreen(),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                showLogin = true;
              });
            },
            child: const Text("login to MAL"),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        BlocProvider.of<AuthenticationHandlerBloc>(context).add(
            const LoggedInAuthenticationHandlerBlocEvent(
                AuthenticationStatus.loggedIn));
      }),
    );
  }
}

class OAuthScreen extends StatefulWidget {
  const OAuthScreen({super.key});

  @override
  State<OAuthScreen> createState() => _OAuthScreenState();
}

class _OAuthScreenState extends State<OAuthScreen> {
  WebViewController? _webViewController;

  void setWebViewController() {
    _webViewController!.setJavaScriptMode(JavaScriptMode.unrestricted);
    _webViewController!.setUserAgent("Chrome/81.0.0.0 Mobile");
    _webViewController!.setNavigationDelegate(
      NavigationDelegate(
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith(Authentication().redirectURL)) {
            Uri uri = Uri.parse(request.url);
            if (Authentication().handleCodeFetch(
              uri.queryParameters['code'],
              uri.queryParameters['state'],
            )) {
              Authentication().handleAccessTokenFetch().then((value) {
                if (value) {
                  BlocProvider.of<AuthenticationHandlerBloc>(context).add(
                      const LoggedInAuthenticationHandlerBlocEvent(
                          AuthenticationStatus.loggedIn));
                }
              });
              return NavigationDecision.prevent;
            } else {
              _webViewController!.loadRequest(Authentication().authCodeURL);
            }
          }
          return NavigationDecision.navigate;
        },
      ),
    );
    _webViewController!.loadRequest(Authentication().authCodeURL);
  }

  @override
  void initState() {
    super.initState();
    PlatformWebViewControllerCreationParams params =
        const PlatformWebViewControllerCreationParams();
    _webViewController = WebViewController.fromPlatformCreationParams(params);
    setWebViewController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(controller: _webViewController!),
    );
  }
}
