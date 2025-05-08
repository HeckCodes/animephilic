import 'package:animephilic/authentication/authentication_exports.dart';
import 'package:animephilic/database/database_export.dart';

import 'package:animephilic/helpers/helpers_exports.dart';
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
                const Text(
                  "Animephilic",
                  style: TextStyle(fontSize: 36),
                ),
                const SizedBox(height: 24),
                Text(
                  Constants.welcomeMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
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
                const SizedBox(height: 16),
                const Text(
                  "Developed by HeckCodes",
                  style: TextStyle(fontSize: 12),
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
    _webViewController!.setUserAgent(
        "Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.5735.196 Mobile Safari/537.36");
    _webViewController!.setNavigationDelegate(
      NavigationDelegate(
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith(Authentication().redirectURL)) {
            Uri uri = Uri.parse(request.url);
            if (Authentication().handleCodeFetch(
              uri.queryParameters['code'],
              uri.queryParameters['state'],
            )) {
              () async {
                bool value = await Authentication().handleAccessTokenFetch();
                if (!mounted) return;
                if (value) {
                  BlocProvider.of<AuthenticationHandlerBloc>(context)
                      .add(const AuthenticationHandlerEventLoggedIn(AuthenticationStatus.loggedIn));
                  BlocProvider.of<UserAccountInformationBloc>(context).add(UserAccountInformationEventFetchData());
                }
              }();
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
    PlatformWebViewControllerCreationParams params = const PlatformWebViewControllerCreationParams();
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
