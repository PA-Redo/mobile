import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:pa_mobile/core/model/beneficiary/beneficiary_response_dto.dart';
import 'package:pa_mobile/core/model/event/EventResponseDTO.dart';
import 'package:pa_mobile/flows/authentication/ui/login_screen.dart';
import 'package:pa_mobile/flows/event/logic/event.dart';
import 'package:pa_mobile/flows/event/ui/event_detail_screen.dart';
import 'package:pa_mobile/shared/services/storage/jwt_secure_storage.dart';
import 'package:pa_mobile/shared/services/storage/secure_storage.dart';
import 'package:pa_mobile/shared/services/storage/stay_login_secure_storage.dart';
import 'package:table_calendar/table_calendar.dart';

class MyEventScreen extends StatefulWidget {
  const MyEventScreen({super.key});

  static const routeName = '/event';

  @override
  State<MyEventScreen> createState() => _MyEventScreenState();
}

class _MyEventScreenState extends State<MyEventScreen> {
  DateTime _selectedDay = DateTime.now();

  late GoogleSignIn _googleSignIn;

  GoogleSignInAccount? _currentUser;

  static const _scopes = [calendar.CalendarApi.calendarScope];

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      if (kDebugMode) {
        print('Error occured while signing in');
        print(error);
      }
    }
  }

  Future<void> _handleSignOut() async {
    try {
      await _googleSignIn.disconnect();
    } catch (error) {
      if (kDebugMode) {
        print('Error occured while signing out');
        print(error);
      }
    }
  }

  CalendarFormat _calendarFormat = CalendarFormat.month;
  List<EventResponseDTO> localUnitEvents = [];
  late final ValueNotifier<List<EventResponseDTO>> selectedEvent;

  late BeneficiaryResponseDto beneficiary;

  List<EventResponseDTO> _getEventsForDay(DateTime day) {
    return localUnitEvents.where((event) => isSameDay(event.start, day)).toList();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
      });

      selectedEvent.value = _getEventsForDay(selectedDay);
    }
  }

  Future<List<EventResponseDTO>> load() async {
    final res = await Future.wait([EventLogic.getConnectBeneficiary()]);

    beneficiary = res[0];
    await SecureStorage.set('benef_name', beneficiary.username);
    await SecureStorage.set('benef_id', beneficiary.id.toString());
    return EventLogic.getLocalUnitEventOfBenef(beneficiary.localUnitId.toString(), beneficiary.id);
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    selectedEvent = ValueNotifier(_getEventsForDay(_selectedDay));
    if (Platform.isAndroid) {
      _googleSignIn = GoogleSignIn(
        scopes: _scopes,
      );
    } else if (Platform.isIOS) {
      _googleSignIn = GoogleSignIn(
        scopes: _scopes,
      );
    }
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
  }

  @override
  void dispose() {
    selectedEvent.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: load(),
      builder: (context, AsyncSnapshot<List<EventResponseDTO>> snapshot) {
        if (snapshot.hasError) {
          JwtSecureStorage().deleteJwtToken();
          StayLoginSecureStorage().notStayLogin();
          Navigator.pushNamedAndRemoveUntil(
            context,
            LoginScreen.routeName,
            (route) => false,
          );
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        localUnitEvents = snapshot.data!;
        selectedEvent.value = _getEventsForDay(_selectedDay);
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              surface: Colors.blueGrey,
              onSurface: Colors.yellow,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Spacer(),
                  Visibility(
                    visible: _currentUser != null,
                    child: ElevatedButton(
                      onPressed: () async {
                        final googleUser = await _googleSignIn.signIn();
                        if (googleUser != null) {
                          var httpClient = (await _googleSignIn.authenticatedClient())!;
                          final calendarApi = calendar.CalendarApi(httpClient);
                          const calendarId = 'primary';
                          final events = (await calendarApi.events.list(calendarId))
                              .items!
                              .where((e) => e.summary!.startsWith('PA'))
                              .toList();
                          for (final event in events) {
                            try {
                              await calendarApi.events.delete(calendarId, event.id!);
                            } catch (e) {
                              print(e);
                            }
                          }
                          //create event for each event in local unit

                          for (var event in localUnitEvents) {
                            final calendarEvent = calendar.Event();
                            calendarEvent.summary = "PA : " + event.name;
                            calendarEvent.description = event.description;
                            calendarEvent.start = calendar.EventDateTime()..dateTime = event.start;
                            calendarEvent.end = calendar.EventDateTime()..dateTime = event.end;
                            calendarEvent.reminders = calendar.EventReminders()..useDefault = false;
                            try {
                              await calendarApi.events.insert(calendarEvent, calendarId);
                            } catch (e) {
                              print(e);
                            }
                          }
                        }
                      },
                      child: const Text('Sync with Google Calendar'),
                    ),
                  ),
                  if (_currentUser != null)
                    const SizedBox(
                      width: 20,
                    ),
                  if (_currentUser != null)
                    ElevatedButton(
                      onPressed: _handleSignOut,
                      child: const Text('Sign out'),
                    )
                  else
                    ElevatedButton(
                      onPressed: _handleSignIn,
                      child: const Text('Sign in'),
                    ),
                  const Spacer(),
                ],
              ),
              TableCalendar<EventResponseDTO>(
                calendarStyle: const CalendarStyle(
                  outsideDaysVisible: false,
                  rangeHighlightColor: Colors.red,
                ),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                ),
                firstDay: DateTime.utc(1999),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: _selectedDay,
                locale: 'fr_FR',
                startingDayOfWeek: StartingDayOfWeek.monday,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                calendarFormat: _calendarFormat,
                onDaySelected: _onDaySelected,
                eventLoader: _getEventsForDay,
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _selectedDay = focusedDay;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: ValueListenableBuilder<List<EventResponseDTO>>(
                  valueListenable: selectedEvent,
                  builder: (context, value, _) {
                    return ListView.builder(
                      itemCount: value.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute<EventDetailScreen>(
                                builder: (context) => EventDetailScreen(
                                  event: value[index],
                                  beneficiary: beneficiary,
                                ),
                              ),
                            ).then(
                              (value) {
                                setState(() {});
                              },
                            ),
                            title: Text(value[index].name),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
