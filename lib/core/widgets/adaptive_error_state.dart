import 'dart:ui';

import 'package:flutter/material.dart';

import '../responsive/responsive_helper.dart';

class AdaptiveErrorState extends StatelessWidget {
  final String title;

  final String? description;

  final IconData? icon;

  final VoidCallback? onRetry;

  final String? retryText;

  const AdaptiveErrorState({
    super.key,

    required this.title,

    this.description,

    this.icon,

    this.onRetry,

    this.retryText,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 20 : 28),

        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),

          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),

            child: Container(
              width: isMobile ? double.infinity : 520,

              padding: EdgeInsets.all(isMobile ? 24 : 32),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),

                gradient: LinearGradient(
                  begin: Alignment.topLeft,

                  end: Alignment.bottomRight,

                  colors: [
                    Colors.redAccent.withOpacity(0.08),

                    Colors.white.withOpacity(0.03),
                  ],
                ),

                border: Border.all(color: Colors.redAccent.withOpacity(0.12)),
              ),

              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  //////////////////////////////////////////////////////////
                  /// ICON
                  //////////////////////////////////////////////////////////
                  Container(
                    width: isMobile ? 72 : 86,

                    height: isMobile ? 72 : 86,

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,

                      color: Colors.redAccent.withOpacity(0.12),

                      border: Border.all(
                        color: Colors.redAccent.withOpacity(0.18),
                      ),
                    ),

                    child: Icon(
                      icon ?? Icons.error_outline,

                      color: Colors.redAccent,

                      size: isMobile ? 34 : 40,
                    ),
                  ),

                  SizedBox(height: isMobile ? 22 : 28),

                  //////////////////////////////////////////////////////////
                  /// TITLE
                  //////////////////////////////////////////////////////////
                  Text(
                    title,

                    textAlign: TextAlign.center,

                    style: TextStyle(
                      color: Colors.white,

                      fontSize: isMobile ? 18 : 22,

                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  //////////////////////////////////////////////////////////
                  /// DESCRIPTION
                  //////////////////////////////////////////////////////////
                  if (description != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 14),

                      child: Text(
                        description!,

                        textAlign: TextAlign.center,

                        style: TextStyle(
                          color: Colors.white.withOpacity(0.65),

                          fontSize: isMobile ? 13 : 15,

                          height: 1.6,
                        ),
                      ),
                    ),

                  //////////////////////////////////////////////////////////
                  /// RETRY
                  //////////////////////////////////////////////////////////
                  if (onRetry != null)
                    Padding(
                      padding: EdgeInsets.only(top: isMobile ? 26 : 30),

                      child: SizedBox(
                        width: isMobile ? double.infinity : 220,

                        height: 54,

                        child: ElevatedButton(
                          onPressed: onRetry,

                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF22D3EE),

                            foregroundColor: Colors.black,

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),

                          child: Text(
                            retryText ?? 'Retry',

                            style: const TextStyle(
                              fontWeight: FontWeight.w700,

                              fontSize: 15,
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
