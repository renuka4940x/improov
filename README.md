Improov

A high-performance, offline-first productivity powerhouse.
Improov is an Android productivity application designed to bridge the gap between complex task management and intuitive habit tracking. Built with a "Product Engineer" mindset, the app prioritizes a seamless, low-latency user experience through an offline-first architecture and performance-tuned UI.


Key Features

Offline-First Reliability: Built using Isar as an embedded NoSQL database, ensuring the app remains fully functional regardless of internet connectivity.

Seamless Cloud Sync: Engineered a synchronization pipeline that pushes local data to PostgreSQL via Firebase Data Connect for secure, cross-device persistence.

Extreme Performance: Optimized the Flutter render pipeline to maintain a stable 120Hz refresh rate, providing fluid interactions on mid-range Android devices.

Robust Security: Implemented a multi-layered Firebase Authentication flow featuring secure session management and Google Sign-In.

Pro-Tier Monetization: Integrated RevenueCat to manage subscription logic, enabling a freemium model ahead of the production launch.

Automated Analytics (WIP): Backend pipeline in development to aggregate habit data and distribute monthly insight reports via email.


Tech Stack

Frontend: Flutter & Dart.

State Management: Riverpod (Reactive architecture).

Navigation: go_router.

Local Database: Isar (NoSQL).

Cloud Database: PostgreSQL & Firebase Firestore.

Backend: Firebase (Auth, Cloud Functions, Data Connect).

Infrastructure: RevenueCat, GitHub Actions (CI/CD), Google Play Console.

Design: Figma.


Architecture

The project follows a clean, reactive architecture enforced by Riverpod, ensuring a strict separation of concerns between UI, business logic, and data layers.
By decoupling the local storage layer (Isar) from the remote persistence layer (PostgreSQL), Improov provides instantaneous UI updates while maintaining eventual consistency across the cloud.

Status & Deployment

Development Stage: Beta / Production-Prep.

Platform: Android.

Play Store Status: Environment fully configured with a verified Google Play Console developer account.
