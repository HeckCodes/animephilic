import 'package:animephilic/authenication_bloc/authentication_handler_bloc_bloc.dart';
import 'package:animephilic/helpers/authentication.dart';
import 'package:animephilic/helpers/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      appBar: AppBar(
        title: const Text("Login"),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent,
        ),
      ),
      body: Visibility(
        visible: !showLogin,
        replacement: const OAuthScreen(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Text(
                  "Animephilic",
                  style: Theme.of(context).primaryTextTheme.headlineMedium,
                ),
                const SizedBox(height: 24),
                Text(
                  Constants.welcomeMessage,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).primaryTextTheme.bodyLarge,
                ),
                const Spacer(),
                FilledButton(
                  onPressed: () {
                    setState(() {
                      showLogin = true;
                    });
                  },
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "Login with MyAnimeList",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  "Developed by HeckCodes",
                  style: Theme.of(context).primaryTextTheme.bodySmall,
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
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
