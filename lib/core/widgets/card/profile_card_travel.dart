import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla/core/providers/auth_provider.dart';
import 'package:yalla/core/providers/user_profile_provider.dart';
import 'package:yalla/features/travel/profile/travel_profile_screen.dart';

class ProfileCardTravel extends StatelessWidget {
  const ProfileCardTravel({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final userData = authProvider.userData;
    final profile = userData?.profile;
    final String currentTravelId = userData?.userID ?? '';
    final String firstName = profile?.firstName ?? 'Memuat...';
    final String lastName = profile?.lastName ?? '';
    final String email = userData?.email ?? 'Memuat email...';

    final String fullName =
        lastName.isNotEmpty && lastName.toLowerCase() != "travel"
        ? "$firstName $lastName"
        : "$firstName Travel";

    final String? avatarUrl = context.watch<UserProfileProvider>().avatarUrl;

    return Container(
      height: 110,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/bg_profile.png',
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      image: DecorationImage(
                        image: (avatarUrl != null && avatarUrl.isNotEmpty)
                            ? NetworkImage(avatarUrl) as ImageProvider
                            : const AssetImage('assets/images/profile.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fullName,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.edit,
                        color: Color(0xFF003875),
                        size: 16,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: const Duration(
                              milliseconds: 300,
                            ),
                            reverseTransitionDuration: const Duration(
                              milliseconds: 300,
                            ),
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    TravelProfileScreen(
                                      travelId: currentTravelId,
                                    ),
                            transitionsBuilder:
                                (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) {
                                  var curvedAnimation = CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeOut,
                                  );

                                  return FadeTransition(
                                    opacity: curvedAnimation,
                                    child: child,
                                  );
                                },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
