import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';

class CalendarService {
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  Future<bool> addTaskToCalendar({
    required String title,
    required String description,
    required DateTime dueDate,
  }) async {
    try {
      //Grab the user. (Throws an exception if they cancel the login popup)
      final googleUser = await _googleSignIn.authenticate();
      
      //Define the Calendar scope
      final scopes = ['https://www.googleapis.com/auth/calendar.events'];

      //Check if they have already granted Improov calendar access
      var authorization = await googleUser.authorizationClient.authorizationForScopes(scopes);
      
      //If not, pop up the consent screen. (Throws an exception if they hit "Deny")
      authorization ??= await googleUser.authorizationClient.authorizeScopes(scopes);

      //Convert the authorization into an authenticated HTTP client
      final httpClient = authorization.authClient(scopes: scopes);

      //Spin up the Calendar API
      final calendarApi = calendar.CalendarApi(httpClient);

      //Construct the Event payload
      final event = calendar.Event(
        summary: "Improov: $title",
        description: description,
        start: calendar.EventDateTime(
          dateTime: dueDate.toUtc(),
          timeZone: "UTC",
        ),
        end: calendar.EventDateTime(
          dateTime: dueDate.add(const Duration(hours: 1)).toUtc(),
          timeZone: "UTC",
        ),
      );

      //Fire the POST request to the user's Google Calendar
      final createdEvent = await calendarApi.events.insert(event, "primary");
      
      if (createdEvent.id != null) {
        debugPrint("Successfully synced to Google Cloud! Event ID: ${createdEvent.id}");
        return true;
      }
      return false;

    } catch (e) {
      //catches ANY cancellation or denial from the user
      debugPrint("Google API / Authorization Error: $e");
      return false;
    }
  }
}