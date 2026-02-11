import 'package:copia/core/router/app_router.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('routes to onboarding when onboarding not seen', () {
    final location = resolveInitialLocation(
      onboardingSeen: false,
      initialDocumentId: 10,
    );
    expect(location, '/onboarding');
  });

  test('routes to reader when onboarding seen and doc exists', () {
    final location = resolveInitialLocation(
      onboardingSeen: true,
      initialDocumentId: 42,
    );
    expect(location, '/reader/42');
  });

  test('routes to library when onboarding seen and no docs', () {
    final location = resolveInitialLocation(
      onboardingSeen: true,
      initialDocumentId: null,
    );
    expect(location, '/library');
  });

  test('redirects root slash to home location', () {
    final redirect = resolveGuardRedirect(
      location: '/',
      onboardingSeen: true,
      homeLocation: '/reader/7',
    );
    expect(redirect, '/reader/7');
  });

  test('redirects non-onboarding routes when onboarding is not seen', () {
    final redirect = resolveGuardRedirect(
      location: '/library',
      onboardingSeen: false,
      homeLocation: '/onboarding',
    );
    expect(redirect, '/onboarding');
  });

  test('redirects onboarding route after onboarding is completed', () {
    final redirect = resolveGuardRedirect(
      location: '/onboarding',
      onboardingSeen: true,
      homeLocation: '/library',
    );
    expect(redirect, '/library');
  });
}
